--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:23:59 11/05/2018
-- Design Name:   
-- Module Name:   /home/msca8h/Projects/EEE3163-pcfg/fdce_test.vhd
-- Project Name:  pcfg
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fdce
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
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY fdce_test IS
END fdce_test;

ARCHITECTURE behavior OF fdce_test IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT fdce
    PORT(
      clock : IN  std_logic;
      clock_enable : IN  std_logic;
      clear : IN  std_logic;
      d : IN  std_logic;
      q : OUT  std_logic
      );
  END COMPONENT;
  

  --Inputs
  signal clock : std_logic := '0';
  signal clock_enable : std_logic := '0';
  signal clear : std_logic := '0';
  signal d : std_logic := '0';

  --Outputs
  signal q : std_logic;

  -- Clock period definitions
  constant clock_period : time := 10 ns;
  constant clock_enable_period : time := 10 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: fdce PORT MAP (
    clock => clock,
    clock_enable => clock_enable,
    clear => clear,
    d => d,
    q => q
    );

  -- Clock process definitions
  clock_process :process
  begin
    clock <= '0';
    wait for clock_period/2;
    clock <= '1';
    wait for clock_period/2;
  end process;
  
  -- Stimulus process
  stim_proc: process
  begin		
    -- hold reset state for 100 ns.
    clear <= '1';
    wait for 100 ns;	
    clear <= '0';

    clock_enable <= '0';
    d <= '1';
    wait for clock_period*2;
    d <= '0';
    wait for clock_period*2;
    d <= '1';
    wait for clock_period*4;

    clock_enable <= '1';
    d <= '1';
    wait for clock_period*2;
    d <= '0';
    wait for clock_period*2;
    d <= '1';
    wait for clock_period*10;
    d <= '0';
    clear <= '1';
    wait for clock_period*5;
    clear <= '0';
    wait;
  end process;

END;
