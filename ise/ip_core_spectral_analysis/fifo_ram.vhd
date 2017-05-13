library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_bit;
library unisim;
use unisim.vcomponents.all;
library unimacro;
use unimacro.vcomponents.all;

entity fifo_ram is
    generic (
        DATA_WIDTH : integer := 24;
        POINTS : integer := 8
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        rden : in std_logic;
        wren : in std_logic;
        data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
        almost_empty : out std_logic
    );
end fifo_ram;

architecture behav of fifo_ram is
--    signal empty : std_logic;
--    signal almostfull : std_logic;
--    signal full : std_logic;
--    signal rderr : std_logic;
--    signal wrerr : std_logic;
    signal rdcount : std_logic_vector(9 downto 0);
    signal wrcount : std_logic_vector(9 downto 0);
    
    constant almostemptyoffset : bit_vector(12 downto 0) := bit_vector(numeric_bit.to_signed(POINTS-1,13));
begin

FIFO_SYNC_MACRO_inst : FIFO_SYNC_MACRO
    generic map(
        DEVICE => "VIRTEX6",
        ALMOST_FULL_OFFSET => X"0008",
        ALMOST_EMPTY_OFFSET => almostemptyoffset,
        DATA_WIDTH => DATA_WIDTH,
        FIFO_SIZE => "36Kb")
    port map (
        ALMOSTEMPTY => almost_empty,
        ALMOSTFULL => open,
        DO => data_out,
        EMPTY => open,
        FULL => open,
        RDCOUNT => rdcount,
        RDERR => open,
        WRCOUNT => wrcount,
        WRERR => open,
        CLK => clk,
        DI => data_in,
        RDEN => rden,
        RST => rst,
        WREN => wren
    );

end architecture behav;

