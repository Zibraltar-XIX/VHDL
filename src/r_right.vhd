-- Importation des librairies
library ieee;
use ieee.std_logic_1164.all;

-- Définition du composant (r_right)
entity r_right is
    port (
        clk : in  std_logic;                    -- Entrée de l'horloge
        d   : in  std_logic;                    -- Entrée de la donnée
        q   : out std_logic_vector(3 downto 0)  -- Sortie (PAS de point-virgule ici !)
    );
end r_right;

-- Comportement du composant
architecture arch_r_right of r_right is
    signal reg : std_logic_vector(3 downto 0) := "0000"; -- Déclaration du signal interne pour mémoriser les 4 bits
begin
    process(clk) -- Si la clock passe à 1 on décale les données
    begin
        if rising_edge(clk) then
            reg <= d & reg(3 downto 1);
        end if;
    end process;

    q <= reg; -- On connecte en permanence notre registre interne vers la sortie physique

end arch_r_right;
