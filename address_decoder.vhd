
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:14:55 11/14/2018 
-- Design Name: 
-- Module Name:    address_decoder - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity address_decoder is
    Port (s_address           : in  STD_LOGIC_VECTOR (8 downto 0);
          mode_code           : out STD_LOGIC_VECTOR (2 downto 0);
          s_pcs_addr          : out std_logic;
          s_reset_addr        : out std_logic
          );
end address_decoder;

architecture Behavioral of address_decoder is
  constant mode_pc0      : std_logic_vector(2 downto 0) := "001";
  constant mode_pc1      : std_logic_vector(2 downto 0) := "010";
  constant mode_transfer : std_logic_vector(2 downto 0) := "011";
  constant mode_da_start : std_logic_vector(2 downto 0) := "100";
  constant mode_da_stop  : std_logic_vector(2 downto 0) := "101";
  constant mode_ad       : std_logic_vector(2 downto 0) := "110";
  constant mode_avg      : std_logic_vector(2 downto 0) := "111";
begin
  mode_code <= mode_pc0      when (std_logic_vector(to_unsigned(16#180#, 9)) = s_address) else
               mode_pc1      when (std_logic_vector(to_unsigned(16#181#, 9)) = s_address) else
               mode_transfer when (std_logic_vector(to_unsigned(16#160#, 9)) = s_address) else
               mode_da_start when (std_logic_vector(to_unsigned(16#172#, 9)) = s_address) else
               mode_da_stop  when (std_logic_vector(to_unsigned(16#174#, 9)) = s_address) else
               mode_ad       when (std_logic_vector(to_unsigned(16#176#, 9)) = s_address) else
               mode_avg      when (std_logic_vector(to_unsigned(16#150#, 9)) = s_address) else
               "000";  

  s_reset_addr <= '1' when (std_logic_vector(to_unsigned(16#120#, 9)) = s_address) else
                  '0';

  s_pcs_addr <= '1' when (s_address = std_logic_vector(to_unsigned(16#140#, 9)) or
                          s_address = std_logic_vector(to_unsigned(16#141#, 9)) or
                          s_address = std_logic_vector(to_unsigned(16#142#, 9)) or
                          s_address = std_logic_vector(to_unsigned(16#143#, 9)))
                else '0';
end Behavioral;

