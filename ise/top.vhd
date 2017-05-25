library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        clk        : in std_logic;
        rst        : in std_logic;
        enable     : in std_logic;
        data_in    : in std_logic_vector(23 downto 0);
        dft_real   : out std_logic_vector(31 downto 0);
        dft_imag   : out std_logic_vector(31 downto 0);
        coeff_real : in std_logic;
        coeff_imag : in std_logic;
        address    : in std_logic_vector(0 downto 0);
        command    : in std_logic_vector(1 downto 0)
    );
end top;

architecture behav of top is
    signal mmcm_clk        : std_logic;
    signal mmcm_rst        : std_logic;
    signal mmcm_locked     : std_logic;
    signal coeff_real_slv  : std_logic_vector(31 downto 0);
    signal coeff_imag_slv  : std_logic_vector(31 downto 0);
    signal coeff_real_temp : std_logic_vector(31 downto 0);
    signal coeff_imag_temp : std_logic_vector(31 downto 0);
    signal address_int     : integer range 0 to 1;

begin

    mmcm_inst: entity work.mmcm
    port map (
        CLK_IN1  => clk,
        CLK_OUT1 => mmcm_clk,
        RESET    => mmcm_rst,
        LOCKED   => mmcm_locked
    );

    sa_inst: entity work.spectral_analysis
    generic map (
        DATA_WIDTH     => 24,
        COEFF_LENGTH   => 32,
        STATE_INTEGER  => 32,
        STATE_FRACTION => 32,
        ALGORITHM      => '0',
        DFT_NUMBER     => 1,
        POINTS         => 10
    )
    port map (
        clk        => mmcm_clk,
        rst        => rst,
        enable     => enable,
        data_in    => data_in,
        dft_real   => dft_real,
        dft_imag   => dft_imag,
        coeff_real => coeff_real_slv,
        coeff_imag => coeff_imag_slv,
        address    => address_int,
        command    => command
    );

    address_int <= to_integer(unsigned(address));
    
    coeff_process: process (mmcm_clk)
    begin
        if mmcm_clk'event and mmcm_clk='1' then
            coeff_real_temp <= coeff_real_temp(coeff_real_temp'length-2 downto 0) & coeff_real;
            coeff_imag_temp <= coeff_imag_temp(coeff_imag_temp'length-2 downto 0) & coeff_imag;
        end if;
    end process coeff_process;
    coeff_real_slv <= coeff_real_temp;
    coeff_imag_slv <= coeff_imag_temp;
end behav;
