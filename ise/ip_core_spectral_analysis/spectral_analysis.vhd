library ieee;
use ieee.std_logic_1164.all;

entity spectral_analysis is
    generic (
        DATA_WIDTH : integer := 24;
        COEFF_LENGTH : integer := 32;
        STATE_INTEGER : integer := 32;
        STATE_FRACTION : integer := 32;
        ALGORITHM : std_logic := '0'
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;
        data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_out : out std_logic_vector(DATA_WIDTH downto 0);
        coeff : in std_logic_vector(COEFF_LENGTH-1 downto 0);
        dft_real : out std_logic_vector(STATE_INTEGER-1 downto 0);
        dft_imag : out std_logic_vector(STATE_INTEGER-1 downto 0)
    );
end spectral_analysis;

architecture behav of spectral_analysis is
    signal data_out_pipeline: std_logic_vector(DATA_WIDTH downto 0);
  

begin

    pipeline_inst: entity work.pipeline
        port map (
            clk => clk,
            rst => rst,
            enable => enable,
            data_in => data_in,
            data_out => data_out_pipeline
        );
        
    sdft_algorithm: if ALGORITHM = '0' generate
        sdft_inst: entity work.sdft
            port map (
                enable => enable,
                rst => rst,
                clk => clk,
                data_in => data_out_pipeline,
                coeff =>  coeff,
                dft_real => dft_real,
                dft_imag => dft_imag
            );
    end generate sdft_algorithm;
    
    goertzel_algorithm: if ALGORITHM = '1' generate
        goertzel_inst: entity work.goertzel
            port map (
                enable => enable,
                rst => rst,
                clk => clk,
                data_in => data_out_pipeline,
                coeff =>  coeff,
                dft_real => dft_real,
                dft_imag => dft_imag
            );
    end generate goertzel_algorithm;
        
    data_out <= data_out_pipeline;

end behav;

