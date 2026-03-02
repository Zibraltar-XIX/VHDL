library ieee;
use ieee.std_logic_1164.all;

entity tb_r_right is
end tb_r_right;

architecture sim of tb_r_right is
    signal clk_sig : std_logic := '0';
    signal d_sig   : std_logic := '0';
    signal q_sig   : std_logic_vector(3 downto 0);
begin
    DUT: entity work.r_right
        port map (
        clk => clk_sig,
        d   => d_sig,
        q   => q_sig
        );

    -- Générateur d'horloge (Période = 10 ms)
    clk_process: process
    begin
        clk_sig <= '0'; wait for 5 ms;
        clk_sig <= '1'; wait for 5 ms;
    end process;

    stimulus: process
    begin
        wait for 12 ms;
        d_sig <= '1';
        wait for 10 ms;
        d_sig <= '0';
        wait for 40 ms;
        d_sig <= '1'; wait for 20 ms;
        d_sig <= '0'; wait for 20 ms;
        wait;
    end process;
end sim;
