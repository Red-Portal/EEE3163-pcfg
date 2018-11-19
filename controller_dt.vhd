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

  ram_ena <= '1' when (current_state = st_dt) else
				 '0';
	 
  ram_wea <= "1" when (current_state = st_dt) else
				 "0";
	 
  ram_enb <= '1' when (current_state = st_ready) else
				 '1' when (current_state = st_dt) else
				 '0';
	 
  mux_ram_sel <= '1' when (current_state = st_dt) else
					  '0';
	 
  count_ram_ce <= '1' when (current_state = st_cntdt) else
						'0';


  clk_proc: process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      current_state <= st_idle;
    elsif (rising_edge(s_clk)) then
      current_state <= next_state;
    end if;
  end process;

  pcfg_control_proc: process(s_clk, ctrl_startio, s_wen,
                             current_state)
  
  begin 
    case current_state is
      when st_idle =>
        if(ctrl_startio = '1') then
          next_state <= st_ready;
        else
          next_state <= st_idle;
        end if;

      when st_ready =>
        if(s_wen = '1') then
          next_state <= st_dt;
        else
          next_state <= st_ready;
        end if;
        
      when st_dt =>
        next_state <= st_wait;

      when st_wait =>
        if(s_wen = '1') then
          next_state <= st_wait;
        else
          next_state <= st_cntdt;
        end if;

      when st_cntdt =>
        next_state   <= st_idle;

      when others =>
        next_state <= st_idle;
    end case;
  end process;
end Behavioral;
