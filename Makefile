# Règle principale : tout faire jusqu'à l'affichage
all: view

# Règle pour créer le dossier de simulation
sim:
	mkdir -p sim

# Règle de compilation (Analyse et Elaboration)
compile: sim
	@echo "=> Compilation de $(SRC_FILE)..."
	ghdl -a --workdir=sim --std=08 $(SRC_FILE)
	@echo "=> Compilation de tb/$(TESTBENCH).vhd..."
	ghdl -a --workdir=sim --std=08 tb/$(TESTBENCH).vhd
	@echo "=> Elaboration de $(TESTBENCH)..."
	ghdl -e --workdir=sim --std=08 $(TESTBENCH)

# Règle de simulation (Génération du fichier VCD)
run: compile
	@echo "=> Simulation en cours..."
	ghdl -r --workdir=sim --std=08 $(TESTBENCH) --stop-time=$(TIME) --vcd=sim/wave.vcd

# Règle pour afficher les chronogrammes
view: run
	@echo "=> Lancement de GTKWave..."
	gtkwave sim/wave.vcd &

# Règle pour tout nettoyer
clean:
	@echo "=> Nettoyage des fichiers temporaires..."
	rm -rf sim $(TESTBENCH) *.o