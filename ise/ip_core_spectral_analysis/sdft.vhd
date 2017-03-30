library ieee;
use ieee.std_logic_1164.all;

library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

entity sdft is
    generic (
        DEC : integer := 42;
        FRAC : integer := 16
    );
    port (
        data : in std_logic_vector(DEC+FRAC-1 downto 0);
        reset : in std_logic;
        clk : in std_logic
    );
end sdft;

architecture Behavioral of sdft is
    signal state : sfixed(DEC-1 downto -FRAC) := (others => '0');
begin

    state <= to_sfixed(data, state);
end Behavioral;

