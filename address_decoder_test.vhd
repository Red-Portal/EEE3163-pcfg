--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:33:06 11/14/2018
-- Design Name:   
-- Module Name:   /home/msca8h/Projects/EEE3163-pcfg/address_decoder_test.vhd
-- Project Name:  pcfg
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: address_decoder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY address_decoder_test IS
END address_decoder_test;

ARCHITECTURE behavior OF address_decoder_test IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT address_decoder
    PORT(
      s_address    : IN  std_logic_vector(8 downto 0);
      mode_code    : out std_logic_vector(2 downto 0);
      s_pcs_addr   : out std_logic;
      s_reset_addr : out std_logic
      );
  END COMPONENT;
  

  --Inputs
  signal s_address  : std_logic_vector(8 downto 0) := (others => '0');
  signal mode_code  : std_logic_vector(2 downto 0) := (others => '0');
  signal s_pcs_addr : std_logic := '0';
  signal clk        : std_logic;
  signal s_reset_addr : std_logic;
  
  constant clk_period : time := 10 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: address_decoder PORT MAP (
    s_address => s_address,
    mode_code => mode_code,
    s_pcs_addr => s_pcs_addr,
    s_reset_addr => s_reset_addr
    );

  -- Clock process definitions
  clk_process :process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  

  -- Stimulus process
  stim_proc: process
  begin		
    -- hold reset state for 100 ns.
    s_address <= std_logic_vector(to_unsigned(16#000#, 9));
    wait for 100 ns;	

    s_address <= std_logic_vector(to_unsigned(16#120#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#180#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#180#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#181#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#182#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#160#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#172#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#174#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#176#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#150#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#140#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#141#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#142#, 9));
    wait for clk_period;

    s_address <= std_logic_vector(to_unsigned(16#143#, 9));
    wait for clk_period;

    -- insert stimulus here 
    s_address <= std_logic_vector(to_unsigned(16#000#, 9));

    wait;
  end process;

END;
