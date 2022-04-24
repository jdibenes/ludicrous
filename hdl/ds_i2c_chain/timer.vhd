-- SIM OK 02/07/2019
-- SIM OK 02/08/2019 * fix counter stuck after overflow
-- SIM OK 03/18/2019 * simplify design + generic

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
generic (
    bits : integer := 32
);
port (
    clk    : in  std_logic;
    reset  : in  std_logic;
    start  : in  std_logic;
    load   : in  std_logic_vector(bits - 1 downto 0);
    enable : in  std_logic;
    done   : out std_logic
);
end timer;

architecture Behavioral of timer is
signal count    : signed(bits - 1 downto 0);
signal overflow : std_logic;
signal continue : std_logic;
begin
overflow <= count(bits - 1);
continue <= enable and not overflow;
done     <= overflow;

timer_count : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset    = '1') then count <= (others => '0');
        elsif (start    = '1') then count <= signed(load);
        elsif (continue = '1') then count <= count - 1;
        end if;
    end if;
end process;
end Behavioral;
