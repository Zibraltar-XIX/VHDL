-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (Dgate)
entity dgate is
    port (
        clk : in  std_logic; -- Entrée de l'horloge
        d   : in  std_logic; -- Entrée de la donnée
        q   : out std_logic  -- Sortie (la donnée mémorisée)
    );
end dgate;

-- Comportement du composant
architecture dgate_fonction of dgate is
begin
    process(clk) -- Si la clock passe à 1, q prend la valeur de d
    begin
        if rising_edge(clk) then
            q <= d;
        end if;
    end process;
end dgate_fonction;