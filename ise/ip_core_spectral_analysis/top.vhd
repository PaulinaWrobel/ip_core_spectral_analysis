library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;
        data_in : in std_logic_vector(23 downto 0);
        data_out : out std_logic_vector(24 downto 0)
    );
end top;

architecture behav of top is
    signal mmcm_clk: std_logic;
    signal mmcm_rst: std_logic;
    signal coeff : std_logic_vector(31 downto 0);

begin

    mmcm_inst: entity work.mmcm
        port map (
            CLK_IN1 => clk,
            CLK_OUT1 => mmcm_clk,
            RESET => mmcm_rst,
            LOCKED => open
        );

    sa_inst: entity work.spectral_analysis
        port map (
            clk => mmcm_clk,
            rst => rst,
            enable => enable,
            data_in => data_in,
            data_out => data_out,
            coeff => coeff
        );


    
end behav;