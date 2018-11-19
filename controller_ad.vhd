
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
  
  signal count_ad2_ce   : std_logic;
  signal count_ad2_sclr : std_logic;
  signal count_ad2_q    : std_logic_vector(10 downto 0);

  signal s_ad_count_ad_ce     : std_logic;
  
  signal ad_current_state   : state_t;
  signal ad_next_state      : state_t;
  signal ram0_current_state : state_t;
  signal ram0_next_state    : state_t;

  signal s_ram0_write_enable : std_logic;

begin
  ad_counter: counter PORT MAP (
    clk  => sys_clk,
    ce   => count_ad_ce,
    sclr => count_ad_sclr,
    q    => count_ad_q
    );

  ad_counter2: counter PORT MAP (
    clk  => s_clk,
    ce   => count_ad2_ce,
    sclr => count_ad2_sclr,
    q    => count_ad2_q
    );

  count_ad_sclr <= '1' when(ad_current_state = st_clear) else
                   '0';

  ad_ram_ena <= '1' when(ad_current_state = st_write) else
                '0';

  ad_ram_wea <= "1" when(ad_current_state = st_write) else
                "0";
  
  count_ad_ce <= '1' when(ad_current_state = st_write) else
                 '0';

  s_ram0_write_enable <= '1' when(ad_current_state = st_wait) else
                         '0';

  count_ram0_sclr <= '1' when(ram0_current_state = st_clear) else
                     '0';

  count_ram0_ce <= '1' when(ram0_current_state = st_write) else
                   '0';

  count_ad2_sclr <= '1' when(ram0_current_state = st_clear) else
                    '0';

  count_ad2_ce <= '1' when(ram0_current_state = st_outputlag) else
                  '1' when(ram0_current_state = st_write) else
                  '0';

  ad_ram_enb <= '1' when(ram0_current_state = st_outputlag) else
                '1' when(ram0_current_state = st_write) else
                '0';

  ram0_ena <= '1' when(ram0_current_state = st_write) else
              '0';

  ram0_wea <= "1" when(ram0_current_state = st_write) else
              "0";

  mux_ram0_sel <= '1' when(ram0_current_state = st_write) else
                  '0';

  ad_clk_proc: process(sys_clk, m_reset)
  begin
    if(m_reset = '1') then
      ad_current_state <= st_idle;
    elsif (rising_edge(sys_clk)) then
      ad_current_state <= ad_next_state;
    end if;
  end process;
  
  ad_proc: process(sys_clk, count_ad_q, ad_current_state,
                   ctrl_ad_mode, count_data_q)
  begin 
    ad_ram_addra <= count_ad_q; 

    case ad_current_state is
      when st_idle =>
        if(ctrl_ad_mode = '1') then
          ad_next_state <= st_clear;
        else
          ad_next_state <= st_idle;
        end if;

      when st_clear =>
        ad_next_state <= st_write;

      when st_write =>
        if(unsigned(count_ad_q) >= unsigned(count_data_q)) then
          ad_next_state <= st_wait;
        else
          ad_next_state <= st_write;
        end if;

      when st_wait =>
        ad_next_state <= st_idle;

      when others =>
        ad_next_state <= st_idle;

    end case;
  end process;

  ram0_clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      ram0_current_state <= st_idle;
    elsif (rising_edge(s_clk)) then
      ram0_current_state <= ram0_next_state;
    end if;
  end process;
  
  ram0_proc: process(s_clk, count_ad2_q, ram0_current_state,
                     s_ram0_write_enable, count_ram0_q, count_data_q)
  begin
    ad_ram_addrb <= count_ad2_q; 

    case ram0_current_state is 
      when st_idle =>
        if(s_ram0_write_enable = '1') then
          ram0_next_state <= st_clear;
        else
          ram0_next_state <= st_idle;
        end if;

      when st_clear =>
        ram0_next_state <= st_outputlag;

      when st_outputlag =>
        ram0_next_state <= st_write;

      when st_write =>
        if(unsigned(count_ram0_q) >= unsigned(count_data_q)) then
          ram0_next_state <= st_idle;
        else
          ram0_next_state <= st_write;
        end if;

      when others =>
        ram0_next_state <= st_idle;

    end case;
  end process;
end Behavioral;

