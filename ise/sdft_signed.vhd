library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdft is
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
end sdft;

architecture behav of sdft is
    signal coeff_real_fixed : signed(COEFF_LENGTH-1 downto 0);
    signal coeff_imag_fixed : signed(COEFF_LENGTH-1 downto 0);
    
    signal state_real       : signed(STATE_INTEGER+STATE_FRACTION-1 downto 0);
    signal state_imag       : signed(STATE_INTEGER+STATE_FRACTION-1 downto 0);
    signal state_real_temp  : signed(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-1 downto 0);
    signal state_imag_temp  : signed(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-1 downto 0);
    
    signal data             : signed(DATA_WIDTH+STATE_FRACTION+COEFF_LENGTH-2 downto 0);
    signal data_zeros       : std_logic_vector(STATE_FRACTION+COEFF_LENGTH-3 downto 0) := (others => '0');

begin

    data <= signed(data_in & data_zeros); 
    coeff_real_fixed <= signed(coeff_real);
    coeff_imag_fixed <= signed(coeff_imag);
    
    state_process: process (clk)
    begin
        if clk'event and clk='1' then
            if rst = '1' then
                state_real_temp <= (others => '0');
                state_imag_temp <= (others => '0');
            elsif enable='1' then
                state_real_temp <= data + (state_real*coeff_real_fixed - state_imag*coeff_imag_fixed);
                state_imag_temp <= state_real*coeff_imag_fixed + state_imag*coeff_real_fixed;
            else
                state_real_temp <= state_real_temp;
                state_imag_temp <= state_imag_temp;
            end if;
        end if;
    end process state_process;
    
    state_real <= state_real_temp(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-3 downto COEFF_LENGTH-2);
    state_imag <= state_imag_temp(STATE_INTEGER+STATE_FRACTION+COEFF_LENGTH-3 downto COEFF_LENGTH-2);
    
    dft_real <= std_logic_vector(state_real(STATE_INTEGER+STATE_FRACTION-1 downto STATE_FRACTION));
    dft_imag <= std_logic_vector(state_imag(STATE_INTEGER+STATE_FRACTION-1 downto STATE_FRACTION));

end behav;

