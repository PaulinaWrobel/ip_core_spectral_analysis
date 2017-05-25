library ieee;
use ieee.std_logic_1164.all;

entity spectral_analysis is
    generic (
        DATA_WIDTH     : integer   := 24;
        COEFF_LENGTH   : integer   := 32;
        STATE_INTEGER  : integer   := 32;
        STATE_FRACTION : integer   := 32;
        ALGORITHM      : std_logic := '0';
        DFT_NUMBER     : integer   := 1;
        POINTS         : integer   := 20
    );
    port (
        clk        : in std_logic;
        rst        : in std_logic;
        enable     : in std_logic;
        data_in    : in std_logic_vector(DATA_WIDTH-1 downto 0);
        coeff_real : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        coeff_imag : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        dft_real   : out std_logic_vector(STATE_INTEGER-1 downto 0);
        dft_imag   : out std_logic_vector(STATE_INTEGER-1 downto 0);
        address    : in integer range 0 to DFT_NUMBER;
        command    : in std_logic_vector(1 downto 0)
    );
end spectral_analysis;

architecture behav of spectral_analysis is
    signal data_out_pipeline : std_logic_vector(DATA_WIDTH downto 0);
    signal enable_pipeline   : std_logic;
    
    type dft_array is array (0 to DFT_NUMBER-1) of std_logic_vector(STATE_INTEGER-1 downto 0);
    signal dft_real_array : dft_array;
    signal dft_imag_array : dft_array;

begin

    pipeline_inst: entity work.pipeline
    generic map (
        DATA_WIDTH => DATA_WIDTH,
        POINTS     => POINTS
    )
    port map (
        clk      => clk,
        rst      => rst,
        enable   => enable,
        data_in  => data_in,
        data_out => data_out_pipeline,
        calc_en  => enable_pipeline
    );

    dft_gen: for I in 0 to DFT_NUMBER-1 generate
        dft_inst: entity work.dft
        generic map (
            DATA_WIDTH     => DATA_WIDTH,
            COEFF_LENGTH   => COEFF_LENGTH,
            STATE_INTEGER  => STATE_INTEGER,
            STATE_FRACTION => STATE_FRACTION,
            ALGORITHM      => ALGORITHM,
            DFT_ADDRESS    => I+1,
            DFT_NUMBER     => DFT_NUMBER
        )
        port map (
            enable     => enable_pipeline,
            rst        => rst,
            clk        => clk,
            data_in    => data_out_pipeline,
            coeff_real => coeff_real,
            coeff_imag => coeff_imag,
            dft_real   => dft_real_array(I),
            dft_imag   => dft_imag_array(I),
            address    => address,
            command    => command
        );
    end generate dft_gen;

    dft_real <= dft_real_array(0); -- temp
    dft_imag <= dft_imag_array(0); -- temp

end behav;

