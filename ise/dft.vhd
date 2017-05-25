library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft is
    generic (
        DATA_WIDTH     : integer   := 24;
        COEFF_LENGTH   : integer   := 32;
        STATE_INTEGER  : integer   := 32;
        STATE_FRACTION : integer   := 32;
        ALGORITHM      : std_logic := '0';
        DFT_ADDRESS    : integer   := 1;
        DFT_NUMBER     : integer   := 1
    );
    port (
        enable     : in std_logic;
        rst        : in std_logic;
        clk        : in std_logic;
        data_in    : in std_logic_vector(DATA_WIDTH downto 0);
        coeff_real : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        coeff_imag : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        dft_real   : out std_logic_vector(STATE_INTEGER-1 downto 0);
        dft_imag   : out std_logic_vector(STATE_INTEGER-1 downto 0);
        address    : in integer range 0 to DFT_NUMBER;
        command    : in std_logic_vector(1 downto 0)
    );
end dft;

architecture behav of dft is
    signal coeff_real_dft : std_logic_vector(COEFF_LENGTH-1 downto 0);
    signal coeff_imag_dft : std_logic_vector(COEFF_LENGTH-1 downto 0);
    signal enable_dft     : std_logic;

begin

    set_signals: process (clk)
    begin
        if clk'event and clk='1' then
            if address=0 or address=DFT_ADDRESS then
                if rst='1' then
                    coeff_real_dft <= (others => '0');
                    coeff_imag_dft <= (others => '0');
                    enable_dft     <= '0';
                elsif command="01" then -- set coefficient
                    coeff_real_dft <= coeff_real;
                    coeff_imag_dft <= coeff_imag;
                    enable_dft     <= '0';
                elsif command="11" then -- calculate dft
                    coeff_real_dft <= coeff_real_dft;
                    coeff_imag_dft <= coeff_imag_dft;
                    enable_dft     <= enable;
                else
                    coeff_real_dft <= coeff_real_dft;
                    coeff_imag_dft <= coeff_imag_dft;
                    enable_dft     <= enable_dft; -- ?
                end if;
            else
                coeff_real_dft <= coeff_real_dft;
                coeff_imag_dft <= coeff_imag_dft;
                enable_dft     <= enable_dft;
            end if;
        end if;
    end process set_signals;



    sdft_algorithm: if ALGORITHM = '0' generate
        sdft_inst: entity work.sdft
        generic map (
            DATA_WIDTH     => DATA_WIDTH,
            COEFF_LENGTH   => COEFF_LENGTH,
            STATE_INTEGER  => STATE_INTEGER,
            STATE_FRACTION => STATE_FRACTION
        )
        port map (
            enable     => enable_dft,
            rst        => rst,
            clk        => clk,
            data_in    => data_in,
            coeff_real => coeff_real_dft,
            coeff_imag => coeff_imag_dft,
            dft_real   => dft_real,
            dft_imag   => dft_imag
        );
    end generate sdft_algorithm;
    
    goertzel_algorithm: if ALGORITHM = '1' generate
        goertzel_inst: entity work.goertzel
        generic map (
            DATA_WIDTH     => DATA_WIDTH,
            COEFF_LENGTH   => COEFF_LENGTH,
            STATE_INTEGER  => STATE_INTEGER,
            STATE_FRACTION => STATE_FRACTION
        )
        port map (
            enable     => enable_dft,
            rst        => rst,
            clk        => clk,
            data_in    => data_in,
            coeff_real => coeff_real_dft,
            coeff_imag => coeff_imag_dft,
            dft_real   => dft_real,
            dft_imag   => dft_imag
        );
    end generate goertzel_algorithm;

end behav;

