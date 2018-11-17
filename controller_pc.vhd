
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
                   st_wait,
                   st_cntr,
                   st_cntw);

  signal current_state : state_t;
  signal next_state    : state_t;

  signal s_debug_clk : std_logic;

begin 
  clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      current_state <= st_idle;
    elsif (rising_edge(s_clk)) then
      current_state <= next_state;
    end if;
  end process;

  debug_clk_proc: process
  begin
    s_debug_clk <= '0';
    wait for 2.5ns ;
    s_debug_clk <= '1';
    wait for 2.5ns;
  end process;
  
  pcfg_control_proc: process(s_clk, ctrl_startio, s_ren, s_wen)
  begin
    --if(rising_edge(s_clk)) then
    case current_state is
      when st_idle =>
        count_ram_ce  <= '0';
        count_data_ce <= '0';
        ram_ena       <= '0';
        ram_wea       <= "0";
        ram_enb       <= '0';
        mux_ram_sel   <= '0';

        if(ctrl_startio = '1') then
          next_state <= st_ready;
        else
          next_state <= st_idle;
        end if;

      when st_ready =>
        ram_enb       <= '1';
        count_ram_ce  <= '0';
        count_data_ce <= '0';

        if(s_ren = '1') then
          next_state <= st_r;
        elsif(s_wen = '1') then
          next_state <= st_w;
        else
          next_state <= st_ready;
        end if;
        
      when st_r =>
        ram_enb       <= '0';
        mux_ram_sel   <= '1';
        
        if(s_ren = '0') then
          next_state <= st_cntr;
        else
          next_state <= st_r;
        end if;

      when st_w =>
        ram_enb       <= '0';
        ram_ena       <= '1';
        ram_wea       <= "1";

        mux_ram_sel   <= '1';
        next_state <= st_wait;

      when st_wait =>
        ram_ena       <= '0';
        ram_wea       <= "0";
        mux_ram_sel   <= '0';

        if(s_ren = '1') then
          next_state <= st_wait;
        else
          next_state <= st_cntr;
        end if;

      when st_cntr =>
        count_ram_ce  <= '1';
        mux_ram_sel   <= '0';
        next_state   <= st_idle;

      when st_cntw =>
        count_ram_ce  <= '1';
        count_data_ce <= '1';
        mux_ram_sel   <= '0';
        next_state   <= st_idle;

      when others =>
        next_state <= st_idle;
    end case;
--    end if;
  end process;
end Behavioral;

