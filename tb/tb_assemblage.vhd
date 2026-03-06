-- !!! FICHIER NON COMPLET !!!
-- !!! FICHIER NON VERIFIE !!!

-- Dans le TESTBENCH (pas dans le composant !)
architecture tb of tb_load_data is
    file input_file : text open read_mode is "plaintext.txt";  -- ton fichier 16 bits
    variable bit_line : line;
    variable bit_char : character;
begin
    process
    begin
        -- lit ligne par ligne
        while not endfile(input_file) loop
            readline(input_file, bit_line);
            read(bit_line, bit_char);
            bit_in <= bit_char;  -- envoie au composant
            wait for 40 ns;      -- 25Hz
        end loop;
        wait;
    end process;
end tb;
