--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:36:51 11/18/2018
-- Design Name:   
-- Module Name:   /home/msca8h/Projects/EEE3163-pcfg/average_filter_test.vhd
-- Project Name:  pcfg
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: average_filter
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY average_filter_test IS
END average_filter_test;

ARCHITECTURE behavior OF average_filter_test IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT average_filter
    PORT(
      m_reset : IN  std_logic;
      s_clk   : IN  std_logic;
      din     : IN  std_logic_vector(7 downto 0);
      ce      : IN  std_logic;
      avg     : IN  std_logic;
      dout    : OUT std_logic_vector(7 downto 0);
      done    : out std_logic
      );
  END COMPONENT;
  

  --Inputs
  signal m_reset : std_logic                    := '0';
  signal s_clk   : std_logic                    := '0';
  signal din     : std_logic_vector(7 downto 0) := (others => '0');
  signal ce      : std_logic                    := '0';
  signal avg     : std_logic                    := '0';

  --Outputs
  signal dout : std_logic_vector(7 downto 0);
  signal done : std_logic;

  -- Clock period definitions
  constant s_clk_period : time := 10 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: average_filter PORT MAP (
    m_reset => m_reset,
    s_clk   => s_clk,
    din     => din,
    ce      => ce,
    avg     => avg,
    dout    => dout,
    done    => done
    );

  -- Clock process definitions
  s_clk_process :process
  begin
    s_clk <= '0';
    wait for s_clk_period/2;
    s_clk <= '1';
    wait for s_clk_period/2;
  end process;
  

  -- Stimulus process
  stim_proc: process
  begin		
    -- hold reset state for 100 ns.
    m_reset <= '1';
    wait for 100 ns;	
    m_reset <= '0';

    for i in 0 to 32 loop			
      ce <= '1';
      din <= std_logic_vector(to_unsigned(i, 8));
      wait for s_clk_period;
      ce <= '0';
      wait for s_clk_period;
    end loop;

    wait for s_clk_period;
    avg <= '1';
    wait for s_clk_period;
    avg <= '0';

    -- insert stimulus here 

    wait;
  end process;

END;
