library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity goertzel is
    generic (
        DATA_WIDTH     : integer := 24;
        COEFF_LENGTH   : integer := 32;
        STATE_INTEGER  : integer := 32;
        STATE_FRACTION : integer := 32
    );
    port (
        enable     : in std_logic;
        rst        : in std_logic;
        clk        : in std_logic;
        data_in    : in std_logic_vector(DATA_WIDTH downto 0);
        coeff_real : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        coeff_imag : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        dft_real   : out std_logic_vector(STATE_INTEGER-1 downto 0);
        dft_imag   : out std_logic_vector(STATE_INTEGER-1 downto 0)
    );
end goertzel;

architecture behav of goertzel is
    signal coeff_real_fixed   : signed(COEFF_LENGTH-1 downto 0);
    signal coeff_imag_fixed   : signed(COEFF_LENGTH-1 downto 0);
    signal coeff_cos          : signed(COEFF_LENGTH-1 downto 0);
    
    signal state              : signed(STATE_INTEGER+STATE_FRACTION-1 downto 0);
    signal state_delay        : signed(STATE_INTEGER+STATE_FRACTION-1 downto 0);
    signal state_temp         : signed(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-1 downto 0);
    signal state_zeros        : std_logic_vector(COEFF_LENGTH-4 downto 0) := (others => '0');
    signal state_delay_zeros  : signed(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-4 downto 0);
    
    signal output_real        : signed(STATE_INTEGER+STATE_FRACTION-1 downto 0);
    signal output_imag        : signed(STATE_INTEGER+STATE_FRACTION-1 downto 0);
    signal output_real_temp   : signed(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-1 downto 0);
    signal output_imag_temp   : signed(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-1 downto 0);
    signal output_zeros       : std_logic_vector(COEFF_LENGTH-3 downto 0) := (others => '0');
    signal state_output_zeros : signed(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-3 downto 0);
    
    signal data               : signed(DATA_WIDTH+STATE_FRACTION+COEFF_LENGTH-3 downto 0);
    signal data_zeros         : std_logic_vector(STATE_FRACTION+COEFF_LENGTH-4 downto 0) := (others => '0');

begin

    data <= signed(data_in & data_zeros); 
    coeff_real_fixed <= signed(coeff_real);
    coeff_imag_fixed <= signed(coeff_imag);
    coeff_cos <= signed(coeff_real);
    
    state_process: process (clk)
    begin
        if clk'event and clk='1' then
            if rst = '1' then
                state_temp  <= (others => '0');
                state_delay <= (others => '0');
            elsif enable='1' then
                state_temp  <= data + (state*coeff_cos) - state_delay_zeros;
                state_delay <= state;
            else
                state_temp  <= state_temp;
                state_delay <= state_delay;
            end if;
        end if;
    end process state_process;

    state <= state_temp(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-4 downto COEFF_LENGTH-3);
    state_delay_zeros <= signed(std_logic_vector(state_delay) & std_logic_vector(state_zeros));

    output_process: process (clk)
    begin
        if clk'event and clk='1' then
            if rst = '1' then
                output_real_temp <= (others => '0');
                output_imag_temp <= (others => '0');
            elsif enable='1' then
                output_real_temp <= state_output_zeros - (state_delay*coeff_real_fixed);
                output_imag_temp <= state_delay*coeff_imag_fixed;
            else
                output_real_temp <= output_real_temp;
                output_imag_temp <= output_imag_temp;
            end if;
        end if;
    end process output_process;
    
    output_real <= output_real_temp(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-3 downto COEFF_LENGTH-2);
    output_imag <= output_imag_temp(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-3 downto COEFF_LENGTH-2);
    state_output_zeros <= signed(std_logic_vector(state) & std_logic_vector(output_zeros));

    dft_real <= std_logic_vector(output_real(STATE_INTEGER+STATE_FRACTION-1 downto STATE_FRACTION));
    dft_imag <= std_logic_vector(output_imag(STATE_INTEGER+STATE_FRACTION-1 downto STATE_FRACTION));

end behav;

