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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY controller_da_test IS
END controller_da_test;

ARCHITECTURE behavior OF controller_da_test IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT controller_da
    PORT(
      s_clk               : IN  std_logic;
      sys_clk             : IN  std_logic;
      m_reset             : IN  std_logic;
      da_ram_ena          : OUT std_logic;
      da_ram_wea          : OUT std_logic_vector(0 downto 0);
      da_ram_addra        : OUT std_logic_vector(10 downto 0);
      da_ram_enb          : OUT std_logic;
      da_ram_addrb        : OUT std_logic_vector(10 downto 0);
      ram1_enb            : OUT std_logic;
      ram1_addrb          : OUT std_logic_vector(10 downto 0);
      count_ram1_ce       : OUT std_logic;
      count_ram1_sclr     : OUT std_logic;
      count_ram1_q        : IN  std_logic_vector(10 downto 0);
      reg_data_count_dout : IN  std_logic;
      ctrl_da_start       : IN  std_logic;
      ctrl_da_stop        : IN  std_logic;
      count_da_ce         : OUT std_logic;
      count_da_sclr       : OUT std_logic;
      count_da_q          : IN  std_logic_vector(10 downto 0)
      );
  END COMPONENT;
  

  --Inputs
  signal s_clk               : std_logic                     := '0';
  signal sys_clk             : std_logic                     := '0';
  signal m_reset             : std_logic                     := '0';
  signal count_ram1_q        : std_logic_vector(10 downto 0) := (others => '0');
  signal reg_data_count_dout : std_logic                     := '0';
  signal ctrl_da_start       : std_logic                     := '0';
  signal ctrl_da_stop        : std_logic                     := '0';
  signal count_da_q          : std_logic_vector(10 downto 0) := (others => '0');

  --Outputs
  signal da_ram_ena      : std_logic;
  signal da_ram_wea      : std_logic_vector(0 downto 0);
  signal da_ram_addra    : std_logic_vector(10 downto 0);
  signal da_ram_enb      : std_logic;
  signal da_ram_addrb    : std_logic_vector(10 downto 0);
  signal ram1_enb        : std_logic;
  signal ram1_addrb      : std_logic_vector(10 downto 0);
  signal count_ram1_ce   : std_logic;
  signal count_ram1_sclr : std_logic;
  signal count_da_ce     : std_logic;
  signal count_da_sclr   : std_logic;

  -- Clock period definitions
  constant s_clk_period   : time := 10 ns;
  constant sys_clk_period : time := 10 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: controller_da PORT MAP (
    s_clk               => s_clk,
    sys_clk             => sys_clk,
    m_reset             => m_reset,
    da_ram_ena          => da_ram_ena,
    da_ram_wea          => da_ram_wea,
    da_ram_addra        => da_ram_addra,
    da_ram_enb          => da_ram_enb,
    da_ram_addrb        => da_ram_addrb,
    ram1_enb            => ram1_enb,
    ram1_addrb          => ram1_addrb,
    count_ram1_ce       => count_ram1_ce,
    count_ram1_sclr     => count_ram1_sclr,
    count_ram1_q        => count_ram1_q,
    reg_data_count_dout => reg_data_count_dout,
    ctrl_da_start       => ctrl_da_start,
    ctrl_da_stop        => ctrl_da_stop,
    count_da_ce         => count_da_ce,
    count_da_sclr       => count_da_sclr,
    count_da_q          => count_da_q
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
    wait for 100 ns;	

    wait for s_clk_period*10;

    -- insert stimulus here 

    wait;
  end process;

END;
