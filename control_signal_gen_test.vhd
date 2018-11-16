-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
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

  signal m_reset      : in  STD_LOGIC := '0';
  signal s_reset_addr : in  STD_LOGIC := '0';

  signal s_clk        : in  STD_LOGIC := '0';
  signal sys_clk      : in  STD_LOGIC := '0';
  signal mode_addr    : in  STD_LOGIC_VECTOR (2 downto 0) := (others=>'0');
  signal s_data       : in  STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
  signal s_wen        : in  STD_LOGIC := '0';
  signal s_ren        : in  STD_LOGIC := '0';

  signal ram0_ena     : out STD_LOGIC := '0';
  signal ram0_wea     : out STD_LOGIC_VECTOR (0 downto 0) := (others=>'0');
  signal ram0_addra   : out STD_LOGIC_VECTOR (10 downto 0) := (others=>'0');
  signal ram0_dina    : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
  signal ram0_enb     : out STD_LOGIC := '0';
  signal ram0_addrb   : out STD_LOGIC_VECTOR (10 downto 0) := (others=>'0');
  signal ram0_doutb   : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');

  signal ram1_ena     : out STD_LOGIC := '0';
  signal ram1_wea     : out STD_LOGIC_VECTOR (0 downto 0) := (others=>'0');
  signal ram1_addra   : out STD_LOGIC_VECTOR (10 downto 0) := (others=>'0');
  signal ram1_dina    : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
  signal ram1_enb     : out STD_LOGIC := '0';
  signal ram1_addrb   : out STD_LOGIC_VECTOR (10 downto 0) := (others=>'0');
  signal ram1_outb    : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');

  signal ad_ram_ena   : out STD_LOGIC := '0';
  signal ad_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0) := (others=>'0');
  signal ad_ram_addra : out STD_LOGIC_VECTOR (10 downto 0) := (others=>'0');
  signal ad_ram_dina  : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
  signal ad_ram_enb   : out STD_LOGIC := '0';
  signal ad_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0) := (others=>'0');
  signal ad_ram_doutb : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');

  signal da_ram_ena   : out STD_LOGIC := '0';
  signal da_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0) := (others=>'0');
  signal da_ram_addra : out STD_LOGIC_VECTOR (10 downto 0) := (others=>'0');
  signal da_ram_dina  : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
  signal da_ram_enb   : out STD_LOGIC := '0';
  signal da_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0) := (others=>'0');
  signal da_ram_doutb : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');

  signal mux_out_sel  : out STD_LOGIC := '0';
  signal mux_ram0_sel : out STD_LOGIC := '0';
  signal mux_ram1_sel : out STD_LOGIC_VECTOR (1 downto 0) := (others=>'0');

  signal s_dout_en    : out STD_LOGIC := '0';
  signal m_led        : out STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
  signal m_TP         : out STD_LOGIC_VECTOR (1 downto 0) := (others=>'0');

  constant signal s_clk_period : time := 100 ns;
  constant sys_clk_period      : time := 100 ns;

  signal s_clk   : std_logic := '0';
  signal sys_clk : std_logic := '0';
begin

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

  -- Component Instantiation
  uut: control_signal_gen PORT MAP(
    m_reset      => m_reset,
    s_reset_addr => s_reset_addr,

    s_clk        => s_clk,
    sys_clk      => sys_clk,
    mode_addr    => mode_addr,
    s_data       => s_data,
    s_wen        => s_wen,
    s_ren        => s_ren,

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


  --  Test Bench Statements
  tb : PROCESS
  BEGIN

    wait for 100 ns; -- wait until global set/reset completes

    -- Add user defined stimulus here

    wait; -- will wait forever
  END PROCESS tb;
  --  End Test Bench 

END;
