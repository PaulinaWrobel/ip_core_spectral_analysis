library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline is
    generic (
        DATA_WIDTH : integer := 24;
        POINTS : integer := 8
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;
        calc_en : out std_logic;
        data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_out : out std_logic_vector(DATA_WIDTH downto 0)
    );
end pipeline;

architecture behav of pipeline is
    signal data_out_fifo : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_out_sub : std_logic_vector(DATA_WIDTH downto 0);
    signal wren : std_logic;
    signal rden : std_logic;
    signal almost_empty : std_logic;
    signal rst_fifo : std_logic;
begin

    fifo_inst: entity work.fifo_ram
        port map (
            clk => clk,
            rst => rst,
            rden => rden,
            wren => wren,
            data_in => data_in,
            data_out => data_out_fifo,
            almost_empty => almost_empty
        );
        
    
    rden <= not almost_empty and wren;
    
    --data_out_sub <= std_logic_vector(signed(data_in) - signed(data_out_fifo));
    --answer <= resize(operand1, answer'length) + resize(operand2, answer'length);
    data_out_sub <= std_logic_vector(signed(data_in(DATA_WIDTH-1) & data_in) - signed(data_out_fifo(DATA_WIDTH-1) & data_out_fifo));
    
    enable_process: process (clk)
    begin
        if clk'event and clk='1' then
            wren <= enable;
            calc_en <= enable;
        end if;
    end process enable_process;
    
    rst_process: process (clk)
    begin
        if clk'event and clk='1' then
            rst_fifo <= rst;
        end if;
    end process rst_process;
    
    data_out_process: process (clk)
    begin
        if clk'event and clk='0' then
            data_out <= data_out_sub;
        end if;
    end process data_out_process;
    
end behav;

