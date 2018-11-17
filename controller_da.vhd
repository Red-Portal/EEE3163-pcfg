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
                   st_write,
                   st_stop_wait,
                   st_clear);

  signal count_da_ce   : std_logic;
  signal count_da_sclr : std_logic;
  signal count_da_q    : std_logic_vector(10 downto 0);

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

  da_clk_proc: process(sys_clk, m_reset)
  begin
    if(m_reset = '1') then
      da_current_state <= st_idle;
    elsif (rising_edge(sys_clk)) then
      da_current_state <= da_next_state;
    end if;
  end process;

  da_proc: process(sys_clk, ctrl_da_mode)
  begin
    da_ram_addrb  <= count_da_q;

    case da_current_state is
      when st_idle =>
        da_ram_enb    <= '0';
        count_da_ce   <= '0';
        count_da_sclr <= '0';

        if(s_da_read_enable = '1') then
          da_next_state <= st_clear;
        else
          da_next_state <= st_idle;
        end if;
        
      when st_clear =>
        da_ram_enb    <= '1';
        da_ram_addrb  <= count_da_q;
        count_da_ce   <= '0';
        count_da_sclr <= '1';

        if(s_da_read_enable = '0') then
          da_next_state <= st_idle;
        else
          da_next_state <= st_write;
        end if;

      when st_write =>
        da_ram_enb    <= '1';
        da_ram_addrb  <= count_da_q;
        count_da_ce   <= '1';
        count_da_sclr <= '0';

        if(s_da_read_enable = '0') then
          da_next_state <= st_idle;
        elsif(count_da_q >= std_logic_vector(unsigned(count_data_q) - 1)) then
          da_next_state <= st_clear;
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

  ram1_proc: process(s_clk, ctrl_da_mode)
  begin
    da_ram_addra <= count_ram1_q;
     
    case ram1_current_state is
      when st_idle =>
        count_ram1_ce    <= '0';
        count_ram1_sclr  <= '0';
        ram1_enb         <= '0';
        da_ram_wea       <= "0";
        da_ram_ena       <= '0';
        s_da_read_enable <= '0';

        if(ctrl_da_mode = '1') then
          ram1_next_state <= st_clear;
        else
          ram1_next_state <= st_idle;
        end if;

      when st_clear =>
        s_da_read_enable <= '1';
        count_ram1_sclr <= '1';

        if(ctrl_da_mode = '0') then
          ram1_next_state <= st_idle;
        else
          ram1_next_state <= st_write;
        end if;

      when st_write =>
        s_da_read_enable <= '1';
        count_ram1_ce    <= '1';
        count_ram1_sclr  <= '0';
        ram1_enb         <= '1';
        da_ram_wea       <= "1";
        da_ram_ena       <= '1';

        if(ctrl_da_mode = '0') then
          ram1_next_state <= st_idle;
        elsif(count_ram1_q >= std_logic_vector(unsigned(count_data_q) - 1)) then
          ram1_next_state <= st_stop_wait;
        else
          ram1_next_state <= st_write;
        end if;

      when st_stop_wait =>
        s_da_read_enable <= '1';
        count_ram1_ce    <= '0';
        count_ram1_sclr  <= '0';
        ram1_enb         <= '0';
        da_ram_wea       <= "0";
        da_ram_ena       <= '0';

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

