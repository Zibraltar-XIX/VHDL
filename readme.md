# Installation des outils
**Sur IntelliJ/VScode :**

Installer le plugin "VHDL"

**Sur Linux :**
```` bash
sudo apt update
sudo apt install ghdl gtkwave make
````

# Execution du Makefile
**Commande view :** `make view TESTBENCH=nom_testbench SRC_FILE=src/code.vhd`

Ou `nom_testbench` le nom du test bench dans `/tb` (ex: `tb_dgate` pour `tb_dgate.vhd`)

Et `src/code.vhd` le composant / circuit à tester.

---

**Commande clean :** `make clean TESTBENCH=nom_testbench`

ou `TESTBENCH=nom_testbench` le composant / circuit testé à clean.

# Explication VHDL
## Circuits et composants
```` vhdl
library ieee;
use ieee.std_logic_1164.all;
````
Importe les librairies de l'IEEE (standard de l'électronique)

---
````vhdl
entity nomcomposant is
    port (
        clk : in  std_logic;
        d   : in  std_logic;
        q   : out std_logic
    );
end nomcomposant;
````
Définition du composant (ici `nomcomposant`) et de ses broches dans `port` (ici clk, d et q)

---
````vhdl
architecture fonctionnement_composant of composant is
    signal r : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            r <= d;
        end if;
    end process;

    process(a, b, sel)
    begin
        if sel = '0' then
            y <= a;
        else
            y <= b;
        end if;
    end process;

    q <= r;
end fonctionnement_composant;
````
Décrit le comportement interne d’un composant. Ce sont des “règles” qui tournent en parallèle.

Le `process(clk)` avec `rising_edge(clk)` décrit une logique qui s'execute seulement quand la `clk` passe à 1.

Le `process(a, b, sel)` décrit une logique combinatoire : dès qu’une entrée change, on recalcule la sortie (comme un mux/porte).

Les signaux (ex: `r`) sont des fils internes, et `<=` affecte des signaux (ça modélise une mise à jour matérielle, pas une variable “logicielle”).

## Test bench
```` vhdl
library ieee;
use ieee.std_logic_1164.all;
````
Importe les librairies de l'IEEE (standard de l'électronique)

---
````vhdl
entity tb is
end tb;
````
Déclaration du composant test bench.

---
````vhdl
signal clk_sig : std_logic := '0';
signal d_sig   : std_logic := '0';
signal q_sig   : std_logic;
````
On définit les signaux présents sur le test bench avec la possibilité de mettre une valeur par défault au démarrage.

---
````vhdl
DUT: entity work.composant
    port map (clk => clk_sig, d => d_sig, q => q_sig);
````
- `DUT` signifie Device Under Test (le composant que l'on teste).
- `entity work.dgate` dit au simulateur : "Prends le composant `composant` qu'on a codé tout à l'heure et pose-le ici".
- `port map(...)` ici on map les broches du composant avec le test bench.