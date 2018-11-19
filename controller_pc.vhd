
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
        count_data_ce : out STD_LOGIC);
end controller_pc;

architecture Behavioral of controller_pc is
  type state_t is (st_idle,
                   st_ready,
                   st_r,
                   st_w,
                   st_waitw,
                   st_cntr,
                   st_cntw);

  signal current_state : state_t;
  signal next_state    : state_t;

  signal s_debug_clk : std_logic;
  
  
--  signal s_count_ram_ce : std_logic;
--  signal s_count_data_ce : std_logic;
--  signal s_ram_ena : std_logic;
--  signal s_ram_wea : std_logic_vector(0 downto 0);
--  signal s_ram_enb : std_logic;
--  signal s_mux_ram_sel : std_logic;

begin 
  count_ram_ce <= '1' when (current_state = st_cntr) else
						'1' when (current_state = st_cntw) else
						'0';
						
  count_data_ce <= '1' when (current_state = st_cntw) else
						 '0';
						 
  ram_ena <= '1' when (current_state = st_w) else
				 '0';
  
  ram_wea <= "1" when (current_state = st_w) else
				 "0";
  
  ram_enb <= '1' when (current_state = st_r) else
             '1' when (current_state = st_ready) else
				 '0';
  
  mux_ram_sel <= '1' when (current_state = st_r) else
					  '1' when (current_state = st_w) else
					  '0';
  
  clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      current_state <= st_idle;
    elsif (rising_edge(s_clk)) then
      current_state <= next_state;
    end if;
  end process;

  pcfg_control_proc: process(s_clk, s_debug_clk, ctrl_startio,
                             s_ren, s_wen, current_state)
  begin
    --if(rising_edge(s_clk)) then
    case current_state is
      when st_idle =>
        if(ctrl_startio = '1') then
          next_state <= st_ready;
        else
          next_state <= st_idle;
        end if;

      when st_ready =>
        if((s_ren = '1') AND (ctrl_startio = '1')) then
          next_state <= st_r;
        elsif((s_wen = '1') AND (ctrl_startio = '1')) then
          next_state <= st_w;
        else
          next_state <= st_ready;
        end if;
        
      when st_r =>
        if(s_ren = '0') then
          next_state <= st_cntr;
        else
          next_state <= st_r;
        end if;

      when st_w =>
        next_state <= st_waitw;

      when st_waitw =>
        if(s_wen = '1') then
          next_state <= st_waitw;
        else
          next_state <= st_cntw;
        end if;

      when st_cntr =>
        next_state   <= st_idle;

      when st_cntw =>
        next_state   <= st_idle;

      when others =>
        next_state <= st_idle;

    end case;
--    end if;
  end process;
end Behavioral;

