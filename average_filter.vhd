library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity average_filter is
  Port (m_reset    : in  STD_LOGIC;
        s_clk      : in  STD_LOGIC;
        din        : in  STD_LOGIC_VECTOR (7 downto 0);
        ce         : in  STD_LOGIC;
        avg        : in  STD_LOGIC;
        done       : out std_logic;
        dout       : out std_logic_vector(7 downto 0));
end average_filter;
architecture Behavioral of average_filter is
  COMPONENT fdce11
    PORT(
      clock        : IN  std_logic;
      clock_enable : IN  std_logic;
      clear        : IN  std_logic;
      d            : IN  std_logic_vector(10 downto 0);
      q            : OUT std_logic_vector(10 downto 0)
      );
  END component;

  COMPONENT fdce8
    PORT(
      clock        : IN  std_logic;
      clock_enable : IN  std_logic;
      clear        : IN  std_logic;
      d            : IN  std_logic_vector(7 downto 0);
      q            : OUT std_logic_vector(7 downto 0)
      );
  END component;

  COMPONENT load_counter
    PORT(
      load : in std_logic;
      l    : in std_logic_vector(10 downto 0);
      clk  : IN  std_logic;
      ce   : IN  std_logic;
      sclr : IN  std_logic;
      q    : OUT std_logic_vector(10 downto 0)
      );
  END component;

  COMPONENT accumulator
    PORT(
      b    : IN  std_logic_vector(8 downto 0);
      clk  : IN  std_logic;
      add  : IN  std_logic;
      ce   : IN  std_logic;
      sclr : IN  std_logic;
      q    : OUT std_logic_vector(18 downto 0)
      );
  END COMPONENT;

  type state_t is (st_reset,
                   st_idle,
                   st_acc,
                   st_avg,
                   st_avg_clear,
                   st_zero,
                   st_write1,
                   st_write2,
                   st_write3
                   );

  signal reg_q   : std_logic_vector(10 downto 0);
  signal reg_clr : std_logic;
  signal reg_ce  : std_logic;
  signal reg_b   : std_logic_vector(10 downto 0);

  signal reg_out_q    : std_logic_vector(7 downto 0);
  signal reg_out_sclr : std_logic;
  signal reg_out_ce   : std_logic;

  signal count_load : std_logic;
  signal count_ce   : std_logic;
  signal count_sclr : std_logic;
  signal count_q    : std_logic_vector(10 downto 0);

  signal acc_add  : std_logic;
  signal acc_ce   : std_logic;
  signal acc_sclr : std_logic;
  signal acc_b    : std_logic_vector(8 downto 0);
  signal acc_q    : std_logic_vector(18 downto 0);

  signal s_done        : std_logic;

  signal current_state : state_t;
  signal next_state    : state_t;

begin
  count_reg: fdce11 port map(
    d            => reg_b,
    q            => reg_q,
    clock        => s_clk,
    clear        => reg_clr,
    clock_enable => reg_ce
    );

  out_reg: fdce8 port map(
    d            => count_q(7 downto 0),
    q            => reg_out_q,
    clock        => s_clk,
    clear        => reg_out_sclr,
    clock_enable => reg_out_ce
    );
  
  acc_reg: accumulator PORT MAP (
    clk  => s_clk,
    sclr => acc_sclr,
    b    => acc_b,
    add  => acc_add,
    ce   => acc_ce,
    q    => acc_q
    );

  data_counter: load_counter PORT MAP (
    l    => "00000000000",
    load => count_load,
    clk  => s_clk,
    sclr => count_sclr,
    ce   => count_ce,
    q    => count_q
    );

  reg_b <= count_q;

  acc_b <= std_logic_vector(resize(unsigned(din), 9))  when (current_state = st_acc) else
           std_logic_vector(resize(unsigned(reg_q), 9)) when (current_state = st_avg) else
           (others => '0');

  count_sclr <= '1' when (current_state = st_reset) else
                '1' when (current_state = st_avg_clear) else
                '0';

  reg_out_sclr <= '1' when (current_state = st_avg) else
                  '0';

  acc_sclr <= '1' when (current_state = st_reset) else
              '0';

  acc_add <= '0' when (current_state = st_avg) else
             '1';

  count_ce <= '1' when (current_state = st_acc) else
              '1' when (current_state = st_avg) else
              '0';

  count_load <= '1' when (current_state = st_reset) else
                '0';

  acc_ce <= '1' when (current_state = st_avg) else
            '1' when (current_state = st_acc) else
            '0';

  reg_ce <= '1' when (current_state = st_avg_clear) else
            '0';

  reg_clr <= '1' when (current_state = st_reset) else
             '0';

  reg_out_ce <= '1' when (current_state = st_write1) else
                '0';

  s_done <= '1' when (current_state = st_write2) else
            '0';

  dout <= reg_out_q;

  done <= s_done;

  clk_proc : process(s_clk, m_reset)
  begin
    if(m_reset = '1') then
      current_state <= st_reset;
    elsif(rising_edge(s_clk)) then
      current_state <= next_state;
    end if;
  end process;

  avg_proc: process(s_clk, ce, din, avg, count_q,
                    acc_q, current_state, reg_q)
  begin
    case current_state is
      when st_reset =>
        next_state <= st_idle;

      when st_idle =>
        if(ce = '1') then
          next_state <= st_acc;
        elsif(avg = '1') then
          next_state <= st_avg_clear;
        else
          next_state <= st_idle;
        end if;

      when st_acc =>
        if(avg = '1') then
          next_state <= st_avg_clear;
        elsif(ce = '1') then
          next_state <= st_acc;
        else
          next_state <= st_idle;
        end if;

      when st_avg_clear =>
        next_state <= st_avg;

      when st_avg =>
        if(unsigned(acc_q) < unsigned(reg_q)*2) then
          next_state <= st_write1;
        else
          next_state <= st_avg;
        end if;

      when st_write1 =>
        next_state <= st_write2;

      when st_write2 =>
        next_state <= st_reset;

      when others =>
        next_state <= st_reset;
        
    end case;
  end process;
end Behavioral;

