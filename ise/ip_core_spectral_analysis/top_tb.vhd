library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_textio.all;
use std.textio.all;
 
entity top_tb is
end top_tb;
 
architecture behav of top_tb is
    signal clk_tb : std_logic := '1';
    signal clk_read : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal enable_tb : std_logic := '0';
    signal data_in_tb : std_logic_vector(23 downto 0) := (others => '0');
    signal data_out_tb : std_logic_vector(24 downto 0);

    constant CLK_TB_PERIOD : time := 10 ns;
    constant CLK_READ_PERIOD : time := 100 ns;
    constant DATA_WIDTH : integer := 24;

begin

   uut: entity work.top 
   port map (
          clk => clk_tb,
          rst => rst_tb,
          enable => enable_tb,
          data_in => data_in_tb,
          data_out => data_out_tb
        );


    clk_tb_signal: clk_tb <= not clk_tb after CLK_TB_PERIOD;
    clk_read_signal: clk_read <= not clk_read after CLK_READ_PERIOD;
    enable_signal: enable_tb <= '1' after 40*CLK_READ_PERIOD;
    
    rst_signal: rst_tb <= '1' after 20*CLK_READ_PERIOD, '0' after 35*CLK_READ_PERIOD;
    
    
    read_data: process (clk_read)
		file file_input: text open read_mode is "../../../data/data_in_100.txt";
		variable line_input: line;
        variable data_in_file: integer range -32768 to 32767;
	begin
		if clk_read='1' and clk_read'event and enable_tb='1' then
			if endfile(file_input) then
				assert false
					report "End of file"
					severity Failure;
			else
	        	readline(file_input, line_input);
				read(line_input, data_in_file);
                data_in_tb <= std_logic_vector(to_signed(data_in_file,data_in_tb'length));
			end if;
		end if;
    end process read_data;
    
    
    
    
    
    
    
    
   
   	sim_end_process: process
	begin
		wait for 100*CLK_READ_PERIOD;
		assert false
			report "End of simulation at time " & time'image(now)
			severity Failure;
    end process sim_end_process;

end architecture behav;
