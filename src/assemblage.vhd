-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Définition du composant (assemblage)
entity assemblage is
    port (
        clk : in  std_logic;                    -- Horloge
        d   : in  std_logic;                    -- Entrée des données
        k   : in  std_logic_vector(3 downto 0); -- Clé de chiffrement
        q   : out std_logic_vector(3 downto 0)  -- Sortie
    );
end assemblage;

-- Architecture du composant
architecture arch_assemblage of assemblage is

    component r_right is
        port (
            clk : in  std_logic;
            d   : in  std_logic;
            q   : out std_logic_vector(3 downto 0)
        );
    end component;

    component buff is
        port (
            clk : in  std_logic;
            d   : in  std_logic_vector(3 downto 0);
            q   : out std_logic_vector(3 downto 0)
        );
    end component;

    component r_sel is
        port (
            a   : in  std_logic_vector(3 downto 0);
            b   : in  std_logic_vector(3 downto 0);
            s   : in  std_logic;
            q   : out std_logic_vector(3 downto 0)
        );
    end component;

    component cpt is
        port (
            clk : in  std_logic;
            q   : out std_logic_vector(4 downto 0)
        );
    end component;

    -- Signaux internes
    signal clk_div4       : std_logic := '0';
    signal clk_div_cnt    : unsigned(1 downto 0) := "00";
    signal cpt_out        : std_logic_vector(4 downto 0);
    signal sel_auto       : std_logic := '1';
    signal load_data_out  : std_logic_vector(3 downto 0);
    signal sel_out        : std_logic_vector(3 downto 0);
    signal sub_bit_s1     : std_logic_vector(3 downto 0);
    signal sub_bit_comb   : std_logic_vector(3 downto 0);
    signal sub_bit_s2     : std_logic_vector(3 downto 0);
    signal row_shift_comb : std_logic_vector(3 downto 0);
    signal row_shift_out  : std_logic_vector(3 downto 0);
    signal flip_bit_comb  : std_logic_vector(3 downto 0);
    signal flip_bit_out   : std_logic_vector(3 downto 0);
    signal mix_key_comb   : std_logic_vector(3 downto 0);

begin

    -- Diviseur d'horloge : clk (100 Hz) -> clk_div4 (25 Hz)
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_div_cnt = "01" then
                clk_div4 <= not clk_div4;
                clk_div_cnt <= "00";
            else
                clk_div_cnt <= clk_div_cnt + 1;
            end if;
        end if;
    end process;

    -- Compteur (25 Hz)
    cpt_inst : cpt
        port map (clk => clk_div4, q => cpt_out);

    -- Selection plaintext/feedback (latch : reste en mode feedback une fois active)
    process(clk_div4)
    begin
        if rising_edge(clk_div4) then
            if unsigned(cpt_out) >= 3 then
                sel_auto <= '0';
            end if;
        end if;
    end process;

    -- Load Data : registre a decalage serie -> parallele (100 Hz)
    load_data_inst : r_right
        port map (clk => clk, d => d, q => load_data_out);

    -- Selecteur : plaintext (sel_auto='1') ou feedback (sel_auto='0')
    sel_inst : r_sel
        port map (a => mix_key_comb, b => load_data_out, s => sel_auto, q => sel_out);

    -- Sub Bit (etage 1/4) : buffer d'entree
    sub_bit_buff1 : buff
        port map (clk => clk_div4, d => sel_out, q => sub_bit_s1);

    -- Sub Bit : inversion du bit 0
    sub_bit_comb(3) <= sub_bit_s1(3);
    sub_bit_comb(2) <= sub_bit_s1(2);
    sub_bit_comb(1) <= sub_bit_s1(1);
    sub_bit_comb(0) <= not sub_bit_s1(0);

    -- Sub Bit (etage 2/4) : buffer de sortie
    sub_bit_buff2 : buff
        port map (clk => clk_div4, d => sub_bit_comb, q => sub_bit_s2);

    -- Row Shift (etage 3/4) : decalage circulaire vers le bas
    row_shift_comb(0) <= sub_bit_s2(3);
    row_shift_comb(1) <= sub_bit_s2(0);
    row_shift_comb(2) <= sub_bit_s2(1);
    row_shift_comb(3) <= sub_bit_s2(2);

    row_shift_buff : buff
        port map (clk => clk_div4, d => row_shift_comb, q => row_shift_out);

    -- Flip Bit (etage 4/4) : echange des bits 1 et 3
    flip_bit_comb(0) <= row_shift_out(0);
    flip_bit_comb(1) <= row_shift_out(3);
    flip_bit_comb(2) <= row_shift_out(2);
    flip_bit_comb(3) <= row_shift_out(1);

    flip_bit_buff : buff
        port map (clk => clk_div4, d => flip_bit_comb, q => flip_bit_out);

    -- Mix Key : XOR avec la cle (combinatoire, pas de buffer)
    mix_key_comb <= flip_bit_out xor k;

    -- Sortie
    q <= mix_key_comb;

end arch_assemblage;
