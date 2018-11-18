--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:10:51 11/18/2018
-- Design Name:   
-- Module Name:   /home/msca8h/Projects/EEE3163-pcfg/accumulator_test.vhd
-- Project Name:  pcfg
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: accumulator
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

ENTITY accumulator_test IS
END accumulator_test;

ARCHITECTURE behavior OF accumulator_test IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT accumulator
    PORT(
      b    : IN  std_logic_vector(8 downto 0);
      clk  : IN  std_logic;
      add  : IN  std_logic;
      ce   : IN  std_logic;
      sclr : IN  std_logic;
      q    : OUT std_logic_vector(18 downto 0)
      );
  END COMPONENT;
  

  --Inputs
  signal b    : std_logic_vector(8 downto 0) := (others => '0');
  signal clk  : std_logic                    := '0';
  signal add  : std_logic                    := '0';
  signal ce   : std_logic                    := '0';
  signal sclr : std_logic                    := '0';

  --Outputs
  signal q : std_logic_vector(18 downto 0);

  -- Clock period definitions
  constant clk_period : time := 10 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: accumulator PORT MAP (
    b    => b,
    clk  => clk,
    add  => add,
    ce   => ce,
    sclr => sclr,
    q    => q
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
    sclr <= '1';
    wait for 100 ns;	
    sclr <= '0';
    wait for clk_period;

    ce <= '1';
    b <= "000001110";
    add <= '1';
    wait for clk_period;

    for i in 0 to 30 loop			
      ce <= '1';
      b <= "000001111";
      add <= '1';
      wait for clk_period;
      b <= "000001111";
      ce <= '0';
      add <= '0';
    end loop;

    for i in 0 to 31 loop			
      ce <= '1';
      b <= "000001111";
      add <= '0';
      wait for clk_period;
      b <= "000001111";
      ce <= '0';
      add <= '0';
    end loop;

    -- insert stimulus here 

    wait;
  end process;
END;
