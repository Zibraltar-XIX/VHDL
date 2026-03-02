-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (Test bench)
entity tb_buff is
end tb_buff;

-- Comportement du Test bench (simulation humaine)
architecture sim of tb_buff is
    signal clk_sig : std_logic := '0'; -- Clock à 0 au démmarage
    signal d_sig   : std_logic_vector(3 downto 0) := "0000"; -- Entrée à 0 au démmarage
    signal q_sig   : std_logic_vector(3 downto 0);
begin
    DUT: entity work.buff
        port map (clk => clk_sig, d => d_sig, q => q_sig);

    -- Génération de l'horloge (période de 40 ns)
    clk_process: process
    begin
        clk_sig <= '0'; wait for 20 ns;
        clk_sig <= '1'; wait for 20 ns;
    end process;

    -- Génération des entrées utilisateur
    stimulus: process
    begin
        wait for 25 ns;
        d_sig <= "1010"; wait for 50 ns;
        d_sig <= "1111"; wait for 60 ns;
        d_sig <= "1010"; wait for 50 ns;
        d_sig <= "1011"; wait for 60 ns;
        wait;
    end process;
end sim;
