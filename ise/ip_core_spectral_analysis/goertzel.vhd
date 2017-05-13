library ieee;
use ieee.std_logic_1164.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

entity goertzel is
    generic (
        DATA_WIDTH : integer := 24;
        COEFF_LENGTH : integer := 32;
        STATE_INTEGER : integer := 32;
        STATE_FRACTION : integer := 32
    );
    port (
        enable : in std_logic;
        rst : in std_logic;
        clk : in std_logic;
        data_in : in std_logic_vector(DATA_WIDTH downto 0);
        coeff : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        dft_real : out std_logic_vector(STATE_INTEGER-1 downto 0);
        dft_imag : out std_logic_vector(STATE_INTEGER-1 downto 0)
    );
end goertzel;

architecture behav of goertzel is
    signal coeff_real_temp: std_logic_vector(COEFF_LENGTH-1 downto 0);
    signal coeff_imag_temp: std_logic_vector(COEFF_LENGTH-1 downto 0);
    signal coeff_real: sfixed(1 downto -COEFF_LENGTH+2) := (others => '0');
    signal coeff_imag: sfixed(1 downto -COEFF_LENGTH+2) := (others => '0');
    signal coeff_cos: sfixed(2 downto -COEFF_LENGTH+3) := (others => '0');
    
    signal state_real: sfixed(STATE_INTEGER-1 downto -STATE_FRACTION) := (others => '0');
    signal state_imag: sfixed(STATE_INTEGER-1 downto -STATE_FRACTION) := (others => '0');
    signal data: sfixed(STATE_INTEGER-1 downto -STATE_FRACTION) := (others => '0');

begin

    data <= resize(to_sfixed(data_in,DATA_WIDTH,0),data);
    
    coeff_process: process (clk)
    begin
    
    
    end process coeff_process;
    
    coeff_real <= to_sfixed(coeff_real_temp, coeff_real);
    coeff_imag <= to_sfixed(coeff_imag_temp, coeff_imag);
    
    state_process: process (clk)
    begin
        if clk'event and clk='1' then
            state_real <= resize(data + (state_real*coeff_real - state_imag*coeff_imag),state_real);
            state_imag <= resize(state_real*coeff_imag + state_imag*coeff_real,state_real);
        end if;
    end process state_process;
    
    dft_real <= to_slv(resize(state_real,STATE_INTEGER-1,0));
    dft_imag <= to_slv(resize(state_imag,STATE_INTEGER-1,0));

end behav;

