----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:50:38 11/16/2018 
-- Design Name: 
-- Module Name:    controller_da - Behavioral 
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

entity controller_da is
  Port (s_clk           : in  STD_LOGIC;
        sys_clk         : in  STD_LOGIC;
        m_reset         : in  STD_LOGIC;
        da_ram_ena      : out STD_LOGIC;
        da_ram_wea      : out STD_LOGIC_VECTOR (0 downto 0);
        da_ram_addra    : out STD_LOGIC_VECTOR (10 downto 0);
        da_ram_enb      : out STD_LOGIC;
        da_ram_addrb    : out STD_LOGIC_VECTOR (10 downto 0);
        ram1_enb        : out STD_LOGIC;
        count_ram1_ce   : out STD_LOGIC;
        count_ram1_sclr : out STD_LOGIC;
        count_ram1_q    : in  STD_LOGIC_VECTOR (10 downto 0);
        count_data_q    : in  STD_LOGIC_VECTOR (10 downto 0);
        ctrl_da_mode    : in  STD_LOGIC
        );
end controller_da;
architecture Behavioral of controller_da is
  COMPONENT counter
    PORT(
      clk  : IN  std_logic;
      ce   : IN  std_logic;
      sclr : IN  std_logic;
      q    : OUT std_logic_vector(10 downto 0)
      );
  END component;

  type state_t is (st_idle,
                   st_outputlag,
                   st_write,
                   st_writeclear,
                   st_stop_wait,
                   st_clear,
                   st_deep_reset
                   );

  signal count_da_ce   : std_logic;
  signal count_da_sclr : std_logic;
  signal count_da_q    : std_logic_vector(10 downto 0);

  signal count_da2_ce   : std_logic;
  signal count_da2_sclr : std_logic;
  signal count_da2_q    : std_logic_vector(10 downto 0);

  signal da_current_state   : state_t;
  signal da_next_state      : state_t;
  signal ram1_current_state : state_t;
  signal ram1_next_state    : state_t;

  signal s_da_read_enable : std_logic;
begin
  da_counter: counter PORT MAP (
    clk  => sys_clk,
    ce   => count_da_ce,
    sclr => count_da_sclr,
    q    => count_da_q
    );

  da_counter2: counter PORT MAP (
    clk  => s_clk,
    ce   => count_da2_ce,
    sclr => count_da2_sclr,
    q    => count_da2_q
    );

  da_ram_addrb  <= count_da_q;

  da_ram_addra <= count_da2_q;

  da_ram_enb <= '0' when (da_current_state = st_clear) else
                '1';

  count_da_sclr <= '1' when (da_current_state = st_deep_reset) else
                   '1' when (da_current_state = st_clear) else
                   '1' when (da_current_state = st_writeclear) else
                   '0';

  count_da_ce <= '1' when (da_current_state = st_write) else
                 '0';

  s_da_read_enable <= '0' when (ram1_current_state = st_idle) else
                      '1';

  count_ram1_sclr <= '1' when (ram1_current_state = st_clear) else
                     '0';

  count_ram1_ce <= '1' when (ram1_current_state = st_outputlag) else
                   '1' when (ram1_current_state = st_write) else
                   '0';

  count_da2_sclr <= '1' when (ram1_current_state = st_clear) else
                    '0';

  count_da2_ce <= '1' when (ram1_current_state = st_write) else
                  '0';

  ram1_enb <= '1' when (ram1_current_state = st_outputlag) else
              '1' when (ram1_current_state = st_write) else
              '0';

  da_ram_wea <= "1" when(ram1_current_state = st_write) else
                "0";

  da_ram_ena <= '1' when(ram1_current_state = st_write) else
                '0';

  da_clk_proc: process(sys_clk, m_reset)
  begin
    if(m_reset = '1') then
      da_current_state <= st_deep_reset;
    elsif (rising_edge(sys_clk)) then
      da_current_state <= da_next_state;
    end if;
  end process;

  da_proc: process(sys_clk, ctrl_da_mode, count_data_q)
  begin
    case da_current_state is
      when st_deep_reset =>
        da_next_state <= st_idle;	 
	 
      when st_idle =>
        if(s_da_read_enable = '1') then
          da_next_state <= st_clear;
        else
          da_next_state <= st_idle;
        end if;
        
      when st_clear =>
        if(s_da_read_enable = '0') then
          da_next_state <= st_idle;
        else
          da_next_state <= st_write;
        end if;

      when st_write =>
        if(s_da_read_enable = '0') then
          da_next_state <= st_idle;
        elsif(unsigned(count_da_q) + 2 = unsigned(count_data_q)) then
          da_next_state <= st_writeclear;
        else
          da_next_state <= st_write;
        end if;

      when st_writeclear =>
        if(s_da_read_enable = '0') then
          da_next_state <= st_idle;
        else
          da_next_state <= st_write;
        end if;

      when others =>
        da_next_state <= st_clear;

    end case;
  end process;

  ram1_clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      ram1_current_state <= st_idle;
    elsif (rising_edge(s_clk)) then
      ram1_current_state <= ram1_next_state;
    end if;
  end process;

  ram1_proc: process(s_clk, ctrl_da_mode, ram1_current_state,
                     count_ram1_q, count_data_q)
  begin
    case ram1_current_state is
      when st_idle =>
        if(ctrl_da_mode = '1') then
          ram1_next_state <= st_clear;
        else
          ram1_next_state <= st_idle;
        end if;

      when st_clear =>
        if(ctrl_da_mode = '0') then
          ram1_next_state <= st_idle;
        else
          ram1_next_state <= st_outputlag;
        end if;

      when st_outputlag =>
        if(ctrl_da_mode = '0') then
          ram1_next_state <= st_idle;
        else
          ram1_next_state <= st_write;
        end if;

      when st_write =>
        if(ctrl_da_mode = '0') then
          ram1_next_state <= st_idle;
        elsif(unsigned(count_ram1_q) = unsigned(count_data_q)) then
          ram1_next_state <= st_stop_wait;
        else
          ram1_next_state <= st_write;
        end if;

      when st_stop_wait =>
        if(ctrl_da_mode = '0') then
          ram1_next_state <= st_idle;
        else
          ram1_next_state <= st_stop_wait;
        end if;

      when others =>
        ram1_next_state <= st_clear;

    end case;
  end process;
end Behavioral;

