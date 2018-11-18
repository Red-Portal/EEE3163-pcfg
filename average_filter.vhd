----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:36:26 11/18/2018 
-- Design Name: 
-- Module Name:    average_filter - Behavioral 
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
                   st_write);

  signal reg_q   : std_logic_vector(10 downto 0);
  signal reg_clr : std_logic;
  signal reg_ce  : std_logic;
  signal reg_b   : std_logic_vector(10 downto 0);

  signal reg_out_q   : std_logic_vector(7 downto 0);
  signal reg_out_clr : std_logic;
  signal reg_out_ce  : std_logic;

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
    clear        => reg_out_clr,
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
    l    => "00000000001",
    load => count_load,
    clk  => s_clk,
    sclr => count_sclr,
    ce   => count_ce,
    q    => count_q
    );

  reg_b <= count_q;

  acc_b <= din                                          when (current_state = st_acc) else
           std_logic_vector(resize(unsigned(reg_q), 8)) when (current_state = st_avg) else
           (others => '0');

  dout <= reg_out_q when (s_done = '1') else
          (others => '0');

  done <= s_done;

  clk_proc : process(s_clk, m_reset)
  begin
                     if(m_reset = '1') then
      current_state <= st_reset;
    elsif(rising_edge(s_clk)) then
      current_state <= next_state;
    end if;
  end process;

  avg_proc: process(s_clk, ce, din, avg, count_q, acc_q)
  begin
    case current_state is
      when st_reset =>
        count_sclr  <= '1';
        reg_out_clr <= '1';
        acc_sclr    <= '1';
        acc_add     <= '1';
        count_ce    <= '0';
        reg_ce      <= '0';
        acc_ce      <= '0';
        reg_out_ce  <= '0';
        s_done      <= '0';
        reg_clr     <= '1';
        count_load  <= '1';

        next_state <= st_idle;

      when st_idle =>
        reg_out_clr <= '0';
        count_sclr  <= '0';
        count_ce    <= '0';
        acc_sclr    <= '0';
        acc_ce      <= '0';
        acc_add     <= '0';
        reg_ce      <= '0';
        reg_clr     <= '0';
        count_load  <= '0';

        if(ce = '1') then
          next_state <= st_acc;
        elsif(avg = '1') then
          next_state <= st_avg_clear;
        else
          next_state <= st_idle;
        end if;

      when st_acc =>
        count_ce <= '1';
        acc_ce   <= '1';
        acc_add  <= '1';

        if(avg = '1') then
          next_state <= st_avg_clear;
        elsif(ce = '1') then
          next_state <= st_acc;
        else
          next_state <= st_idle;
        end if;

      when st_avg_clear =>
        count_sclr <= '1';
        reg_ce     <= '1';

        next_state <= st_avg;

      when st_avg =>
        count_sclr <= '0';
        count_ce   <= '1';
        acc_ce     <= '1';
        acc_add    <= '0';
        reg_ce     <= '0';
        reg_ce     <= '0';
        reg_out_ce <= '1';

        if(unsigned(acc_q) <= unsigned(reg_q)) then
          next_state <= st_write;
        else
          next_state <= st_avg;
        end if;

      when st_write =>
        acc_sclr   <= '0';
        count_ce   <= '0';
        acc_ce     <= '0';
        reg_out_ce <= '0';
        s_done     <= '1';

        next_state <= st_write;

      when others =>
        next_state <= st_reset;
        
    end case;
  end process;
end Behavioral;

