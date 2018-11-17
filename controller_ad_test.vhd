---------------------------------------------------------------------------------- Company: 
-- Engineer:
--
-- Create Date:   20:54:56 11/12/2018
-- Design Name:   
-- Module Name:   /home/msca8h/Projects/EEE3163-pcfg/controller_ad_test.vhd
-- Project Name:  pcfg
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller_ad
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

ENTITY controller_ad_test IS
END controller_ad_test;

ARCHITECTURE behavior OF controller_ad_test IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT controller_ad
    port(
      m_reset         : in  std_logic;
      sys_clk         : in  STD_LOGIC;
      s_clk           : in  STD_LOGIC;
      count_data_load : out STD_LOGIC;
      count_data_q    : in  STD_LOGIC_VECTOR (10 downto 0);
      count_ram0_q    : in std_logic_vector (10 downto 0);
      count_ram0_ce   : out std_logic;
      count_ram0_sclr : out std_logic;
      mux_ram0_sel    : out STD_LOGIC;
      ad_ram_addr     : out STD_LOGIC_vector (7 downto 0);
      ad_ram_ena      : out STD_LOGIC;
      ad_ram_wea      : out STD_LOGIC_VECTOR (0 downto 0);
      ad_ram_enb      : out STD_LOGIC;
      ram0_ena        : out STD_LOGIC;
      ram0_wea        : out STD_LOGIC_VECTOR (0 downto 0);
      ctrl_ad_mode    : in  std_logic
      );
  END component;
  
  COMPONENT load_counter
    PORT(
      load : in std_logic;
      l    : in std_logic_vector(10 downto 0);
      clk  : IN  std_logic;
      ce   : IN  std_logic;
      sclr : IN  std_logic;
      q    : OUT std_logic_vector(10 downto 0)
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

  signal m_reset      : std_logic := '0';
  signal sys_clk      : STD_LOGIC := '0';
  signal s_clk        : STD_LOGIC := '0';
  signal count_data_q : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
  signal ad_ram_addr  : STD_LOGIC := '0'; 
  signal ctrl_ad_mode : std_logic := '0';

  signal count_data_load : STD_LOGIC;
  signal count_ram0_ce   : std_logic;
  signal count_ram0_sclr : std_logic;
  signal mux_ram0_sel    : STD_LOGIC;
  signal ad_ram_ena      : STD_LOGIC;
  signal ad_ram_wea      : STD_LOGIC_VECTOR (0 downto 0);
  signal count_ram0_q    : std_logic_vector (10 downto 0);
  signal ad_ram_enb      : STD_LOGIC;
  signal ram0_ena        : STD_LOGIC;
  signal ram0_wea        : STD_LOGIC_VECTOR (0 downto 0);

  -- Clock period definitions
  constant sys_clk_period : time := 25  ns;
  constant s_clk_period   : time := 100 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut : controller_ad PORT MAP (
    m_reset         => m_reset,
    s_clk           => s_clk,
    sys_clk         => sys_clk,
    count_data_load => count_data_load,
    count_data_q    => count_data_q,
    count_ram0_q    => count_ram0_q,
    count_ram0_ce   => count_ram0_ce,
    count_ram0_sclr => count_ram0_sclr,
    mux_ram0_sel    => mux_ram0_sel,
    ad_ram_ena      => ad_ram_ena,
    ad_ram_wea      => ad_ram_wea,
    ad_ram_enb      => ad_ram_enb,
    ram0_ena        => ram0_ena,
    ram0_wea        => ram0_wea,
    ctrl_ad_mode    => ctrl_ad_mode
    );

  data_counter: load_counter PORT map (
    l    => (others=>'1'),
    load => count_data_load,
    clk  => s_clk,
    ce   => '0',
    sclr => '0',
    q    => count_data_q
    );

  ram0_counter: counter PORT map (
    clk  => s_clk,
    ce   => count_ram0_ce,
    sclr => count_ram0_sclr,
    q    => count_ram0_q
    );

  -- Clock process definitions
  s_clk_process :process
  begin
    s_clk <= '0';
    wait for sys_clk_period/2;
    s_clk <= '1';
    wait for sys_clk_period/2;
  end process;

  sys_clk_process :process
  begin
    sys_clk <= '0';
    wait for s_clk_period/2;
    sys_clk <= '1';
    wait for s_clk_period/2;
  end process;
  
  -- Stimulus process
  stim_proc: process
  begin		
    m_reset <= '1';
    wait for 60 ns;	
    m_reset <= '0';
    wait for s_clk_period;
    ctrl_ad_mode <= '1';
    wait for s_clk_period;
    ctrl_ad_mode <= '0';
    wait;
  end process;
END;
