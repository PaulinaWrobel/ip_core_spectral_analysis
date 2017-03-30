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

    calc: process (clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                state <= (others => '0');
            else
                state <= resize(state + to_sfixed(data, state),state);
            end if;
        end if;
    end process calc;

end Behavioral;

