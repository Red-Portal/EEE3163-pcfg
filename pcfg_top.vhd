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
architecture Behavioral of PCFG_TOP is

  COMPONENT control_signal_gen
    port(
      m_reset      : in  STD_LOGIC;
      s_reset_addr : in  STD_LOGIC;

      s_clk        : in  STD_LOGIC;
      sys_clk      : in  STD_LOGIC;
      mode_addr    : in  STD_LOGIC_VECTOR (2 downto 0);
      s_data       : in  STD_LOGIC_VECTOR (7 downto 0);
      s_wen        : in  STD_LOGIC;
      s_ren        : in  STD_LOGIC;
      s_oe_b       : in std_logic;

      ram0_ena     : out STD_LOGIC;
      ram0_wea     : out STD_LOGIC_VECTOR (0 downto 0);
      ram0_addra   : out STD_LOGIC_VECTOR (10 downto 0);
      ram0_dina    : out STD_LOGIC_VECTOR (7 downto 0);
      ram0_enb     : out STD_LOGIC;
      ram0_addrb   : out STD_LOGIC_VECTOR (10 downto 0);
      ram0_doutb   : out STD_LOGIC_VECTOR (7 downto 0);

      ram1_ena     : out STD_LOGIC;
      ram1_wea     : out STD_LOGIC_VECTOR (0 downto 0);
      ram1_addra   : out STD_LOGIC_VECTOR (10 downto 0);
      ram1_dina    : out STD_LOGIC_VECTOR (7 downto 0);
      ram1_enb     : out STD_LOGIC;
      ram1_addrb   : out STD_LOGIC_VECTOR (10 downto 0);
      ram1_outb    : out STD_LOGIC_VECTOR (7 downto 0);

      da_ram_ena   : out STD_LOGIC;
      da_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0);
      da_ram_addra : out STD_LOGIC_VECTOR (10 downto 0);
      da_ram_dina  : out STD_LOGIC_VECTOR (7 downto 0);
      da_ram_enb   : out STD_LOGIC;
      da_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0);
      da_ram_doutb : out STD_LOGIC_VECTOR (7 downto 0);

      da_ram_ena   : out STD_LOGIC;
      da_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0);
      da_ram_addra : out STD_LOGIC_VECTOR (10 downto 0);
      da_ram_dina  : out STD_LOGIC_VECTOR (7 downto 0);
      da_ram_enb   : out STD_LOGIC;
      da_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0);
      da_ram_doutb : out STD_LOGIC_VECTOR (7 downto 0);

      mux_out_sel  : out STD_LOGIC;
      mux_ram0_sel : out STD_LOGIC;
      mux_ram1_sel : out STD_LOGIC_VECTOR (1 downto 0);

      s_dout_en    : out STD_LOGIC;
      m_led        : out STD_LOGIC_VECTOR (7 downto 0);
      m_TP         : out STD_LOGIC_VECTOR (1 downto 0)
      );
  END component;

  COMPONENT multiplexer_2to1
    PORT(
      sel : in  std_logic;
      in0 : in  std_logic_vector(7 downto 0);       
      in1 : in  std_logic_vector(7 downto 0);
      o   : out std_logic_vector(7 downto 0)
      );
  END component;

  COMPONENT multiplexer_3to1
    PORT(
      sel : in  std_logic_vector(1 downto 0);
      in0 : in  std_logic_vector(7 downto 0);       
      in1 : in  std_logic_vector(7 downto 0);
      in2 : in  std_logic_vector(7 downto 0);
      o   : out std_logic_vector(7 downto 0)
      );
  END COMPONENT;

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
    Port ( m_clk0    : in STD_LOGIC;
           m_clk1    : in STD_LOGIC;
           m_clk2    : in STD_LOGIC;
           m_clk_ctr : in STD_LOGIC;
           m_reset   : in STD_LOGIC;
           m_data    : in STD_LOGIC_VECTOR (7 downto 0);
           m_gate0   : in STD_LOGIC;
           m_gate1   : in STD_LOGIC;
           m_gate2   : in STD_LOGIC;
           m_addr    : in STD_LOGIC_VECTOR (1 downto 0);
           m_cs_b    : in STD_LOGIC;
           m_wr_b    : in STD_LOGIC;
           
           m_out0    : out  STD_LOGIC;
           m_out1    : out  STD_LOGIC;
           m_out2    : out  STD_LOGIC);
  end component;

  COMPONENT address_decoder
    PORT(
      s_address    : IN  std_logic_vector(8 downto 0);
      mode_addr    : out std_logic_vector(2 downto 0);
      s_pcs_addr   : out std_logic;
      s_reset_addr : out std_logic
      );
  END component;

  COMPONENT fdce
    PORT(
      clock        : IN  std_logic;
      clock_enable : IN  std_logic;
      clear        : IN  std_logic;
      d            : IN  std_logic;
      q            : OUT std_logic
      );
  END component;

  COMPONENT fdce8
    PORT(
      clock        : IN  std_logic;
      clock_enable : IN  std_logic;
      clear        : IN  std_logic;
      d            : IN  std_logic_vector(7 downto 0);
      q            : OUT std_logic_vector(7 downto 0)
      );
  END component;

  COMPONENT fdce9
    PORT(
      clock        : IN  std_logic;
      clock_enable : IN  std_logic;
      clear        : IN  std_logic;
      d            : IN  std_logic_vector(8 downto 0);
      q            : OUT std_logic_vector(8 downto 0)
      );
  END component;

  signal s_data     : std_logic_vector(7 downto 0);
  signal s_address  : std_logic_vector(8 downto 0);
  signal s_cmd_data : std_logic;
  signal s_wen      : std_logic;
  signal s_ren      : std_logic;
  signal s_oe_b     : std_logic;

  signal mux_ram0_sel : std_logic;
  signal mux_ram1_sel : std_logic_vector(1 downto 0);
  signal mux_out_sel  : std_logic;
  signal mux_out_o    : std_logic_vector(7 downto 0);
  signal filter_out   : std_logic_vector(7 downto 0);
  signal filter_in    : std_logic_vector(7 downto 0);

  signal da_latch_en  : std_logic;
  signal ad_latch_en  : std_logic;
  signal in_latch_en  : std_logic;
  signal out_latch_en : std_logic;

  signal mode_addr    : std_logic_vector(2 downto 0);

-----------================ RAM Blocks ==================-------------------
  signal ram0_ena   : std_logic;
  signal ram0_wea   : std_logic_vector(0 downto 0);
  signal ram0_addra : std_logic_vector(10 downto 0);
  signal ram0_dina  : std_logic_vector(7 downto 0);
  signal ram0_enb   : std_logic;
  signal ram0_addrb : std_logic_vector(10 downto 0);
  signal ram0_doutb : std_logic_vector(7 downto 0);

  signal ram1_ena   : std_logic;
  signal ram1_wea   : std_logic_vector(0 downto 0);
  signal ram1_addra : std_logic_vector(10 downto 0);
  signal ram1_dina  : std_logic_vector(7 downto 0);
  signal ram1_enb   : std_logic;
  signal ram1_addrb : std_logic_vector(10 downto 0);
  signal ram1_doutb : std_logic_vector(7 downto 0);

  signal ad_ram_ena   : std_logic;
  signal ad_ram_wea   : std_logic_vector(0 downto 0);
  signal ad_ram_addra : std_logic_vector(10 downto 0);
  signal ad_ram_dina  : std_logic_vector(7 downto 0);
  signal ad_ram_enb   : std_logic;
  signal ad_ram_addrb : std_logic_vector(10 downto 0);
  signal ad_ram_doutb : std_logic_vector(7 downto 0);

  signal da_ram_ena   : std_logic;
  signal da_ram_wea   : std_logic_vector(0 downto 0);
  signal da_ram_addra : std_logic_vector(10 downto 0);
  signal da_ram_dina  : std_logic_vector(7 downto 0);
  signal da_ram_enb   : std_logic;
  signal da_ram_addrb : std_logic_vector(10 downto 0);
  signal da_ram_doutb : std_logic_vector(7 downto 0);
-----------====================================================-------------------

  signal s_clk : std_logic;
--=== signals

---8254
  signal s_m_8254_gate0 : std_logic;
  signal s_m_8254_gate1 : std_logic;
  signal s_m_8254_gate2 : std_logic;
  
  signal s_dout_en  : std_logic;
  signal s_pcs_addr : std_logic;

  signal sys_clk : std_logic;

  signal s_reset : std_logic;

  signal s_din         : std_logic_vector(7 downto 0);
  signal outlatch_dout : std_logic_vector(7 downto 0);
  signal s_led         : std_logic_vector(6 downto 0);

begin
--clks
  m_DAC_clk    <= s_clk;    --- ʿ clock ϼ
  m_AD9283_clk <= s_clk; --- ʿ clock ϼx
------don't know the diff between two.
------Originally inputs to both sig were blank. 
------Just filled them w/ something to shut up error msg.(June)


-----------================  don't change this ==================-------------------


--global iobuf
  s_clk_g : IBUFG generic map (IOSTANDARD => "DEFAULT")
    port map(I => m_clk, O => s_clk);

--tri state
  s_din <= m_data;
  m_data <= outlatch_dout when s_dout_en='1' else (others=>'Z');

  clk_gen : TOP_8254 port map( 
    m_clk0    => s_clk,
    m_clk1    => '0',
    m_clk2    => '0',
    m_clk_ctr => s_clk,
    m_reset   => not m_reset_b,--s_reset,
    m_data    => s_din,
    m_gate0   => '1',
    m_gate1   => '1',
    m_gate2   => '1',
    m_addr    => s_address(1 downto 0),
    m_cs_b    => not s_pcs_addr,
    m_wr_b    => not s_wen,
    m_out0    => sys_clk,
    m_out1    => open,
    m_out2    => open
    );

--for debug
  m_TP(0)  <= s_clk; --test point. for s_clk     ̰ɷ äϴϱ ٲٸ  ȵ
  m_TP(1)  <= sys_clk;--test for 8254 output.   ̰ɷ äϴϱ ٲٸ  ȵ
  m_led(7) <= s_reset;
-----------======================================================--------------------

  RAM0 : memory_block port map( 
    clka  => sys_clk,
    ena   => ram0_ena,
    wea   => ram0_wea,
    addra => ram0_addra,
    dina  => ram0_dina,
    clkb  => s_clk,
    enb   => ram0_enb,
    addrb => ram0_addrb,
    doutb => ram0_doutb
    );

  RAM1 : memory_block port map( 
    clka  => sys_clk,
    ena   => ram1_ena,
    wea   => ram1_wea,
    addra => ram1_addra,
    dina  => ram1_dina,
    clkb  => s_clk,
    enb   => ram1_enb,
    addrb => ram1_addrb,
    doutb => ram1_doutb
    );

  AD_RAM : memory_block port map( 
    clka  => sys_clk,
    ena   => ad_ram_ena,
    wea   => ad_ram_wea,
    addra => ad_ram_addra,
    dina  => ad_ram_dina,
    clkb  => s_clk,
    enb   => ad_ram_enb,
    addrb => ad_ram_addrb,
    doutb => ad_ram_doutb
    );

  DA_RAM : memory_block port map( 
    clka  => s_clk,
    ena   => da_ram_ena,
    wea   => da_ram_wea,
    addra => da_ram_addra,
    dina  => da_ram_dina,
    clkb  => sys_clk,
    enb   => da_ram_enb,
    addrb => da_ram_addrb,
    doutb => da_ram_doutb
    );

  in_latch : fdce8 PORT MAP (
    d            => s_din,
    q            => s_data,
    clock        => s_clk,
    clear        => '0',
    clock_enable => '1'
    );

  out_latch : fdce8 PORT MAP (
    d            => mux_out_o,
    q            => outlatch_dout,
    clock        => s_clk,
    clear        => '0',
    clock_enable => '1'
    );

  da_latch : fdce8 PORT MAP (
    d            => da_ram_doutb,
    q            => m_DAC_data,
    clock        => sys_clk,
    clear        => '0',
    clock_enable => '1'
    );

  ad_latch : fdce8 PORT MAP (
    d            => m_ADC_data,
    q            => ad_ram_dina,
    clock        => sys_clk,
    clear        => '0',
    clock_enable => '1'
    );

  address_latch : fdce9 PORT MAP (
    d            => m_address,
    q            => s_address,
    clock        => s_clk,
    clear        => '0',
    clock_enable => '1'
    );

  ren_latch : fdce PORT MAP (
    d            => m_ren,
    q            => s_ren,
    clock        => s_clk,
    clear        => '0',
    clock_enable => '1'
    );

  wen_latch : fdce PORT MAP (
    d            => m_wen,
    q            => s_wen,
    clock        => s_clk,
    clear        => '0',
    clock_enable => '1'
    );

  oe_latch : fdce PORT MAP (
    d            => m_oe_b,
    q            => s_oe_b,
    clock        => s_clk,
    clear        => '0',
    clock_enable => '1'
    );

  cmd_latch : fdce PORT MAP (
    d            => m_cmd_data,
    q            => s_cmd_data,
    clock        => s_clk,
    clear        => '0',
    clock_enable => '1'
    );

  out_mux: multiplexer_2to1 port map(
    sel => mux_out_sel, 
    in0 => ram0_doutb,
    in1 => ram1_doutb,
    o   => mux_out_o
    );

  ram0_mux: multiplexer_2to1 port map(
    sel => mux_ram0_sel, 
    in0 => s_data,
    in1 => ad_ram_doutb,
    o   => ram0_dina
    );

  ram1_mux: multiplexer_3to1 port map(
    sel => mux_ram1_sel,  
    in0 => filter_out,
    in1 => ram0_doutb,
    in2 => s_data,
    o   => ram1_dina
    );

  decoder: address_decoder PORT MAP (
    s_address    => s_address,
    mode_addr    => mode_addr,
    s_pcs_addr   => s_pcs_addr,
    s_reset_addr => s_reset
    );

  controller: control_signal_gen port map(
    m_reset      => not m_reset_b,
    s_reset_addr => s_reset_addr,

    s_clk        => s_clk,
    sys_clk      => sys_clk,
    mode_addr    => mode_addr,
    s_data       => s_data,
    s_wen        => s_wen,
    s_ren        => s_ren,
    s_oe_b       => s_oe_b,

    ram0_ena     => ram0_ena,
    ram0_wea     => ram0_wea,
    ram0_addra   => ram0_addra,
    ram0_dina    => ram0_dina,
    ram0_enb     => ram0_enb,
    ram0_addrb   => ram0_addrb,
    ram0_doutb   => ram0_doutb,

    ram1_ena     => ram1_ena,
    ram1_wea     => ram1_wea,
    ram1_addra   => ram1_addra,
    ram1_dina    => ram1_dina,
    ram1_enb     => ram1_enb,
    ram1_addrb   => ram1_addrb,
    ram1_outb    => ram1_outb,

    da_ram_ena   => da_ram_ena,
    da_ram_wea   => da_ram_wea,
    da_ram_addra => da_ram_addra,
    da_ram_dina  => da_ram_dina,
    da_ram_enb   => da_ram_enb,
    da_ram_addrb => da_ram_addrb,
    da_ram_doutb => da_ram_doutb,

    da_ram_ena   => da_ram_ena,
    da_ram_wea   => da_ram_wea,
    da_ram_addra => da_ram_addra,
    da_ram_dina  => da_ram_dina,
    da_ram_enb   => da_ram_enb,
    da_ram_addrb => da_ram_addrb,
    da_ram_doutb => da_ram_doutb,

    mux_out_sel  => mux_out_sel,
    mux_ram0_sel => mux_ram0_sel,
    mux_ram1_sel => mux_ram1_se,

    s_dout_en    => s_dout_en,
    m_led        => m_led,
    m_TP         => m_TP
    );

  m_led(6 downto 0)<=s_led(6 downto 0);

end Behavioral;


