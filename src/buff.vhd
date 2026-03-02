-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (buff)
entity buff is
    port (
        clk : in  std_logic; -- Entrée de l'horloge
        d   : in  std_logic_vector(3 downto 0); -- Entrée de la donnée
        q   : out std_logic_vector(3 downto 0)  -- Sortie (la donnée mémorisée)
    );
end buff;

-- Comportement du composant
architecture arch_buff of buff is
begin
    process(clk) -- Si la clock passe à 1, q prend la valeur de d
    begin
        if rising_edge(clk) then
            q <= d;
        end if;
    end process;
end arch_buff;