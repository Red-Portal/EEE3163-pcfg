--------------------------------------------------------------------------------
-- Company: 
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
    PORT(
      clr             : in std_logic;
      sys_clk         : IN  std_logic;
      s_clk           : IN  std_logic;
      count_ram0_ce   : out std_logic;
      count_ram0_sclr : out std_logic;
      mux_ram0_sel    : OUT std_logic;
      ad_ram_ena      : OUT std_logic;
      ad_ram_wea      : OUT std_logic_vector(0 downto 0);
      ad_ram_enb      : OUT std_logic;
      ram0_ena        : OUT std_logic;
      ram0_wea        : OUT std_logic_vector(0 downto 0);
      reg_ad_data     : IN  std_logic_vector(7 downto 0);
      ad_ram0_addr    : IN  std_logic;
      ad_latch_en     : OUT std_logic
      );
  END COMPONENT;
  

  --Inputs
  signal clr          : std_logic                    := '0';
  signal sys_clk      : std_logic                    := '0';
  signal s_clk        : std_logic                    := '0';
  signal reg_ad_data  : std_logic_vector(7 downto 0) := (others => '0');
  signal ad_ram0_addr : std_logic                    := '0';

  --Outputs
  signal mux_ram0_sel   : std_logic;
  signal ad_ram_ena     : std_logic;
  signal ad_ram_wea     : std_logic_vector(0 downto 0);
  signal ad_ram_enb     : std_logic;
  signal ram0_ena       : std_logic;
  signal ram0_wea       : std_logic_vector(0 downto 0);
  signal ad_latch_en    : std_logic;
  signal count_ram0_ce  : std_logic;
  signal count_ram0_sclr : std_logic;

  -- Clock period definitions
  constant sys_clk_period : time := 25  ns;
  constant s_clk_period   : time := 100 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: controller_ad PORT MAP (
    clr             => clr,
    sys_clk         => sys_clk,
    s_clk           => s_clk,
    mux_ram0_sel    => mux_ram0_sel,
    ad_ram_ena      => ad_ram_ena,
    ad_ram_wea      => ad_ram_wea,
    ad_ram_enb      => ad_ram_enb,
    ram0_ena        => ram0_ena,
    ram0_wea        => ram0_wea,
    reg_ad_data     => reg_ad_data,
    ad_ram0_addr    => ad_ram0_addr,
    ad_latch_en     => ad_latch_en,
    count_ram0_ce   => count_ram0_ce,
    count_ram0_sclr => count_ram0_sclr
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
    clr <= '1';
    -- hold reset state for 60 ns.
    wait for 60 ns;	
    clr <= '0';

    -- insert stimulus here 
    ad_ram0_addr <= '1';
    reg_ad_data <= "00010000";
    
    wait for 10000 ns;	
    wait;
  end process;

END;
