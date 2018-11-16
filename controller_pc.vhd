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
        count_ram_sclr  : out STD_LOGIC;
        counter_data_ce : out STD_LOGIC);
end controller_pc;
architecture Behavioral of controller_pc is
  type state_t is (st_idle, st_cntw, st_r, st_w);

  signal current_state : std_logic;
  signal next_state    : std_logic;

begin 
  clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      current_state <= st_reset;
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
          count_ram_ce <= '1';
          next_state <= st_rw;

          if(s_wen = '0') then
            NS <= st_cntw0;
          else
            NS <= st_w0;
          end if;
          
        when st_w0 =>
          ram0_ena <= '1';
          ram0_wea <= "1";
          latch_in_en <= '1';
          mux_ram0_sel <= '0';
          
          if(s_wen = '0') then
            NS <= st_cntw0;
          else
            NS <= st_w0;
          end if;


        when st_cntw0 =>
          count_ram0_ce <= '1';
          
          NS <= st_waitw0;


        when st_waitw0 =>

          if(s_wen = '1' ) then
            NS <= st_w0;
          elsif(s_ren = '1' OR pc_ram1_addr ='1') then
            NS <= st_idle;
          else
            NS <= st_waitw0;
          end if;


        when st_r0 =>
          ram0_enb <= '1';
          latch_out_en <= '1';
          mux_out_sel <= '0';
          
          if(s_ren = '0') then
            NS <= st_cntr0;
          else
            NS <= st_r0;
          end if;


        when st_cntr0 =>
          count_ram0_ce <= '1';
          
          NS <= st_waitr0;


        when st_waitr0 =>

          if(s_ren = '1') then
            NS <= st_r0;
          elsif(s_wen = '1' OR pc_ram1_addr ='1') then
            NS <= st_idle;
          else
            NS <= st_waitr0;
          end if;


        when st_clear1 =>
          count_ram1_clr <= '1';

          if(s_wen = '1') then
            NS <= st_w1;
          elsif(s_ren = '1') then
            NS <= st_r1;
          else
            NS <= st_clear1;
          end if;


        when st_w1 =>
          ram1_ena <= '1';
          ram1_wea <= "1";
          latch_in_en <= '1';
          mux_ram1_sel <= "10";
          
          if(s_wen = '0') then
            NS <= st_cntw1;
          else
            NS <= st_w1;
          end if;

        when st_cntw1 =>
          count_ram1_ce <= '1';
          
          NS <= st_waitw1;


        when st_waitw1 =>

          if(s_wen = '1') then
            NS <= st_w1;
          elsif(s_ren = '1' OR pc_ram0_addr ='1') then
            NS <= st_idle;
          else
            NS <= st_waitw1;
          end if;


        when st_r1=>
          ram1_enb <= '1';
          latch_out_en <= '1';
          mux_out_sel <= '1';
          
          if(s_ren = '0') then
            NS <= st_cntr1;
          else
            NS <= st_r1;
          end if;


        when st_cntr1 =>
          count_ram1_ce <= '1';
          
          NS <= st_waitr1;


        when st_waitr1 =>

          if(s_ren = '1') then
            NS <= st_r1;
          elsif(s_wen = '1' OR pc_ram0_addr ='1') then
            NS <= st_idle;
          else
            NS <= st_waitr1;
          end if;


        when others =>
          NS <= st_reset;
      begin
      end if;
    end 
    end Behavioral;

