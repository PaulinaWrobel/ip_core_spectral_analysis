library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_textio.all;
use std.textio.all;
 
entity top_tb is
end top_tb;
 
architecture behav of top_tb is
    signal clk_tb      : std_logic := '1';
    signal clk_read    : std_logic := '1';
    signal rst_tb      : std_logic := '0';
    signal enable_tb   : std_logic := '0';
    signal data_in_tb  : std_logic_vector(23 downto 0) := (others => '0');
    signal dft_real_tb : std_logic_vector(31 downto 0);
    signal dft_imag_tb : std_logic_vector(31 downto 0);
    signal coeff_real  : std_logic;
    signal coeff_imag  : std_logic;
    signal address     : std_logic_vector(0 downto 0);
    signal command     : std_logic_vector(1 downto 0);
    signal coeff_real_slv : std_logic_vector(31 downto 0) := "00111111111111111111111110100010";
    signal coeff_imag_slv : std_logic_vector(31 downto 0) := "00000000000001101101101100100110";
    signal coeff_en : std_logic := '0';

    constant CLK_TB_PERIOD   : time := 10 ns;
    constant CLK_READ_PERIOD : time := 100 ns;
    constant DATA_WIDTH      : integer := 24;
    
begin

   uut: entity work.top 
   port map (
          clk        => clk_tb,
          rst        => rst_tb,
          enable     => enable_tb,
          data_in    => data_in_tb,
          dft_real   => dft_real_tb,
          dft_imag   => dft_imag_tb,
          coeff_real => coeff_real,
          coeff_imag => coeff_imag,
          address    => address,       
          command    => command
        );


    clk_tb    <= not clk_tb after CLK_TB_PERIOD/2;
    clk_read  <= not clk_read after CLK_READ_PERIOD/2;
    
    read_data: process (clk_read)
		file     file_input   : text open read_mode is "../data/data_in_100.txt";
		variable line_input   : line;
        variable data_in_file : integer range -32768 to 32767;
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
    
    
    
        -- enable_tb <= '1' after 40*CLK_READ_PERIOD;
    
    -- rst_tb    <= '1' after 20*CLK_READ_PERIOD, '0' after 35*CLK_READ_PERIOD;
    
    test_process: process
    begin
        wait for 100*CLK_READ_PERIOD;
        enable_tb <= '0';
        rst_tb    <= '0';
        wait for 10*CLK_READ_PERIOD;
        rst_tb    <= '1';
        wait for 6*CLK_READ_PERIOD;
        rst_tb    <= '0';
        coeff_en  <= '1';
        wait for 32*CLK_READ_PERIOD;
        coeff_en  <= '0';
        enable_tb <= '0';
        wait for CLK_READ_PERIOD;
        command   <= "01";
        address   <= "1";
        wait for CLK_READ_PERIOD;
        command   <= "11";
        enable_tb <= '1';
        wait for 1000*CLK_READ_PERIOD;
    end process test_process;
    
    coeff_process: process (clk_read)
    begin
        if clk_read'event and clk_read='1' and coeff_en='1' then
            coeff_real <= coeff_real_slv(coeff_real_slv'length - 1);
            coeff_real_slv <= coeff_real_slv(coeff_real_slv'length - 2 downto 0) & coeff_real_slv(coeff_real_slv'length - 1);
            coeff_imag <= coeff_imag_slv(coeff_imag_slv'length - 1);
            coeff_imag_slv <= coeff_imag_slv(coeff_imag_slv'length - 2 downto 0) & coeff_imag_slv(coeff_imag_slv'length - 1);
        end if;
    end process coeff_process;
    
   
   	sim_end_process: process
	begin
		wait for 200*CLK_READ_PERIOD;
		assert false
			report "End of simulation at time " & time'image(now)
			severity Failure;
    end process sim_end_process;

end architecture behav;
