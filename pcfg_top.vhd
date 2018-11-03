----------------------------------------------------------------------------------
-- Company: SPS
-- Engineer: Jang Jintae
-- 
-- Create Date:    20:59:42 08/18/2018
-- Design Name: 	
-- Module Name:    PCFG_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision:  
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

--=========== don't change this=======================----------------------
--==========================================================================


entity PCFG_TOP is
PORT( ---------------------------------------------INPUT
	 	m_reset_b : IN std_logic;								
		m_clk : IN std_logic;		
		m_address : IN std_logic_vector(8 downto 0);		
		m_cmd_data : IN std_logic;
		m_OE_b : IN std_logic;
		m_wen : IN std_logic;
		m_ren : IN std_logic;
		
		m_ADC_data : IN std_logic_vector(7 downto 0);	--adc input
		
		---------------------------------------------OUTPUT	
		
		m_DAC_data : OUT std_logic_vector(7 downto 0);	--dac output
		m_DAC_clk : OUT std_logic;
		
		m_AD9283_clk : OUT std_logic;	
		
		-------------------------------------------------INOUT
		
		m_data : INOUT std_logic_vector(7 downto 0);
		
		-------------------------------------------------simulation위한 port
		
		m_led : OUT std_logic_vector(7 downto 0);
		m_TP	: out std_logic_vector(1 downto 0)
		
		);
end PCFG_TOP;


--==========================================================================
--==========================================================================

architecture Behavioral of PCFG_TOP is


---=========== COMPONENT ===================

component TOP_8254 is
    Port ( m_clk0    : in  STD_LOGIC;
           m_clk1    : in  STD_LOGIC;
           m_clk2    : in  STD_LOGIC;
           m_clk_ctr : in  STD_LOGIC;
           m_reset   : in STD_LOGIC;
           m_data    : in  STD_LOGIC_VECTOR (7 downto 0);
           m_gate0   : in  STD_LOGIC;
           m_gate1   : in  STD_LOGIC;
           m_gate2   : in  STD_LOGIC;
           m_addr    : in  STD_LOGIC_VECTOR (1 downto 0);
           m_cs_b    : in  STD_LOGIC;
           m_wr_b    : in  STD_LOGIC;
          
		   m_out0    : out  STD_LOGIC;
           m_out1    : out  STD_LOGIC;
           m_out2    : out  STD_LOGIC);
end component;


signal s_clk : std_logic;
--=== signals

---8254
signal s_m_8254_gate0				: std_logic; 
signal s_m_8254_gate1				: std_logic; 
signal s_m_8254_gate2				: std_logic; 

signal s_dout_en : std_logic;
signal s_pcs_addr  : std_logic;

signal sys_clk : std_logic;

signal s_reset_b : std_logic;

signal s_din : std_logic_vector(7 downto 0);
signal outlatch_dout : std_logic_vector(7 downto 0);
signal s_led : std_logic_vector(6 downto 0);



begin


--clks
m_DAC_clk<=			;--- 필요한 clock 연결하세요
m_AD9283_clk<=		;--- 필요한 clock 연결하세요


-----------================  don't change this ==================-------------------


--global iobuf
s_clk_g : IBUFG generic map (IOSTANDARD => "DEFAULT")
port map(I=>m_clk,O=>s_clk);

--tri state
s_din<=m_data;
m_data<=outlatch_dout when s_dout_en='1' else (others=>'Z');


clk_gen : TOP_8254 port map( 
			m_clk0  =>s_clk,
           m_clk1    =>s_clk,
           m_clk2    =>s_clk,
           m_clk_ctr =>s_clk,
           m_reset   =>not m_reset_b,
           m_data   =>s_din,
           m_gate0   => s_m_8254_gate0,
           m_gate1   => s_m_8254_gate1,
           m_gate2   => s_m_8254_gate2,
           m_addr    =>m_address(1 downto 0),
           m_cs_b    =>not s_pcs_addr,		-- 여기에 들어갈 시그널 잘 정의해보세요.
           m_wr_b    =>not m_wen,
		   m_out0    =>sys_clk,
           m_out1    =>open,
           m_out2    =>open
		   );
		   
s_m_8254_gate0	<= '1';
s_m_8254_gate1	<= '1';
s_m_8254_gate2	<= '1';


--for debug
m_TP(0)	<= s_clk; --test point. for s_clk     이걸로 채점하니깐 바꾸면 절대 안됨
m_TP(1)	<= sys_clk;--test for 8254 output.   이걸로 채점하니깐 바꾸면 절대 안됨
m_led(7) <=s_reset_b;
-----------======================================================--------------------


m_led(6 downto 0)<=s_led(6 downto 0);
		
	

end Behavioral;


