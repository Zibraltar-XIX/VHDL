-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (r_sel)
entity r_sel is
    port (
        a   : in  std_logic_vector(3 downto 0); -- Entrée de la donnée a
        b   : in  std_logic_vector(3 downto 0); -- Entrée de la donnée b
        s   : in  std_logic; -- Entrée pour la selection
        q   : out std_logic_vector(3 downto 0)  -- Sortie (la donnée mémorisée)
    );
end r_sel;

-- Comportement du composant
architecture arch_r_sel of r_sel is
begin
    process(s) -- Si le select passe à 1 et la clock est à 1, q prend la valeur de b. Sinon, q prend la valeur de a.
    begin
        if s = '1' then
            q <= b;
        else
            q <= a;
        end if;
    end process;
end arch_r_sel;