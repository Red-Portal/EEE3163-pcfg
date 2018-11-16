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
      s_oe_b       : in  STD_LOGIC;

      ram0_ena     : out STD_LOGIC;
      ram0_wea     : out STD_LOGIC_VECTOR (0 downto 0);
      ram0_addra   : out STD_LOGIC_VECTOR (10 downto 0);
      ram0_enb     : out STD_LOGIC;
      ram0_addrb   : out STD_LOGIC_VECTOR (10 downto 0);

      ram1_ena     : out STD_LOGIC;
      ram1_wea     : out STD_LOGIC_VECTOR (0 downto 0);
      ram1_addra   : out STD_LOGIC_VECTOR (10 downto 0);
      ram1_enb     : out STD_LOGIC;
      ram1_addrb   : out STD_LOGIC_VECTOR (10 downto 0);

      da_ram_ena   : out STD_LOGIC;
      da_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0);
      da_ram_addra : out STD_LOGIC_VECTOR (10 downto 0);
      da_ram_enb   : out STD_LOGIC;
      da_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0);

      ad_ram_ena   : out STD_LOGIC;
      ad_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0);
      ad_ram_addra : out STD_LOGIC_VECTOR (10 downto 0);
      ad_ram_enb   : out STD_LOGIC;
      ad_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0);

      mux_out_sel  : out STD_LOGIC;
      mux_ram0_sel : out STD_LOGIC;
      mux_ram1_sel : out STD_LOGIC_VECTOR (1 downto 0);

      s_dout_en    : out STD_LOGIC;
      m_led        : out STD_LOGIC_VECTOR (7 downto 0);
      m_TP         : out STD_LOGIC_VECTOR (1 downto 0)
      );
  END component;

  signal m_reset      : STD_LOGIC := '0';
  signal s_reset_addr : STD_LOGIC := '0';

  signal s_clk     : STD_LOGIC                     := '0';
  signal sys_clk   : STD_LOGIC                     := '0';
  signal mode_addr : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
  signal s_data    : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
  signal s_wen     : STD_LOGIC                     := '0';
  signal s_ren     : STD_LOGIC                     := '0';
  signal s_oe_b    : STD_LOGIC                     := '0';

  signal ram0_ena   : STD_LOGIC                      := '0';
  signal ram0_wea   : STD_LOGIC_VECTOR (0 downto 0)  := (others => '0');
  signal ram0_addra : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
  signal ram0_enb   : STD_LOGIC                      := '0';
  signal ram0_addrb : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');

  signal ram1_ena   : STD_LOGIC                      := '0';
  signal ram1_wea   : STD_LOGIC_VECTOR (0 downto 0)  := (others => '0');
  signal ram1_addra : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
  signal ram1_enb   : STD_LOGIC                      := '0';
  signal ram1_addrb : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');

  signal ad_ram_ena   : STD_LOGIC                      := '0';
  signal ad_ram_wea   : STD_LOGIC_VECTOR (0 downto 0)  := (others => '0');
  signal ad_ram_addra : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
  signal ad_ram_enb   : STD_LOGIC                      := '0';
  signal ad_ram_addrb : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');

  signal da_ram_ena   : STD_LOGIC                      := '0';
  signal da_ram_wea   : STD_LOGIC_VECTOR (0 downto 0)  := (others => '0');
  signal da_ram_addra : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
  signal da_ram_enb   : STD_LOGIC                      := '0';
  signal da_ram_addrb : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');

  signal mux_out_sel  : STD_LOGIC                     := '0';
  signal mux_ram0_sel : STD_LOGIC                     := '0';
  signal mux_ram1_sel : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

  signal s_dout_en : STD_LOGIC                     := '0';
  signal m_led     : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
  signal m_TP      : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

  constant s_clk_period   : time := 100 ns;
  constant sys_clk_period : time := 100 ns;
  constant usb_clk_period   : time := s_clk_period * 10;

  constant mode_pc0      : std_logic_vector(2 downto 0) := "001";
  constant mode_pc1      : std_logic_vector(2 downto 0) := "010";
  constant mode_transfer : std_logic_vector(2 downto 0) := "011";
  constant mode_da_start : std_logic_vector(2 downto 0) := "100";
  constant mode_da_stop  : std_logic_vector(2 downto 0) := "101";
  constant mode_ad       : std_logic_vector(2 downto 0) := "110";
  constant mode_avg      : std_logic_vector(2 downto 0) := "111";

  procedure wave_mode_pc0_read(
    signal mode_addr : out std_logic_vector(2 downto 0);
    signal wen     : out std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_pc0; 
    wen <= '0';
    ren <= '0';
    oe_b <= '0';
    wait for usb_clk_period / 2;
    wen <= '0';
    ren <= '1';
    wait for usb_clk_period / 2;
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    mode_addr <= "000"; 
  end;

  procedure wave_mode_pc0_write(
    signal mode_addr : out std_logic_vector(2 downto 0);
    signal wen     : out std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_pc0; 
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    wait for usb_clk_period / 2;
    wen <= '1';
    ren <= '0';
    wait for usb_clk_period / 2;
    wen <= '0';
    ren <= '0';
    mode_addr <= "000"; 
  end;

  procedure wave_mode_pc1_read(
    signal mode_addr : out std_logic_vector(2 downto 0);
    signal wen     : out std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_pc1; 
    wen <= '0';
    ren <= '0';
    oe_b <= '0';
    wait for usb_clk_period / 2;
    wen <= '0';
    ren <= '1';
    wait for usb_clk_period / 2;
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    mode_addr <= "000"; 
  end;

  procedure wave_mode_pc1_write(
    signal mode_addr : out std_logic_vector(2 downto 0);
    signal wen     : out std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_pc1; 
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    wait for usb_clk_period / 2;
    wen <= '1';
    ren <= '0';
    wait for usb_clk_period / 2;
    wen <= '0';
    ren <= '0';
    mode_addr <= "000"; 
  end;

  procedure wave_mode_transfer(
    signal mode_addr : out std_logic_vector(2 downto 0);
    signal wen     : out std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_transfer; 
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    wait for usb_clk_period;
    wen <= '0';
    ren <= '0';
    mode_addr <= "000"; 
  end;

  procedure wave_mode_da_start(
    signal mode_addr : out std_logic_vector(2 downto 0);
    signal wen     : out std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_da_start; 
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    wait for usb_clk_period;
    wen <= '0';
    ren <= '0';
    mode_addr <= "000"; 
  end;

  procedure wave_mode_da_stop(
    signal mode_addr : out  std_logic_vector(2 downto 0);
    signal wen     : out  std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_da_stop; 
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    wait for usb_clk_period;
    wen <= '0';
    ren <= '0';
    mode_addr <= "000"; 
  end;

  procedure wave_mode_ad(
    signal mode_addr : out  std_logic_vector(2 downto 0);
    signal wen     : out  std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_ad; 
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    wait for usb_clk_period;
    wen <= '0';
    ren <= '0';
    mode_addr <= "000"; 
  end;

  procedure wave_mode_avg(
    signal mode_addr : out std_logic_vector(2 downto 0);
    signal wen     : out std_logic;
    signal ren     : out std_logic;
    signal oe_b    : out std_logic
    ) is
  begin
    mode_addr <= mode_avg; 
    wen <= '0';
    ren <= '0';
    oe_b <= '1';
    wait for usb_clk_period;
    wen <= '0';
    ren <= '0';
    mode_addr <= "000"; 
  end;
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
    s_oe_b       => s_oe_b,

    ram0_ena     => ram0_ena,
    ram0_wea     => ram0_wea,
    ram0_addra   => ram0_addra,
    ram0_enb     => ram0_enb,
    ram0_addrb   => ram0_addrb,

    ram1_ena     => ram1_ena,
    ram1_wea     => ram1_wea,
    ram1_addra   => ram1_addra,
    ram1_enb     => ram1_enb,
    ram1_addrb   => ram1_addrb,

    da_ram_ena   => da_ram_ena,
    da_ram_wea   => da_ram_wea,
    da_ram_addra => da_ram_addra,
    da_ram_enb   => da_ram_enb,
    da_ram_addrb => da_ram_addrb,

    ad_ram_ena   => ad_ram_ena,
    ad_ram_wea   => ad_ram_wea,
    ad_ram_addra => ad_ram_addra,
    ad_ram_enb   => ad_ram_enb,
    ad_ram_addrb => ad_ram_addrb,

    mux_out_sel  => mux_out_sel,
    mux_ram0_sel => mux_ram0_sel,
    mux_ram1_sel => mux_ram1_sel,

    s_dout_en    => s_dout_en,
    m_led        => m_led,
    m_TP         => m_TP
    );


  --  Test Bench Statements
  tb : PROCESS
  begin
    m_reset <= '1';
    wait for 100 ns; -- wait until global set/reset completes
    m_reset <= '0';
    s_oe_b <= '1';

    wait for usb_clk_period;
    wave_mode_pc0_read(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;
    wave_mode_pc0_read(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;
    wave_mode_pc0_read(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;

    wave_mode_pc0_write(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;
    wave_mode_pc0_write(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;

    wave_mode_pc1_read(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;
    wave_mode_pc1_read(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;

    wave_mode_pc1_write(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;
    wave_mode_pc1_write(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;

    wave_mode_transfer(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;

    wave_mode_da_start(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;

    wave_mode_da_stop(mode_addr, s_wen, s_ren, s_oe_b);
    wait for usb_clk_period;
    wait for usb_clk_period;

    s_reset_addr <= '1';
    wait for s_clk_period * 2;
    s_reset_addr <= '0';
    wait for s_clk_period;

    wave_mode_transfer(mode_addr, s_wen, s_ren, s_oe_b);
    wait for s_clk_period;
    wait for usb_clk_period;

    -- Add user defined stimulus here

    wait; -- will wait forever
  END PROCESS tb;
  --  End Test Bench 

END;
