-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (Test bench)
entity tb_r_sel is
end tb_r_sel;

-- Comportement du Test bench (simulation humaine)
architecture sim of tb_r_sel is
    signal clk_sig : std_logic := '0'; -- Clock à 0 au démmarage
    signal s_sig : std_logic := '0'; -- Select à 0 au démmarage
    signal a_sig   : std_logic_vector(3 downto 0) := "0000"; -- Entrée a à 0 au démmarage
    signal b_sig   : std_logic_vector(3 downto 0) := "0000"; -- Entrée a à 1 au démmarage
    signal q_sig   : std_logic_vector(3 downto 0);
begin
    DUT: entity work.r_sel
        port map (clk => clk_sig, s => s_sig, a => a_sig, b => b_sig, q => q_sig);

    -- Génération de l'horloge (période de 40 ns)
    clk_process: process
    begin
        clk_sig <= '0'; wait for 20 ns;
        clk_sig <= '1'; wait for 20 ns;
    end process;

    -- Génération du select
    select_process: process
    begin
        s_sig <= '0'; wait for 10 ns;
        s_sig <= '1'; wait for 35 ns;
        s_sig <= '0'; wait for 15 ns;
        s_sig <= '0'; wait for 40 ns;
    end process;

    -- Génération des entrées utilisateur pour a
    stimulus_a: process
    begin
        wait for 25 ns;
        a_sig <= "1010"; wait for 50 ns;
        a_sig <= "1111"; wait for 60 ns;
        a_sig <= "1010"; wait for 50 ns;
        a_sig <= "1011"; wait for 60 ns;
    end process;

    -- Génération des entrées utilisateur pour b
    stimulus_b: process
    begin
        wait for 25 ns;
        b_sig <= "1110"; wait for 50 ns;
        b_sig <= "1110"; wait for 60 ns;
        b_sig <= "1011"; wait for 50 ns;
        b_sig <= "1001"; wait for 60 ns;
    end process;

end sim;
