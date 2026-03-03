-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (Test bench)
entity tb_cpt is
end tb_cpt;

-- Comportement du Test bench (simulation humaine)
architecture sim of tb_cpt is
    signal clk_sig : std_logic := '0'; -- Clock à 0 au démmarage
    signal q_sig   : std_logic_vector(4 downto 0);
begin
    DUT: entity work.cpt
        port map (clk => clk_sig, q => q_sig);

    -- Génération de l'horloge (période de 40 ns)
    clk_process: process
    begin
        clk_sig <= '0'; wait for 20 ns;
        clk_sig <= '1'; wait for 20 ns;
    end process;
end sim;
