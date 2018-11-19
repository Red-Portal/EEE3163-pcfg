library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_dt is
  Port (s_clk         : in  STD_LOGIC;
        m_reset       : in  STD_LOGIC;
        s_wen         : in  std_logic;
        ctrl_startio  : in  STD_LOGIC;
        ram_ena       : out STD_LOGIC;
        ram_wea       : out std_logic_vector(0 downto 0);
        ram_enb       : out STD_LOGIC;
        mux_ram_sel   : out std_logic;
        count_ram_ce  : out STD_LOGIC);
--        count_data_ce : out STD_LOGIC);
  
end controller_dt;

architecture Behavioral of controller_dt is
  type state_t is (st_idle,
                   st_ready,
                   st_dt,
                   st_wait,
                   st_cntdt);

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

--p,s count_ram_ce : ram0 and ram1 have to share single ce
--p,s count_ram_clr : maybe ctrled at above level 'ctrl sig gen'? 
--						 no count_ram_clr at ctrlr_pc either...
--p,s ram_ena : of ram1
--p,s ram_wea : of ram1 
--p,s ram_enb : of ram0
--p,s mux_ram_sel : of mux_ram1, sig id Din1(= "01")

  pcfg_control_proc: process(s_clk, ctrl_startio, s_wen)
  begin
    case current_state is
      when st_idle =>
        count_ram_ce  <= '0';
--        count_data_ce <= '0';
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
--        count_ram_ce  <= '0';
--        count_data_ce <= '0';
        ram_ena       <= '0';
        ram_wea       <= "0";
        ram_enb       <= '1';
        
        mux_ram_sel   <= '0';

        if(s_wen = '1') then
          next_state <= st_dt;
        else
          next_state <= st_ready;
        end if;
        
      when st_dt =>
        ram_ena       <= '1';
        ram_wea       <= "1";
        ram_enb       <= '1';
        
        mux_ram_sel   <= '1';
-- have to wr only 1 cycle controller_pc 
        next_state <= st_wait;

      when st_wait =>
        ram_ena       <= '0';
        ram_wea       <= "0";
        ram_enb       <= '0';
        
        mux_ram_sel   <= '0';

        if(s_wen = '1') then
          next_state <= st_wait;
        else
          next_state <= st_cntdt;
        end if;

      when st_cntdt =>
        count_ram_ce  <= '1';
--		  count_data_ce <= '1';
        ram_ena       <= '0';
        ram_enb       <= '0';		  
        ram_wea       <= "0";
        mux_ram_sel   <= '0';
-- have to cnt only 1 cycle controller_pc 
        next_state   <= st_idle;

      when others =>
        next_state <= st_idle;
    end case;
  end process;
end Behavioral;
