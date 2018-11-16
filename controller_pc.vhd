----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:35:46 11/16/2018 
-- Design Name: 
-- Module Name:    controller_pc - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_pc is
  Port (s_clk           : in  STD_LOGIC;
        m_reset         : in  STD_LOGIC;
        ram_ena         : in  STD_LOGIC;
        ram_wea         : in  STD_LOGIC;
        ram_addra       : in  STD_LOGIC;
        ram_enb         : in  STD_LOGIC;
        ram_addrb       : in  STD_LOGIC;
        ctrl_pc_write   : in  STD_LOGIC;
        ctrl_pc_read    : in  STD_LOGIC;
        mux_ram_sel     : out std_logic;
        count_ram_ce    : out STD_LOGIC;
        count_data_ce : out STD_LOGIC);
end controller_pc;
architecture Behavioral of controller_pc is
  type state_t is (st_idle, st_cntw, st_r, st_w);

  signal current_state : std_logic;
  signal next_state    : std_logic;

begin 
  clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      current_state <= st_idle;
    elsif (rising_edge(s_clk)) then
      current_state <= next_state;
    end if;
  end process;
  
  pcfg_control_proc: process(s_clk)
  begin
    if(rising_edge(s_clk)) then
      case CS is
        when st_idle =>
          if(ctrl_pc_write or ctrl_pc_read) then
            next_state <= st_start;
          else
            next_state <= st_idle;
          end if;

        when st_cntw =>
          count_ram_ce  <= '1';
          count_data_ce <= '1';
          mux_ram_sel   <= '0';

          if(ctrl_pc_write = '1') then
            next_state <= st_r;
          elsif(ctrl_pc_read = '1') then
            next_state <= st_w;
          else
            next_state <= st_idle;
          end if;
          
        when st_r =>
          count_ram_ce  <= '0';
          count_data_ce <= '0';
          ram_enb       <= '1';
          ram_web       <= "1";
          mux_ram_sel   <= '1';
          
          if(ctrl_pc_read = '0') then
            NS <= st_idle;
          else
            NS <= st_r;
          end if;

        when st_w =>
          ram_enb     <= '1';
          ram_web     <= "1";
          mux_ram_sel <= "1";
          
          if(ctrl_pc_write = '0') then
            NS <= st_idle;
          else
            NS <= st_w;
          end if;

        when others =>
          NS <= st_idle;
      begin
      end if;
    end 
    end Behavioral;

