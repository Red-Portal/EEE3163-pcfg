--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:54:52 11/16/2018
-- Design Name:   
-- Module Name:   /home/msca8h/Projects/EEE3163-pcfg/controller_da_test.vhd
-- Project Name:  pcfg
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller_da
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

ENTITY controller_da_test IS
END controller_da_test;

ARCHITECTURE behavior OF controller_da_test IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT controller_da
    port(
      s_clk               : in  STD_LOGIC;
      sys_clk             : in  STD_LOGIC;
      m_reset             : in  STD_LOGIC;
      da_ram_ena          : out STD_LOGIC;
      da_ram_wea          : out STD_LOGIC_VECTOR (0 downto 0);
      da_ram_addra        : out STD_LOGIC_VECTOR (10 downto 0);
      da_ram_enb          : out STD_LOGIC;
      da_ram_addrb        : out STD_LOGIC_VECTOR (10 downto 0);
      ram1_enb            : out STD_LOGIC;
      count_ram1_ce       : out STD_LOGIC;
      count_ram1_sclr     : out STD_LOGIC;
      count_ram1_q        : in  STD_LOGIC_VECTOR (10 downto 0);
      count_data_q        : in  STD_LOGIC_VECTOR (10 downto 0);
      ctrl_da_start       : in  STD_LOGIC;
      ctrl_da_stop        : in  STD_LOGIC
      );
  END component;

  COMPONENT counter
    PORT(
      clk  : IN  std_logic;
      ce   : IN  std_logic;
      sclr : IN  std_logic;
      q    : OUT std_logic_vector(10 downto 0)
      );
  END component;
  
  --Inputs
  signal s_clk         : std_logic                     := '0';
  signal sys_clk       : std_logic                     := '0';
  signal m_reset       : std_logic                     := '0';
  signal count_ram1_q  : std_logic_vector(10 downto 0) := (others => '1');
  signal count_data_q  : std_logic_vector(10 downto 0) := (others => '0');
  signal ctrl_da_start : std_logic                     := '0';
  signal ctrl_da_stop  : std_logic                     := '0';

  --Outputs
  signal da_ram_ena      : std_logic;
  signal da_ram_wea      : std_logic_vector(0 downto 0);
  signal da_ram_addra    : std_logic_vector(10 downto 0);
  signal da_ram_enb      : std_logic;
  signal da_ram_addrb    : std_logic_vector(10 downto 0);
  signal ram1_enb        : std_logic;
  signal count_ram1_ce   : std_logic;
  signal count_ram1_sclr : std_logic;

  -- Clock period definitions
  constant s_clk_period   : time := 25 ns;
  constant sys_clk_period : time := 200 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: controller_da PORT MAP (
    s_clk           => s_clk,
    sys_clk         => sys_clk,
    m_reset         => m_reset,
    da_ram_ena      => da_ram_ena,
    da_ram_wea      => da_ram_wea,
    da_ram_addra    => da_ram_addra,
    da_ram_enb      => da_ram_enb,
    da_ram_addrb    => da_ram_addrb,
    ram1_enb        => ram1_enb,
    count_ram1_ce   => count_ram1_ce,
    count_ram1_sclr => count_ram1_sclr,
    count_ram1_q    => count_ram1_q,
    count_data_q    => count_data_q,
    ctrl_da_start   => ctrl_da_start,
    ctrl_da_stop    => ctrl_da_stop
    );

  ram1_counter: counter PORT MAP (
    clk   => s_clk,
    ce    => count_ram1_ce,
    sclr  => count_ram1_sclr,
    q     => count_ram1_q
    );

  -- Clock process definitions
  s_clk_process :process
  begin
    s_clk <= '0';
    wait for s_clk_period/2;
    s_clk <= '1';
    wait for s_clk_period/2;
  end process;
  
  sys_clk_process :process
  begin
    sys_clk <= '0';
    wait for sys_clk_period/2;
    sys_clk <= '1';
    wait for sys_clk_period/2;
  end process;
  
  -- Stimulus process
  stim_proc: process
  begin		
    -- hold reset state for 100 ns.
    m_reset <= '1';
    wait for 100 ns;	
    m_reset <= '0';
    wait for s_clk_period;

    count_data_q <= "00000000100";
    wait for s_clk_period;

    ctrl_da_start <= '1';
    wait for s_clk_period;
    ctrl_da_start <= '0';
    wait for s_clk_period * 200;
    ctrl_da_stop <= '1';
    wait for s_clk_period;
    ctrl_da_stop <= '0';

    --count_ram1_q <= to_unsigned("100", 11);
    wait for s_clk_period * 10;
    wait;
  end process;
END;
