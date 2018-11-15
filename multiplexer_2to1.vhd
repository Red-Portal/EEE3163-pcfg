----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:58:36 11/14/2018 
-- Design Name: 
-- Module Name:    multiplexer - Behavioral 
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

entity multiplexer_2to1 is
    Port ( sel : in  STD_LOGIC;
           in0 : in  std_logic_vector(7 downto 0);
           in1 : in  std_logic_vector(7 downto 0);
           o   : out std_logic_vector(7 downto 0));
end multiplexer_2to1;
architecture Behavioral of multiplexer_2to1 is
begin
  o <= in0 when (sel = '1') else
       in1;
end Behavioral;

