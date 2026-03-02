-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (Test bench)
entity tb_mux is
end tb_mux;

-- Comportement du Test bench (simulation humaine)
architecture sim of tb_mux is
    signal s_sig : std_logic := '0'; -- Clock à 0 au démmarage
    signal a_sig   : std_logic := '0'; -- Entrée a à 0 au démmarage
    signal b_sig   : std_logic := '1'; -- Entrée a à 1 au démmarage
    signal q_sig   : std_logic;
begin
    DUT: entity work.mux
        port map (s => s_sig, a => a_sig, b => b_sig, q => q_sig);

    -- Génération du select
    select_process: process
    begin
        s_sig <= '0'; wait for 10 ns;
        s_sig <= '1'; wait for 35 ns;
        s_sig <= '0'; wait for 15 ns;
        s_sig <= '0'; wait for 40 ns;
    end process;
end sim;
