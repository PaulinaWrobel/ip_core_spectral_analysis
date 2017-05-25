library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity pipeline is
    generic (
        DATA_WIDTH : integer := 24;
        POINTS     : integer := 15
    );
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        enable   : in std_logic;
        calc_en  : out std_logic;
        data_in  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_out : out std_logic_vector(DATA_WIDTH downto 0)
    );
end pipeline;

architecture behav of pipeline is
    constant FIFO_MAX    : integer := 4;
    constant FIFO_NUMBER : integer := integer(ceil(real(POINTS)/real(FIFO_MAX)));
    constant FIFO_POINTS : integer := POINTS - (FIFO_MAX * (FIFO_NUMBER - 1));
    
    type data_array is array (0 to FIFO_NUMBER) of std_logic_vector(DATA_WIDTH-1 downto 0); 
    signal data_fifo : data_array;

    signal data_out_fifo : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_out_sub  : std_logic_vector(DATA_WIDTH downto 0);
    signal read_en       : std_logic_vector(FIFO_NUMBER-1 downto 0);
    signal write_en      : std_logic_vector(FIFO_NUMBER-1 downto 0);
    signal write_en_temp : std_logic_vector(FIFO_NUMBER-1 downto 0);
    signal almost_empty  : std_logic_vector(FIFO_NUMBER-1 downto 0);
    signal rst_fifo      : std_logic;
    signal calc_en_temp  : std_logic_vector(1 downto 0);
    signal sub_en        : std_logic;
begin

    fifo_gen: for I in 0 to FIFO_NUMBER-2 generate
        fifo_inst: entity work.fifo_ram
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            POINTS     => FIFO_MAX-1
        )
        port map (
            clk          => clk,
            rst          => rst_fifo,
            read_en      => read_en(I),
            write_en     => write_en(I),
            data_in      => data_fifo(I),
            data_out     => data_fifo(I+1),
            almost_empty => almost_empty(I)
        );
    end generate fifo_gen;
    
    fifo_inst: entity work.fifo_ram
    generic map (
        DATA_WIDTH => DATA_WIDTH,
        POINTS     => FIFO_POINTS
    )
    port map (
        clk          => clk,
        rst          => rst_fifo,
        read_en      => read_en(FIFO_NUMBER-1),
        write_en     => write_en(FIFO_NUMBER-1),
        data_in      => data_fifo(FIFO_NUMBER-1),
        data_out     => data_fifo(FIFO_NUMBER),
        almost_empty => almost_empty(FIFO_NUMBER-1)
    );
    
    data_fifo(0)  <= data_in;
    data_out_fifo <= data_fifo(FIFO_NUMBER) when sub_en='1' else (others => '0');
    
    read_en_gen: for I in 0 to FIFO_NUMBER-1 generate
        read_en(I) <= write_en(I) and not almost_empty(I);
    end generate read_en_gen;
    
    write_en_gen_1: if FIFO_NUMBER=1 generate
        write_en_temp(0) <= enable;
    end generate write_en_gen_1;
    
    write_en_gen_2: if FIFO_NUMBER/=1 generate
        write_en_temp <= read_en(FIFO_NUMBER-2 downto 0) & enable;
    end generate write_en_gen_2;
    

    data_out_sub <= std_logic_vector(signed(data_in(DATA_WIDTH-1) & data_in) - signed(data_out_fifo(DATA_WIDTH-1) & data_out_fifo));
    
    enable_process: process (clk)
    begin
        if clk'event and clk='1' then
            write_en     <= write_en_temp;
            calc_en <= enable;
            sub_en       <= not almost_empty(FIFO_NUMBER-1);
        end if;
    end process enable_process;
    
    rst_fifo <= rst;
    
    data_out_process: process (clk)
    begin
        if clk'event and clk='0' then
            data_out <= data_out_sub;
        end if;
    end process data_out_process;
    
end behav;

