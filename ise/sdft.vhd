library ieee;
use ieee.std_logic_1164.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

entity sdft is
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
        coeff_real : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        coeff_imag : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        dft_real : out std_logic_vector(STATE_INTEGER-1 downto 0);
        dft_imag : out std_logic_vector(STATE_INTEGER-1 downto 0)
    );
end sdft;

architecture behav of sdft is
    signal coeff_real_temp: std_logic_vector(COEFF_LENGTH-1 downto 0);
    signal coeff_imag_temp: std_logic_vector(COEFF_LENGTH-1 downto 0);
    signal coeff_real_fixed: sfixed(1 downto -COEFF_LENGTH+2);
    signal coeff_imag_fixed: sfixed(1 downto -COEFF_LENGTH+2);
    
    signal state_real: sfixed(STATE_INTEGER-1 downto -STATE_FRACTION);
    signal state_imag: sfixed(STATE_INTEGER-1 downto -STATE_FRACTION);
    signal state_real_temp: sfixed(STATE_INTEGER-1 downto -STATE_FRACTION);
    signal state_imag_temp: sfixed(STATE_INTEGER-1 downto -STATE_FRACTION);
    signal data: sfixed(STATE_INTEGER-1 downto -STATE_FRACTION);
    
    signal calc_en: std_logic := '0';
    
    type state_fsm_type is (IDLE, RESET, SET1, SET2, CALC);
    signal state_fsm: state_fsm_type;

begin
    
    data <= resize(to_sfixed(data_in,DATA_WIDTH,0),data);
    calc_en <= enable;
    
    coeff_real_temp <= coeff_real;
    coeff_imag_temp <= coeff_imag;
    
    coeff_real_fixed <= to_sfixed(coeff_real_temp, coeff_real_fixed);
    coeff_imag_fixed <= to_sfixed(coeff_imag_temp, coeff_imag_fixed);
    
    state_process: process (clk)
    begin
        if clk'event and clk='1' then
            if rst = '1' then
                state_real_temp <= (others => '0');
                state_imag_temp <= (others => '0');
            elsif calc_en='1' then
                state_real_temp <= resize(data + (state_real*coeff_real_fixed - state_imag*coeff_imag_fixed),state_real_temp);
                state_imag_temp <= resize(state_real*coeff_imag_fixed + state_imag*coeff_real_fixed,state_real_temp);
            else
                state_real_temp <= state_real_temp;
                state_imag_temp <= state_imag_temp;
            end if;
        end if;
    end process state_process;
    
    state_real <= state_real_temp;
    state_imag <= state_imag_temp;
    
    dft_real <= to_slv(resize(state_real,STATE_INTEGER-1,0));
    dft_imag <= to_slv(resize(state_imag,STATE_INTEGER-1,0));
    

end behav;

