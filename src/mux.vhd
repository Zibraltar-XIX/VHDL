-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (mux)
entity mux is
    port (
        a   : in  std_logic; -- Entrée de l'horloge
        b   : in  std_logic; -- Entrée de la donnée
        s   : in  std_logic; -- Entrée pour la selection
        q   : out std_logic  -- Sortie
    );
end entity mux;

-- Comportement du composant
architecture arch_mux of mux is
begin
    process(a, b, s) -- Si le select passe à 1, q prend la valeur de b
    begin
        if s = '1' then
            q <= b;
        else
            q <= a;
        end if;
    end process;
end architecture arch_mux;