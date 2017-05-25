library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;
library unisim;
use unisim.vcomponents.all;
library unimacro;
use unimacro.vcomponents.all;

entity fifo_ram is
    generic (
        DATA_WIDTH : integer := 24;
        POINTS     : integer := 8
    );
    port (
        clk          : in std_logic;
        rst          : in std_logic;
        read_en      : in std_logic;
        write_en     : in std_logic;
        data_in      : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_out     : out std_logic_vector(DATA_WIDTH-1 downto 0);
        almost_empty : out std_logic
    );
end fifo_ram;

architecture behav of fifo_ram is
    signal read_count  : std_logic_vector(9 downto 0);
    signal write_count : std_logic_vector(9 downto 0);
    
    constant almost_empty_offset : bit_vector(12 downto 0) := bit_vector(to_signed(POINTS-1,13));
    
begin

fifo_sync_macro_inst : FIFO_SYNC_MACRO
    generic map (
        DEVICE              => "VIRTEX6",
        ALMOST_FULL_OFFSET  => X"0008",
        ALMOST_EMPTY_OFFSET => almost_empty_offset,
        DATA_WIDTH          => DATA_WIDTH,
        FIFO_SIZE           => "36Kb"
    )
    port map (
        ALMOSTEMPTY => almost_empty,
        ALMOSTFULL  => open,
        DO          => data_out,
        EMPTY       => open,
        FULL        => open,
        RDCOUNT     => read_count,
        RDERR       => open,
        WRCOUNT     => write_count,
        WRERR       => open,
        CLK         => clk,
        DI          => data_in,
        RDEN        => read_en,
        RST         => rst,
        WREN        => write_en
    );

end architecture behav;

