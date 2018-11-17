--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:24:36 10/17/2018
-- Design Name:   
-- Module Name:   C:/Users/WOOJIN/Desktop/godi/spsgodi/tb_pcfg.vhd
-- Project Name:  spsgodi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PCFG_TOP
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_pcfg IS
END tb_pcfg;

ARCHITECTURE behavior OF tb_pcfg IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT PCFG_TOP
    PORT(
      m_reset_b    : IN    std_logic;
      m_clk        : IN    std_logic;
      m_address    : IN    std_logic_vector(8 downto 0);
      m_cmd_data   : IN    std_logic;
      m_OE_b       : IN    std_logic;
      m_wen        : IN    std_logic;
      m_ren        : IN    std_logic;
      m_ADC_data   : IN    std_logic_vector(7 downto 0);
      m_DAC_data   : OUT   std_logic_vector(7 downto 0);
      m_DAC_clk    : OUT   std_logic;
      m_AD9283_clk : OUT   std_logic;
      m_data       : INOUT std_logic_vector(7 downto 0);
      m_led        : OUT   std_logic_vector(7 downto 0);
      m_TP         : OUT   std_logic_vector(1 downto 0)
      );
  END COMPONENT;
  

  --Inputs
  signal m_reset_b  : std_logic                    := '0';
  signal m_clk      : std_logic                    := '0';
  signal m_address  : std_logic_vector(8 downto 0) := (others => '0');
  signal m_cmd_data : std_logic                    := '0';
  signal m_OE_b     : std_logic                    := '1';
  signal m_wen      : std_logic                    := '0';
  signal m_ren      : std_logic                    := '0';
  signal m_ADC_data : std_logic_vector(7 downto 0) := (others => '0');

  --BiDirs
  signal m_data : std_logic_vector(7 downto 0)     := "ZZZZZZZZ";

  --Outputs
  signal m_DAC_data   : std_logic_vector(7 downto 0);
  signal m_DAC_clk    : std_logic;
  signal m_AD9283_clk : std_logic;
  signal m_led        : std_logic_vector(7 downto 0);
  signal m_TP         : std_logic_vector(1 downto 0);
  
  -- Clock period definitions
  constant m_clk_period : time := 25 ns;
  
  
  procedure CMD_WR(
    Addr                : in  std_logic_vector(8 downto 0);
    Data_in             : in  std_logic_vector(7 downto 0);
    signal Address_tmp  : out std_logic_vector(8 downto 0);
    signal Data_tmp     : out std_logic_vector(7 downto 0);
    signal CMD_DATA_tmp : out std_logic;
    signal WEN_tmp      : out std_logic;
    signal REN_tmp      : out std_logic;
    signal n_OE         : out std_logic) is
  begin
    
    Address_tmp				<= Addr; 
    Data_tmp   				<= Data_in;
    CMD_DATA_tmp 			<= '1';
    WEN_tmp 				<= '0';
    REN_tmp 				<= '0';
    n_OE					<= '1';
    wait for m_clk_period*5;
    
    WEN_tmp 				<= '1';
    wait for m_clk_period*5;
    
    Address_tmp				<= (others=>'Z'); 
    Data_tmp   				<= (others=>'Z');
    CMD_DATA_tmp			<= '0';
    WEN_tmp 				<= '0';
    wait for 10 ns;
  end CMD_WR; 
  
  ----CMD_RD------------------------------------------------------------------
  procedure CMD_RD(
    Addr                : in    std_logic_vector(8 downto 0);
    signal Address_tmp  : out   std_logic_vector(8 downto 0);
    signal Data_tmp     : inout std_logic_vector(7 downto 0);
    signal CMD_DATA_tmp : out   std_logic;
    signal WEN_tmp      : out   std_logic;
    signal REN_tmp      : out   std_logic;
    signal n_OE         : out   std_logic
    ) is
  begin
    Address_tmp				<= Addr; 
    CMD_DATA_tmp 			<= '1';
    WEN_tmp 				<= '0';
    REN_tmp 				<= '0';
    n_OE				<='0';
    Data_tmp				<= "ZZZZZZZZ";
    wait for m_clk_period*5;
    REN_tmp 				<= '1';
    wait for m_clk_period*5;
    Address_tmp				<= (others=>'Z'); 
    CMD_DATA_tmp			<= '0';
    REN_tmp 				<= '0';
    n_OE					<='1';
    wait for 10 ns;
  end CMD_RD;

  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: PCFG_TOP PORT MAP (
    m_reset_b => m_reset_b,
    m_clk => m_clk,
    m_address => m_address,
    m_cmd_data => m_cmd_data,
    m_OE_b => m_OE_b,
    m_wen => m_wen,
    m_ren => m_ren,
    m_ADC_data => m_ADC_data,
    m_DAC_data => m_DAC_data,
    m_DAC_clk => m_DAC_clk,
    m_AD9283_clk => m_AD9283_clk,
    m_data => m_data,
    m_led => m_led,
    m_TP => m_TP
    );

  -- Clock process definitions
  m_clk_process :process
  begin
    m_clk <= '0';
    wait for m_clk_period/2;
    m_clk <= '1';
    wait for m_clk_period/2;
  end process;

  -- Stimulus process
  stim_proc: process
  begin		
    -- hold reset state for 100 ns.
    wait for 100 ns;	
    m_reset_b  <= '1';
    wait for 100 us;
    
    -- 8254 setting (m_clk를 8분주해서 div_clk을 만들기 위한 과정
    CMD_WR("101000011","00110110",m_address,m_data,m_cmd_data,m_wen,m_ren,m_OE_b);
    wait for 10 us;
    CMD_WR("101000000","00001000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_OE_b);	-- LSB 08
    wait for 10 us;
    CMD_WR("101000000","00000000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_OE_b);  -- MSB 00
    wait for 10 us;

    for i in 0 to 99 loop			
      CMD_WR('1' & x"81",conv_std_logic_vector(i,8),m_address,m_data,m_cmd_data,m_wen,m_ren,m_OE_b);	-- RAM0에 100개 쓰기
      wait for 1 us;
    end loop;
    
    for i in 0 to 99 loop
      CMD_RD('1' & x"81",m_address,m_data,m_cmd_data,m_wen,m_ren,m_OE_b);  -- RAM0에 100개 읽기
      wait for 1 us;
    end loop;

    wait for 1 us;
    CMD_RD('1' & x"72",m_address,m_data,m_cmd_data,m_wen,m_ren,m_OE_b);  -- RAM0에 100개 읽기
    wait for 10 us;
    CMD_RD('1' & x"74",m_address,m_data,m_cmd_data,m_wen,m_ren,m_OE_b);  -- RAM0에 100개 읽기

    -- insert stimulus here 

    wait;
  end process;

END;
