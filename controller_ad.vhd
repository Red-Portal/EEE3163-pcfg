
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:53:46 11/12/2018 
-- Design Name: 
-- Module Name:    controller_ad - Behavioral 
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

entity controller_ad is
  port (m_reset         : in  std_logic;
        sys_clk         : in  STD_LOGIC;
        s_clk           : in  STD_LOGIC;
        count_data_q    : in  STD_LOGIC_VECTOR (10 downto 0);
        count_ram0_q    : in  std_logic_vector (10 downto 0);
        count_ram0_ce   : out std_logic;
        count_ram0_sclr : out std_logic;
        mux_ram0_sel    : out STD_LOGIC;
        ad_ram_addra    : out std_logic_vector(10 downto 0);
        ad_ram_addrb    : out std_logic_vector(10 downto 0);
        ad_ram_ena      : out STD_LOGIC;
        ad_ram_wea      : out STD_LOGIC_VECTOR (0 downto 0);
        ad_ram_enb      : out STD_LOGIC;
        ram0_ena        : out STD_LOGIC;
        ram0_wea        : out STD_LOGIC_VECTOR (0 downto 0);
        ctrl_ad_mode    : in  std_logic
        );
end controller_ad;

architecture Behavioral of controller_ad is
  type state_t is (st_idle,
                   st_clear,
                   st_write,
                   st_wait,
                   st_outputlag,
                   st_writelag
                   );

  COMPONENT counter
    PORT(
      clk  : IN  std_logic;
      ce   : IN  std_logic;
      sclr : IN  std_logic;
      q    : OUT std_logic_vector(10 downto 0)
      );
  END component;

  signal count_ad_ce   : std_logic;
  signal count_ad_sclr : std_logic;
  signal count_ad_q    : std_logic_vector(10 downto 0);

  signal s_ad_count_ad_ce     : std_logic;
  signal s_ad_count_ad_sclr   : std_logic;
  signal s_ram0_count_ad_ce   : std_logic;
  signal s_ram0_count_ad_sclr : std_logic;

  signal ad_current_state   : state_t;
  signal ad_next_state      : state_t;
  signal ram0_current_state : state_t;
  signal ram0_next_state    : state_t;

  signal s_ram0_write_enable : std_logic;

begin
  count_ad_ce <= '1' when (s_ad_count_ad_ce = '1') or (s_ram0_count_ad_ce = '1') else
                 '0';
  count_ad_sclr <= '1' when (s_ad_count_ad_sclr = '1') or (s_ram0_count_ad_sclr = '1') else
                   '0';
  
  ad_counter: counter PORT MAP (
    clk  => sys_clk,
    ce   => count_ad_ce,
    sclr => count_ad_sclr,
    q    => count_ad_q
    );

  ad_clk_proc: process(sys_clk, m_reset)
  begin
    if(m_reset = '1') then
      ad_current_state <= st_idle;
    elsif (rising_edge(sys_clk)) then
      ad_current_state <= ad_next_state;
    end if;
  end process;
  
  ad_proc: process(sys_clk)
  begin 
    ad_ram_addra <= count_ad_q; 

    case ad_current_state is
      when st_idle =>
        ad_ram_ena          <= '0';
        ad_ram_wea          <= "0";
        s_ad_count_ad_ce    <= '0';
        s_ad_count_ad_sclr  <= '0';
        s_ram0_write_enable <= '0';

        if(ctrl_ad_mode = '1') then
          ad_next_state <= st_clear;
        else
          ad_next_state <= st_idle;
        end if;

      when st_clear =>
        s_ad_count_ad_sclr <= '1';

        ad_next_state <= st_write;

      when st_write =>
        ad_ram_ena         <= '1';
        ad_ram_wea         <= "1";
        s_ad_count_ad_sclr <= '0';
        s_ad_count_ad_ce   <= '1';

        if(unsigned(count_ad_q) >= unsigned(count_data_q)) then
          ad_next_state <= st_wait;
        else
          ad_next_state <= st_write;
        end if;

      when st_wait =>
        ad_ram_ena          <= '0';
        ad_ram_wea          <= "0";
        s_ad_count_ad_ce    <= '0';
        s_ram0_write_enable <= '1';

        ad_next_state <= st_idle;

      when others =>
        ad_next_state <= st_idle;

    end case;
  end process;

  ram0_clk_proc: process(s_clk)
  begin
    if(m_reset = '1') then
      ram0_current_state <= st_idle;
    elsif (rising_edge(s_clk)) then
      ram0_current_state <= ram0_next_state;
    end if;
  end process;
  
  ram0_proc: process(s_clk)
  begin
    ad_ram_addrb <= count_ad_q; 

    case ram0_current_state is 
      when st_idle =>
        ad_ram_enb           <= '0';
        count_ram0_ce        <= '0';
        count_ram0_sclr      <= '0';
        s_ram0_count_ad_ce   <= '0';
        s_ram0_count_ad_sclr <= '0';
        count_ram0_sclr      <= '0';
        ram0_ena             <= '0';
        ram0_wea             <= "0";
        mux_ram0_sel         <= '0';

        if(s_ram0_write_enable = '1') then
          ram0_next_state <= st_clear;
        else
          ram0_next_state <= st_idle;
        end if;

      when st_clear =>
        count_ram0_sclr      <= '1';
        s_ram0_count_ad_sclr <= '1';

        ram0_next_state <= st_write;

      when st_outputlag =>
        ad_ram_enb      <= '1';
        count_ram0_ce   <= '1';

        ram0_next_state      <= st_write;

      when st_write =>
        ad_ram_enb           <= '1';
        s_ram0_count_ad_ce   <= '1';
        s_ram0_count_ad_sclr <= '0';
        count_ram0_ce        <= '1';
        count_ram0_sclr      <= '0';
        ram0_ena             <= '1';
        ram0_wea             <= "1";
        mux_ram0_sel         <= '1';

        if(unsigned(count_ram0_q) >= unsigned(count_data_q)) then
          ram0_next_state <= st_writelag;
        else
          ram0_next_state <= st_write;
        end if;

      when st_writelag =>
        ad_ram_enb         <= '0';
        count_ram0_ce      <= '0';
        count_ram0_sclr    <= '0';
        s_ram0_count_ad_ce <= '1';
        ram0_ena           <= '1';
        ram0_wea           <= "1";
        mux_ram0_sel       <= '1';

        ram0_next_state <= st_idle;

      when others =>
        ram0_next_state <= st_idle;

    end case;
  end process;
end Behavioral;

