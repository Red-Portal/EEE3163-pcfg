----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:01:22 11/16/2018 
-- Design Name: 
-- Module Name:    ctrl_signal_gen - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_signal_gen is
  port (
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

    ad_ram_ena   : out STD_LOGIC;
    ad_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0);
    ad_ram_addra : out STD_LOGIC_VECTOR (10 downto 0);
    ad_ram_enb   : out STD_LOGIC;
    ad_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0);

    da_ram_ena   : out STD_LOGIC;
    da_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0);
    da_ram_addra : out STD_LOGIC_VECTOR (10 downto 0);
    da_ram_enb   : out STD_LOGIC;
    da_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0);

    mux_out_sel  : out STD_LOGIC;
    mux_ram0_sel : out STD_LOGIC;
    mux_ram1_sel : out STD_LOGIC_VECTOR (1 downto 0);

    s_dout_en    : out STD_LOGIC;
    m_led        : out STD_LOGIC_VECTOR (7 downto 0);
    m_TP         : out STD_LOGIC_VECTOR (1 downto 0)
    );
end control_signal_gen;
architecture Behavioral of control_signal_gen is
  COMPONENT fdce11
    PORT(
      clock        : IN  std_logic;
      clock_enable : IN  std_logic;
      clear        : IN  std_logic;
      d            : IN  std_logic_vector(10 downto 0);
      q            : OUT std_logic_vector(10 downto 0)
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

  component controller_pc is
    Port (s_clk         : in  STD_LOGIC;
          m_reset       : in  STD_LOGIC;
          s_ren         : in  std_logic;
          s_wen         : in  std_logic;
          ctrl_startio  : in  STD_LOGIC;
          ram_ena       : out STD_LOGIC;
          ram_wea       : out std_logic_vector(0 downto 0);
          ram_enb       : out STD_LOGIC;
          mux_ram_sel   : out std_logic;
          count_ram_ce  : out STD_LOGIC;
          count_data_ce : out STD_LOGIC
          );
  end component;

  COMPONENT controller_da
    port(
      s_clk               : in  STD_LOGIC;
      sys_clk             : in  STD_LOGIC;
      m_reset             : in  STD_LOGIC;
      da_ram_ena          : out STD_LOGIC;
      da_ram_wea          : out STD_LOGIC_VECTOR (0 downto 0);
      da_ram_addra        : out STD_LOGIC_VECTOR (10 downto 0);
      da_ram_enb          : out STD_LOGIC;
      da_ram_addrb        : out STD_LOGIC_VECTOR (10 downto 0);
      ram1_enb            : out STD_LOGIC;
      count_ram1_ce       : out STD_LOGIC;
      count_ram1_sclr     : out STD_LOGIC;
      count_ram1_q        : in  STD_LOGIC_VECTOR (10 downto 0);
      count_data_q        : in  STD_LOGIC_VECTOR (10 downto 0);
      ctrl_da_mode        : in  STD_LOGIC
      );
  END component;

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
      ad_ram_addra    : out STD_LOGIC_vector (10 downto 0);
      ad_ram_addrb    : out STD_LOGIC_vector (10 downto 0);
      ad_ram_ena      : out STD_LOGIC;
      ad_ram_wea      : out STD_LOGIC_VECTOR (0 downto 0);
      ad_ram_enb      : out STD_LOGIC;
      ram0_ena        : out STD_LOGIC;
      ram0_wea        : out STD_LOGIC_VECTOR (0 downto 0);
      ctrl_ad_mode    : in  std_logic
      );
  END component;

  constant mode_pc0      : std_logic_vector(2 downto 0) := "001";
  constant mode_pc1      : std_logic_vector(2 downto 0) := "010";
  constant mode_transfer : std_logic_vector(2 downto 0) := "011";
  constant mode_da_start : std_logic_vector(2 downto 0) := "100";
  constant mode_da_stop  : std_logic_vector(2 downto 0) := "101";
  constant mode_ad       : std_logic_vector(2 downto 0) := "110";
  constant mode_avg      : std_logic_vector(2 downto 0) := "111";

  signal count_data_ce   : std_logic;
  signal count_data_sclr : std_logic;
  signal count_data_q    : std_logic_vector(10 downto 0);

  signal count_ram0_ce   : std_logic;
  signal count_ram0_sclr : std_logic;
  signal count_ram0_q    : std_logic_vector(10 downto 0);

  signal count_ram1_ce   : std_logic;
  signal count_ram1_sclr : std_logic;
  signal count_ram1_q    : std_logic_vector(10 downto 0);

  signal pc_read_ready_flag : std_logic;
  signal pc_write_ready_flag : std_logic;

  signal ctrl_pc0_startio : std_logic;
  signal ctrl_pc1_startio : std_logic;
  signal ctrl_transfer    : std_logic;
  signal ctrl_da_mode     : std_logic;
  signal ctrl_ad_mode     : std_logic;
  signal ctrl_avg         : std_logic;

  signal count_data_load : std_logic;
  signal count_da_ce     : std_logic;
  signal count_da_sclr   : std_logic;
  signal count_da_q      : std_logic_vector(10 downto 0);

  signal s_count_ram0_q : std_logic_vector(10 downto 0);
  signal s_count_ram1_q : std_logic_vector(10 downto 0);

  signal s_pc0_ram_ena       : std_logic;
  signal s_pc0_ram_wea       : std_logic_vector(0 downto 0);
  signal s_pc0_ram_enb       : std_logic;
  signal s_pc0_count_ram_ce  : std_logic;
  signal s_pc0_count_data_ce : std_logic;
  signal s_pc0_mux_sel       : std_logic;

  signal s_pc1_ram_ena       : std_logic;
  signal s_pc1_ram_wea       : std_logic_vector(0 downto 0);
  signal s_pc1_ram_enb       : std_logic;
  signal s_pc1_count_ram_ce  : std_logic;
  signal s_pc1_count_data_ce : std_logic;
  signal s_pc1_mux_sel       : std_logic;

  signal s_da_count_ram1_ce   : std_logic;
  signal s_da_count_ram1_sclr : std_logic;
  signal s_da_ram1_enb        : std_logic;

  signal s_ad_count_ram0_ce   : std_logic;
  signal s_ad_count_ram0_sclr : std_logic;
  signal s_ad_ram0_ena        : std_logic;
  signal s_ad_ram0_wea        : std_logic_vector(0 downto 0);
  signal s_ad_ram0_mux_sel    : std_logic;

  signal s_count_data_sclr : std_logic;
  signal s_count_ram0_sclr : std_logic;
  signal s_count_ram1_sclr : std_logic;

  signal s_debug_clk : std_logic;

  type state_t is (st_reset,
                   st_idle,
                   st_transfer_mode,
                   st_ad_mode,
                   st_da_mode,
                   st_avg_mode,
                   st_pc0_clear,
                   st_pc0_read_mode,
                   st_pc0_read_wait,
                   st_pc0_write_mode,
                   st_pc0_write_wait,
                   st_pc1_clear,
                   st_pc1_read_mode,
                   st_pc1_read_wait,
                   st_pc1_write_mode,
                   st_pc1_write_wait
                   );
  signal current_state, next_state: state_t;
begin
  data_counter: load_counter PORT map (
    l    => std_logic_vector(resize(unsigned(s_data), 11)),
    load => count_data_load,
    clk  => s_clk,
    ce   => count_data_ce,
    sclr => count_data_sclr,
    q    => count_data_q
    );

  ram0_counter: counter PORT MAP (
    clk  => s_clk,
    ce   => count_ram0_ce,
    sclr => count_ram0_sclr,
    q    => count_ram0_q
    );

  ram1_counter: counter PORT MAP (
    clk  => s_clk,
    ce   => count_ram1_ce,
    sclr => count_ram1_sclr,
    q    => count_ram1_q
    );

  pc0_control: controller_pc PORT map (
    s_clk         => s_clk,
    m_reset       => m_reset,
    s_ren         => s_ren,
    s_wen         => s_wen,
    ram_ena       => s_pc0_ram_ena,
    ram_wea       => s_pc0_ram_wea,
    ram_enb       => s_pc0_ram_enb,
    ctrl_startio  => ctrl_pc0_startio,
    mux_ram_sel   => s_pc0_mux_sel,
    count_ram_ce  => s_pc0_count_ram_ce,
    count_data_ce => s_pc0_count_data_ce
    );

  pc1_control: controller_pc PORT map (
    s_clk         => s_clk,
    m_reset       => m_reset,
    s_ren         => s_ren,
    s_wen         => s_wen,
    ram_ena       => s_pc1_ram_ena,
    ram_wea       => s_pc1_ram_wea,
    ram_enb       => s_pc1_ram_enb,
    ctrl_startio  => ctrl_pc1_startio,
    mux_ram_sel   => s_pc1_mux_sel,
    count_ram_ce  => s_pc1_count_ram_ce,
    count_data_ce => s_pc1_count_data_ce
    );

  da_control: controller_da PORT MAP (
    s_clk           => s_clk,
    sys_clk         => sys_clk,
    m_reset         => m_reset,
    da_ram_ena      => da_ram_ena,
    da_ram_wea      => da_ram_wea,
    da_ram_addra    => da_ram_addra,
    da_ram_enb      => da_ram_enb,
    da_ram_addrb    => da_ram_addrb,
    ram1_enb        => s_da_ram1_enb,
    count_ram1_ce   => s_da_count_ram1_ce,
    count_ram1_sclr => s_da_count_ram1_sclr,
    count_ram1_q    => count_ram1_q,
    count_data_q    => count_data_q,
    ctrl_da_mode    => ctrl_da_mode
    );

  ad_control: controller_ad PORT MAP (
    m_reset         => m_reset,
    s_clk           => s_clk,
    sys_clk         => sys_clk,
    count_data_load => count_data_load,
    count_data_q    => count_data_q,
    count_ram0_q    => count_ram0_q,
    count_ram0_ce   => s_ad_count_ram0_ce,
    count_ram0_sclr => s_ad_count_ram0_sclr,
    mux_ram0_sel    => s_ad_ram0_mux_sel,
    ad_ram_addra    => ad_ram_addra,
    ad_ram_ena      => ad_ram_ena,
    ad_ram_wea      => ad_ram_wea,
    ad_ram_enb      => ad_ram_enb,
    ram0_ena        => s_ad_ram0_ena,
    ram0_wea        => s_ad_ram0_wea,
    ctrl_ad_mode    => ctrl_ad_mode
    );

  ram0_addra   <= count_ram0_q;
  ram0_addrb   <= count_ram0_q;
  ram1_addra   <= count_ram1_q;
  ram1_addrb   <= count_ram1_q;
  ad_ram_addrb <= count_ram0_q;

  ram0_ena <= '1' when (s_pc0_ram_ena = '1' and current_state = st_pc0_write_mode) else
              '1' when (s_ad_ram0_ena = '1') else
              '0';
  ram0_wea <= "1" when (s_pc0_ram_wea = "1" and current_state = st_pc0_write_mode) else
              "1" when (s_ad_ram0_wea = "1") else
              "0";
  ram0_enb <= '1' when (s_pc0_ram_enb = '1' and current_state = st_pc0_read_mode) else
              '0';

  count_ram0_sclr <= '1' when (s_count_ram0_sclr = '1') else
                     '1' when (s_ad_count_ram0_sclr = '1') else
                     '0';

  count_ram0_ce <= '1' when (s_pc0_count_ram_ce = '1') else
                   '1' when (s_ad_count_ram0_ce = '1') else
                   '0';

  ------------------------------------------------------------------------------------

  ram1_ena <= '1' when (s_pc1_ram_ena = '1' and current_state = st_pc1_write_mode) else
              '0';
  ram1_wea <= "1" when (s_pc1_ram_wea = "1" and current_state = st_pc1_write_mode) else
              "0";
  ram1_enb <= '1' when (s_pc1_ram_enb = '1' and current_state = st_pc1_read_mode) else
              '1' when (s_da_ram1_enb = '1' and current_state = st_da_mode) else
              '0';

  count_ram1_sclr <= '1' when (s_count_ram1_sclr = '1') else
                     '1' when (s_da_count_ram1_sclr = '1' and current_state = st_da_mode) else
                     '0';

  count_ram1_ce <= '1' when (s_pc1_count_ram_ce = '1') else
                   '1' when (s_da_count_ram1_ce = '1' and current_state = st_da_mode) else
                   '0';
  ------------------------------------------------------------------------------------

  count_data_sclr <= '1' when (s_count_data_sclr = '1') else
                     --'1' when (s_da_count_ram1_sclr and current_state = st_da_mode) else
                     '0';

  count_data_ce <= '1' when (s_pc0_count_data_ce = '1') else
                   '1' when (s_pc1_count_data_ce = '1') else
                   '0';

  ------------------------------------------------------------------------------------

  pc_read_ready_flag   <= '1' when ((s_oe_b = '0') and ((mode_addr = mode_pc0)
                                                        or (mode_addr = mode_pc1))) else
                          '0';
  pc_write_ready_flag  <= '1' when ((s_oe_b = '1') and ((mode_addr = mode_pc0)
                                                        or (mode_addr = mode_pc1))) else
                          '0';

  s_dout_en <= pc_read_ready_flag;

  mux_out_sel <= '1' when (s_pc0_mux_sel = '1' and s_pc1_mux_sel = '0') else
                 '0';

  mux_ram0_sel <= '1' when (pc_write_ready_flag = '1') else
                  '0' when (s_ad_ram0_mux_sel = '1' and current_state = st_ad_mode) else
                  '0';

  mux_ram1_sel <= "00" when (mode_addr = mode_avg) else
                  "01" when (mode_addr = mode_transfer) else
                  "10" when (pc_write_ready_flag = '1') else
                  "11";

  debug_clk_proc: process
  begin
    s_debug_clk <= '0';
    wait for 2.5ns ;
    s_debug_clk <= '1';
    wait for 2.5ns;
  end process;

  clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      current_state <= st_reset;
    elsif (rising_edge(s_clk)) then
      current_state <= next_state;
    end if;
  end process;

  pcfg_control_proc: process(s_debug_clk, mode_addr, s_ren, s_wen)
  begin
    case current_state is
      when st_reset =>
        s_count_data_sclr <= '1';
        s_count_ram0_sclr <= '1';
        s_count_ram1_sclr <= '1';
        ctrl_pc0_startio  <= '0';
        ctrl_pc1_startio  <= '0';
        ctrl_transfer     <= '0';
        ctrl_da_mode      <= '0';
        ctrl_ad_mode      <= '0';
        ctrl_avg          <= '0';

        next_state        <= st_idle;
        
      when st_idle =>
        s_count_data_sclr <= '0';
        s_count_ram0_sclr <= '0';
        s_count_ram1_sclr <= '0';
        ctrl_pc0_startio  <= '0';
        ctrl_pc1_startio  <= '0';
        ctrl_transfer     <= '0';
        ctrl_da_mode      <= '0';
        ctrl_ad_mode      <= '0';
        ctrl_avg          <= '0';

        if(mode_addr = mode_pc0) then
          next_state <= st_pc0_clear;
        elsif(mode_addr = mode_pc1) then
          next_state <= st_pc1_clear;
        elsif(mode_addr = mode_transfer) then
          next_state <= st_transfer_mode;
        elsif(mode_addr = mode_da_start) then
          next_state <= st_da_mode;
        elsif(mode_addr = mode_ad) then
          next_state <= st_ad_mode;
        elsif(mode_addr = mode_avg) then
          next_state <= st_avg_mode;
        end if;
        
      when st_ad_mode =>
        ctrl_ad_mode <= '1';
        if(mode_addr = mode_ad) then
          next_state <= st_ad_mode;
        else
          next_state <= st_idle;
        end if;

      when st_da_mode =>
        ctrl_da_mode <= '1';
        if(mode_addr = mode_da_stop) then
          next_state <= st_idle;
        else
          next_state <= st_da_mode;
        end if;

      when st_transfer_mode =>
        if(mode_addr = mode_transfer) then
          next_state <= st_transfer_mode;
        else
          next_state <= st_idle;
        end if;
        
      when st_pc0_clear =>
        s_count_data_sclr <= '1';
        s_count_ram0_sclr <= '1';

        if(pc_read_ready_flag = '1') then
          next_state <= st_pc0_read_mode;
        elsif(pc_write_ready_flag = '1') then
          next_state <= st_pc0_write_mode;
        else
          next_state <= st_reset;
        end if;

      when st_pc0_read_mode =>
        s_count_data_sclr <= '0';
        s_count_ram0_sclr <= '0';
        ctrl_pc0_startio <= '1';

        if(pc_read_ready_flag = '1') then
          next_state <= st_pc0_read_mode;
        else
          next_state <= st_pc0_read_wait;
        end if;

      when st_pc0_read_wait =>
        ctrl_pc0_startio <= '0';

        if(mode_addr = mode_pc0 and pc_read_ready_flag = '1') then
          next_state <= st_pc0_read_mode;
        elsif(mode_addr = "000") then
          next_state <= st_pc0_read_wait;
        else
          next_state <= st_idle;
        end if;

      when st_pc0_write_mode =>
        s_count_data_sclr <= '0';
        s_count_ram0_sclr <= '0';
        ctrl_pc0_startio <= '1';

        if(pc_write_ready_flag = '1') then
          next_state <= st_pc0_write_mode;
        else
          next_state <= st_pc0_write_wait;
        end if;

      when st_pc0_write_wait =>
        ctrl_pc0_startio <= '0';

        if(mode_addr = mode_pc0 and pc_write_ready_flag = '1') then
          next_state <= st_pc0_write_mode;
        elsif(mode_addr = "000") then
          next_state <= st_pc0_write_wait;
        else
          next_state <= st_idle;
        end if;

      when st_pc1_clear =>
        s_count_ram1_sclr <= '1';
        s_count_data_sclr <= '1';

        if(pc_read_ready_flag = '1') then
          next_state <= st_pc1_read_mode;
        elsif(pc_write_ready_flag = '1') then
          next_state <= st_pc1_write_mode;
        else
          next_state <= st_reset;
        end if;

      when st_pc1_read_mode =>
        s_count_data_sclr <= '0';
        s_count_ram1_sclr <= '0';
        ctrl_pc1_startio <= '1';

        if(pc_read_ready_flag = '1') then
          next_state <= st_pc1_read_mode;
        else
          next_state <= st_pc1_read_wait;
        end if;

      when st_pc1_read_wait =>
        ctrl_pc1_startio <= '0';

        if(mode_addr = mode_pc1 and pc_read_ready_flag = '1') then
          next_state <= st_pc1_read_mode;
        elsif(mode_addr = "000") then
          next_state <= st_pc1_read_wait;
        else
          next_state <= st_idle;
        end if;

      when st_pc1_write_mode =>
        s_count_data_sclr <= '0';
        s_count_ram1_sclr <= '0';
        ctrl_pc1_startio <= '1';

        if(pc_write_ready_flag = '1') then
          next_state <= st_pc1_write_mode;
        else
          next_state <= st_pc1_write_wait;
        end if;

      when st_pc1_write_wait =>
        ctrl_pc1_startio <= '0';

        if(mode_addr = mode_pc1 and pc_write_ready_flag = '1') then
          next_state <= st_pc1_write_mode;
        elsif(mode_addr = "000") then
          next_state <= st_pc1_write_wait;
        else
          next_state <= st_idle;
        end if;
      when others =>
        next_state <= st_reset;
    end case;
  end process;
end Behavioral;

