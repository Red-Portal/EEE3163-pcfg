
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fdce11 is
  Port (clock        : in  STD_LOGIC;
        clock_enable : in  STD_LOGIC;
        clear        : in  STD_LOGIC;
        d            : in  std_logic_vector(10 downto 0);
        q            : out std_logic_vector(10 downto 0));
end fdce11;
architecture behavior of fdce11 is
begin
  clk_proc: process (clock, clear)
  begin
    if clear = '1' then
      q <= (others=>'0');
    elsif rising_edge(clock) and clock_enable = '1'  then
      q <= d;
    end if;
  end process;
end behavior;
