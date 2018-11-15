----------------------------------------------------------------------------------
-- Company: SPS
-- Engineer: Jang Jintae GIT DESKTOP TEST 181110
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
    m_reset_b  : IN std_logic;
    m_clk      : IN std_logic;
    m_address  : IN std_logic_vector(8 downto 0);
    m_cmd_data : IN std_logic;
    m_OE_b     : IN std_logic;
    m_wen      : IN std_logic;
    m_ren      : IN std_logic;

    m_ADC_data : IN std_logic_vector(7 downto 0);  --adc input

    ---------------------------------------------OUTPUT 

    m_DAC_data : OUT std_logic_vector(7 downto 0);  --dac output
    m_DAC_clk  : OUT std_logic;

    m_AD9283_clk : OUT std_logic;

    -------------------------------------------------INOUT

    m_data : INOUT std_logic_vector(7 downto 0);

    -------------------------------------------------simulation port

    m_led : OUT std_logic_vector(7 downto 0);
    m_TP  : out std_logic_vector(1 downto 0)
    
    );
end PCFG_TOP;


--==========================================================================
--==========================================================================

architecture Behavioral of PCFG_TOP is


---=========== component ===================
  COMPONENT memory_block
    PORT(
      clka  : IN  std_logic;
      ena   : IN  std_logic;
      wea   : IN  std_logic_vector(0 downto 0);
      addra : IN  std_logic_vector(10 downto 0);
      dina  : IN  std_logic_vector(7 downto 0);
      clkb  : IN  std_logic;
      enb   : IN  std_logic;
      addrb : IN  std_logic_vector(10 downto 0);
      doutb : OUT std_logic_vector(7 downto 0)
      );
  END COMPONENT;

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

  signal ram0_ena   : std_logic;
  signal ram0_wea   : std_logic_vector(0 downto 0);
  signal ram0_addra : std_logic_vector(10 downto 0);
  signal ram0_dina  : std_logic_vector(7 downto 0);
  signal ram0_clkb  : std_logic;
  signal ram0_enb   : std_logic;
  signal ram0_addrb : std_logic_vector(10 downto 0);
  signal ram0_doutb : std_logic_vector(7 downto 0);

  signal ram1_ena   : std_logic;
  signal ram1_wea   : std_logic_vector(0 downto 0);
  signal ram1_addra : std_logic_vector(10 downto 0);
  signal ram1_dina  : std_logic_vector(7 downto 0);
  signal ram1_clkb  : std_logic;
  signal ram1_enb   : std_logic;
  signal ram1_addrb : std_logic_vector(10 downto 0);
  signal ram1_doutb : std_logic_vector(7 downto 0);

  signal ad_ram_ena   : std_logic;
  signal ad_ram_wea   : std_logic_vector(0 downto 0);
  signal ad_ram_addra : std_logic_vector(10 downto 0);
  signal ad_ram_dina  : std_logic_vector(7 downto 0);
  signal ad_ram_clkb  : std_logic;
  signal ad_ram_enb   : std_logic;
  signal ad_ram_addrb : std_logic_vector(10 downto 0);
  signal ad_ram_doutb : std_logic_vector(7 downto 0);

  signal da_ram_ena   : std_logic;
  signal da_ram_wea   : std_logic_vector(0 downto 0);
  signal da_ram_addra : std_logic_vector(10 downto 0);
  signal da_ram_dina  : std_logic_vector(7 downto 0);
  signal da_ram_clkb  : std_logic;
  signal da_ram_enb   : std_logic;
  signal da_ram_addrb : std_logic_vector(10 downto 0);
  signal da_ram_doutb : std_logic_vector(7 downto 0);

  signal s_clk : std_logic;
--=== signals

---8254
  signal s_m_8254_gate0 : std_logic;
  signal s_m_8254_gate1 : std_logic;
  signal s_m_8254_gate2 : std_logic;
  
  signal s_dout_en  : std_logic;
  signal s_pcs_addr : std_logic;

  signal sys_clk : std_logic;

  signal s_reset_b : std_logic;

  signal s_din         : std_logic_vector(7 downto 0);
  signal outlatch_dout : std_logic_vector(7 downto 0);
  signal s_led         : std_logic_vector(6 downto 0);

begin
--clks
  m_DAC_clk<= m_clk0			;--- ʿ clock ϼ
  m_AD9283_clk<= m_clk0		;--- ʿ clock ϼx
------don't know the diff between two.
------Originally inputs to both sig were blank. 
------Just filled them w/ something to shut up error msg.(June)


-----------================  don't change this ==================-------------------


--global iobuf
  s_clk_g : IBUFG generic map (IOSTANDARD => "DEFAULT")
    port map(I=>m_clk,O=>s_clk);

--tri state
  s_din<=m_data;
  m_data<=outlatch_dout when s_dout_en='1' else (others=>'Z');

  clk_gen : TOP_8254 port map( 
    m_clk0    => s_clk,
    m_wr_b    => not m_wen,
    m_out0    => sys_clk,
    m_out1    => open,
    m_out2    => open);
  
  s_m_8254_gate0	<= '1';
  s_m_8254_gate1	<= '1';
  s_m_8254_gate2	<= '1';


--for debug
  m_TP(0)	<= s_clk; --test point. for s_clk     ̰ɷ äϴϱ ٲٸ  ȵ
  m_TP(1)	<= sys_clk;--test for 8254 output.   ̰ɷ äϴϱ ٲٸ  ȵ
  m_led(7) <= s_reset_b;
-----------======================================================--------------------

  clka  : IN  std_logic;
  ena   : IN  std_logic;
  wea   : IN  std_logic_vector(0 downto 0);
  addra : IN  std_logic_vector(10 downto 0);
  dina  : IN  std_logic_vector(7 downto 0);
  clkb  : IN  std_logic;
  enb   : IN  std_logic;
  addrb : IN  std_logic_vector(10 downto 0);
  doutb : OUT std_logic_vector(7 downto 0);

  RAM0 : memory_block port map( 
    clka  => clk,
    ena   => ram0_ena,
    wea   => ram0_wea,
    addra => ram0_addra,
    dina  => ram0_dina,
    clkb  => ram0_clkb,
    enb   => ram0_enb,
    addrb => ram0_addrb,
    doutb => ram0_doubt,
    );

  RAM1 : memory_block port map( 
    clka  => clk,
    ena   => ram1_ena,
    wea   => ram1_wea,
    addra => ram1_addra,
    dina  => ram1_dina,
    clkb  => ram1_clkb,
    enb   => ram1_enb,
    addrb => ram1_addrb,
    doutb => ram1_doubt,
    );

  AD_RAM : memory_block port map( 
    clka  => clk,
    ena   => ad_ram_ena,
    wea   => ad_ram_wea,
    addra => ad_ram_addra,
    dina  => ad_ram_dina,
    clkb  => ad_ram_clkb,
    enb   => ad_ram_enb,
    addrb => ad_ram_addrb,
    doutb => ad_ram_doubt,
    );

  DA_RAM : memory_block port map( 
    clka  => clk,
    ena   => da_ram_ena,
    wea   => da_ram_wea,
    addra => da_ram_addra,
    dina  => da_ram_dina,
    clkb  => da_ram_clkb,
    enb   => da_ram_enb,
    addrb => da_ram_addrb,
    doutb => da_ram_doubt,
    );

  m_led(6 downto 0)<=s_led(6 downto 0);

end Behavioral;


