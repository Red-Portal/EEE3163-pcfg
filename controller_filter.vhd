----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:11:10 11/18/2018 
-- Design Name: 
-- Module Name:    controller_filter - Behavioral 
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

entity controller_filter is
    Port (m_reset         : in  STD_LOGIC;
          s_clk           : in  STD_LOGIC;
          ctrl_filter     : in  std_logic;
          data_count      : in  STD_LOGIC_VECTOR (10 downto 0);
          filter_ce       : out STD_LOGIC;
          filter_avg      : out STD_LOGIC;
          filter_reset    : out STD_LOGIC;
          ram0_enb        : out std_logic;
          count_ram0_ce   : out STD_LOGIC;
          count_ram0_sclr : out STD_LOGIC;
          count_ram0_q    : in  STD_LOGIC_VECTOR (10 downto 0)
          );
end controller_filter;
architecture Behavioral of controller_filter is
  type state_t is (st_idle, st_clear, st_outputlag,
                   st_write, st_compute, st_wait);

  signal current_state : state_t;
  signal next_state    : state_t;

begin
  clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      current_state <= st_idle;
    elsif (rising_edge(s_clk)) then
      current_state <= next_state;
    end if;
  end process;


  filter_proc: process(s_clk, current_state, ctrl_filter,
                       count_ram0_q, data_count)
  begin
    case current_state is
      when st_idle => 
        filter_ce <= '0';
        filter_avg <= '0';
        count_ram0_ce <= '0';
        count_ram0_sclr <= '0';

        if(ctrl_filter = '1') then
          next_state <= st_clear;
        else
          next_state <= st_idle;
        end if;

      when st_clear =>
        --filter_reset <= '1';
        count_ram0_sclr <= '1';
        next_state <= st_outputlag;

      when st_outputlag =>
        filter_reset    <= '0';
        count_ram0_sclr <= '0';
        count_ram0_ce   <= '1';
        ram0_enb        <= '1';
        filter_ce       <= '1';

        next_state <= st_write;

      when st_write =>
        filter_reset    <= '0';
        count_ram0_sclr <= '0';
        count_ram0_ce   <= '1';
        ram0_enb        <= '1';
        filter_ce       <= '1';

        if(unsigned(count_ram0_q) - 1 <= unsigned(data_count)) then
          next_state <= st_write;
        else
          next_state <= st_compute;
        end if;

      when st_compute =>
        filter_ce     <= '0';
        count_ram0_ce <= '0';
        filter_avg    <= '1';
        ram0_enb      <= '0';

        next_state <= st_wait;

      when st_wait =>
        filter_avg <= '0';

        if(ctrl_filter = '0') then
          next_state <= st_idle;
        else
          next_state <= st_wait;
        end if;
    end case;
  end process;

end Behavioral;

