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

# Explication composant
## Partie 1
### Dgate
La bascule D (D-gate) est une mémoire sur 1 bit. C'est un composant qui copie la valeur de son entrée de donnée (D) vers sa sortie (Q) uniquement au moment précis d'un front montant d'horloge (clk). Le reste du temps, elle ignore les changements sur D et maintient sa sortie stable, agissant ainsi comme une case de stockage d'un bit.

### Mux
Un MUX est l'équivalent électronique d'un aiguillage. C'est un composant qui possède plusieurs entrées de données mais une seule sortie. Il utilise une entrée supplémentaire appelée "sélecteur" (comme une télécommande) pour choisir laquelle des entrées de données a le droit de traverser pour atteindre la sortie.

## Partie 2
### Registre à décalage
Un registre à décalage est une file d'attente de mémoire composée de plusieurs Dgate branchées à la chaîne. À chaque front montant d'horloge, tous les bits mémorisés avancent simultanément d'une case vers la droite, laissant entrer une nouvelle donnée d'un côté et expulsant la donnée la plus ancienne de l'autre côté.

### Registre de stockage
Un registre de stockage (Buffer) est une mémoire multi-bits (ici 4). Il prend en entrée plusieurs fils simultanément (un vecteur de données) et "photographie" leur état global au moment précis d'un front d'horloge, pour le copier instantanément et le maintenir sur sa sortie jusqu'au prochain signal de l'horloge. C'est une Dgate sur 4 bits.

### Registre de sélection
Un registre de sélection est un multiplexeur qui marche sur 4 bits. À chaque front d'horloge, il évalue l'état de sa broche de sélection (pour choisir entre l'entrée A et l'entrée B), puis il capture et mémorise de manière synchrone le vecteur de données choisi pour l'afficher sur sa sortie.

### Compteur
Un compteur est une mémoire qui s'auto-incrémente. À chaque front d'horloge, il lit son état interne, passe à la valeur binaire suivante (ou précédente) de sa séquence, et mémorise ce nouveau nombre sur sa sortie pour comptabiliser les cycles ou les événements écoulés.