-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (Test bench)
entity tb_dgate is
end tb_dgate;

-- Comportement du Test bench (simulation humaine)
architecture sim of tb_dgate is
    signal clk_sig : std_logic := '0'; -- Clock à 0 au démmarage
    signal d_sig   : std_logic := '0'; -- Entrée à 0 au démmarage
    signal q_sig   : std_logic;
begin
    DUT: entity work.dgate
        port map (clk => clk_sig, d => d_sig, q => q_sig);

    -- Génération de l'horloge (période de 20 ns)
    clk_process: process
    begin
        clk_sig <= '0'; wait for 10 ns;
        clk_sig <= '1'; wait for 10 ns;
    end process;

    -- Génération des entrées utilisateur
    stimulus: process
    begin
        wait for 25 ns;
        d_sig <= '1'; wait for 40 ns;
        d_sig <= '0'; wait for 30 ns;
        d_sig <= '1'; wait for 15 ns;
        d_sig <= '0'; wait;
    end process;
end sim;
