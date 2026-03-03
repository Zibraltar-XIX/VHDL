-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Définition du composant (compteur)
entity cpt is
    port (
        clk : in  std_logic; -- Entrée de l'horloge
        q   : out std_logic_vector(4 downto 0)  -- Sortie (la donnée mémorisée)
    );
end cpt;

-- Comportement du composant
architecture arch_cpt of cpt is
    signal compte_interne : unsigned(4 downto 0) := "00000"; -- Compteur initialisé à 0
begin
    process(clk) -- Si la clock passe à 1, le compteur s'incrémente de 1
    begin
        if rising_edge(clk) then
            if compte_interne = "10000" then
                compte_interne <= "00000"; -- Remise à 0 quand on atteint 16
            else
                compte_interne <= compte_interne + 1;
            end if;
        end if;
    end process;

    q <= std_logic_vector(compte_interne);
end arch_cpt;