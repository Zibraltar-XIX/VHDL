-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (Test bench)
entity tb_assemblage is
end tb_assemblage;

-- Comportement du Test bench (simulation humaine)
architecture sim of tb_assemblage is
    signal clk_sig : std_logic := '0';
    signal d_sig   : std_logic := '0';
    signal k_sig   : std_logic_vector(3 downto 0) := "1010";
    signal q_sig   : std_logic_vector(3 downto 0);
begin
    DUT: entity work.assemblage
        port map (clk => clk_sig, d => d_sig, k => k_sig, q => q_sig);

    -- Génération de l'horloge (période de 10 ms = 100 Hz)
    clk_process: process
    begin
        clk_sig <= '0'; wait for 5 ms;
        clk_sig <= '1'; wait for 5 ms;
    end process;

    -- Injection du plaintext 16 bits en série : 1100 1010 0110 1001
    stimulus: process
    begin
        wait for 2 ms;
        -- Bloc 1 : 1100
        d_sig <= '1'; wait for 10 ms;
        d_sig <= '1'; wait for 10 ms;
        d_sig <= '0'; wait for 10 ms;
        d_sig <= '0'; wait for 10 ms;
        -- Bloc 2 : 1010
        d_sig <= '1'; wait for 10 ms;
        d_sig <= '0'; wait for 10 ms;
        d_sig <= '1'; wait for 10 ms;
        d_sig <= '0'; wait for 10 ms;
        -- Bloc 3 : 0110
        d_sig <= '0'; wait for 10 ms;
        d_sig <= '1'; wait for 10 ms;
        d_sig <= '1'; wait for 10 ms;
        d_sig <= '0'; wait for 10 ms;
        -- Bloc 4 : 1001
        d_sig <= '1'; wait for 10 ms;
        d_sig <= '0'; wait for 10 ms;
        d_sig <= '0'; wait for 10 ms;
        d_sig <= '1'; wait for 10 ms;
        -- Fin de l'injection, on laisse tourner le rebouclage
        d_sig <= '0';
        wait for 500 ms;
        wait;
    end process;
end sim;
