-- !!! FICHIER NON COMPLET !!!
-- !!! FICHIER NON VERIFIE !!!

-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Définition du composant (assemblage)
entity assemblage is
    port (
        clk : in  std_logic; -- Entrée de l'horloge
        s   : in  std_logic; -- Select pour bouclage ou non
        d   : in std_logic;  -- Entrée de données
        k   : in std_logic_vector(3 downto 0); -- Clé de chiffrement
        q   : out std_logic_vector(3 downto 0)  -- Sortie (la donnée mémorisée)
    );
end assemblage;

-- Comportement du composant
architecture arch_assemblage of assemblage is
    signal compte_interne : unsigned(1 downto 0) := "00";
    signal r_right : std_logic_vector(3 downto 0) := "0000";
    signal load_data : std_logic_vector(3 downto 0) := "0000";
    signal sub_bit1 : std_logic_vector(3 downto 0) := "0000";
    signal sub_bit2 : std_logic_vector(3 downto 0) := "0000";
    signal sub_bit3 : std_logic := '0';
    signal row_shift1 : std_logic_vector(3 downto 0) := "0000";
    signal row_shift2 : std_logic_vector(3 downto 0) := "0000";
    signal flip_bit1 : std_logic_vector(3 downto 0) := "0000";
    signal flip_bit2 : std_logic_vector(3 downto 0) := "0000";
    signal output : std_logic_vector(3 downto 0) := "0000";

begin

    -- Load data
    process(clk)
    begin
        if rising_edge(clk) then
            r_right <= d & r_right(3 downto 1);
        end if;

        if rising_edge(clk) then
            if compte_interne = "11" then
                load_data <= r_right;
                compte_interne <= "00"; -- Remise à 0 du compteur quand on atteint 4
            else
                compte_interne <= compte_interne + 1;
            end if;
        end if;
    end process;

    -- Sub Bits
    process(clk)
    begin
        if rising_edge(clk) then
            if s <= '0' then
                sub_bit3 <= not sub_bit2(0);
                sub_bit2 <= sub_bit1;
                sub_bit1 <= output;
            end if;

            if s <= '1' then
                sub_bit3 <= not sub_bit2(0);
                sub_bit2 <= sub_bit1;
                sub_bit1 <= load_data;
            end if;
        end if;
    end process;

    -- Row Shift
    process(clk)
    begin
        if rising_edge(clk) then
            -- Le row shift 2 prend la valeur du row shift 1 avec un décalage de 1bit
            row_shift2(0) <= row_shift1(3);
            row_shift2(1) <= row_shift1(0);
            row_shift2(2) <= row_shift1(1);
            row_shift2(3) <= row_shift1(2);

            row_shift1 <= sub_bit2;
            row_shift1(0) <= sub_bit3;
        end if;
    end process;

    -- Flib bit
    process(clk)
    begin
        if rising_edge(clk) then
            flip_bit1 <= row_shift2;
            flip_bit2(0) <= flip_bit1(0);
            flip_bit2(1) <= flip_bit1(3);
            flip_bit2(2) <= flip_bit1(2);
            flip_bit2(3) <= flip_bit1(1);
        end if;
    end process;

    -- Mix Key
    process(clk)
    begin
        if rising_edge(clk) then
            output(3) <= flip_bit2(3) xor k(3);
            output(2) <= flip_bit2(2) xor k(2);
            output(1) <= flip_bit2(1) xor k(1);
            output(0) <= flip_bit2(0) xor k(0);
        end if;
    end process;

    q <= output; -- Assignation de la sortie
end arch_assemblage;