
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:16:52 11/05/2018 
-- Design Name: 
-- Module Name:    fdce - behavior 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fdce8 is
  Port (clock        : in  STD_LOGIC;
        clock_enable : in  STD_LOGIC;
        clear        : in  STD_LOGIC;
        d            : in  std_logic_vector(7 downto 0);
        q            : out std_logic_vector(7 downto 0));
end fdce8;
architecture behavior of fdce8 is
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
