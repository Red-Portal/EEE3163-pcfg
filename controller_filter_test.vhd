--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:31:42 11/18/2018
-- Design Name:   
-- Module Name:   /home/msca8h/Projects/EEE3163-pcfg/controller_filter_test.vhd
-- Project Name:  pcfg
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller_filter
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
 
ENTITY controller_filter_test IS
END controller_filter_test;
 
ARCHITECTURE behavior OF controller_filter_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controller_filter
    PORT(
         m_reset         : IN  std_logic;
         s_clk           : IN  std_logic;
         ctrl_filter     : IN  std_logic;
         data_count      : IN  std_logic_vector(10 downto 0);
         filter_ce       : OUT std_logic;
         filter_avg      : OUT std_logic;
         filter_done     : IN  std_logic;
         filter_reset    : OUT std_logic;
         count_ram0_ce   : OUT std_logic;
         count_ram0_sclr : OUT std_logic;
         count_ram0_q    : IN  std_logic_vector(10 downto 0)
         );
    END component;

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
    signal m_reset      : std_logic                     := '0';
    signal s_clk        : std_logic                     := '0';
    signal ctrl_filter  : std_logic                     := '0';
    signal data_count   : std_logic_vector(10 downto 0) := (others => '0');
    signal filter_done  : std_logic                     := '0';
    signal count_ram0_q : std_logic_vector(10 downto 0) := (others => '0');

    signal filt_din  : std_logic;
    signal filt_ce   : std_logic;
    signal filt_avg  : std_logic;
    signal filt_dout : std_logic;
    signal filt_done : std_logic;

    --Outputs
    signal filter_ce       : std_logic;
    signal filter_avg      : std_logic;
    signal filter_reset    : std_logic;
    signal count_ram0_ce   : std_logic;
    signal count_ram0_sclr : std_logic;

    -- Clock period definitions
    constant s_clk_period : time := 10 ns;
    
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: controller_filter PORT MAP (
    m_reset         => m_reset,
    s_clk           => s_clk,
    ctrl_filter     => ctrl_filter,
    data_count      => data_count,
    filter_ce       => filter_ce,
    filter_avg      => filter_avg,
    filter_done     => filter_done,
    filter_reset    => filter_reset,
    count_ram0_ce   => count_ram0_ce,
    count_ram0_sclr => count_ram0_sclr,
    count_ram0_q    => count_ram0_q
    );

  filter: average_filter PORT MAP (
    m_reset => filter_reset,
    s_clk   => s_clk,
    din     => filt_din,
    ce      => filt_ce,
    avg     => filt_avg,
    dout    => filt_dout,
    done    => filt_done
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
    wait for 100 ns;	
    wait for s_clk_period*10;

    

    wait;
  end process;

END;
