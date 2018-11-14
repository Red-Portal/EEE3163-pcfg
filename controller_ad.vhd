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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_ad is
  port (clr             : in  std_logic;
        sys_clk         : in  STD_LOGIC;
        s_clk           : in  STD_LOGIC;
        reg_ad_data     : in  STD_LOGIC_VECTOR (7 downto 0);
        ad_ram0_addr    : in  STD_LOGIC;
        count_ram0_ce   : out std_logic;
        count_ram0_sclr : out std_logic;
        mux_ram0_sel    : out STD_LOGIC;
        ad_ram_ena      : out STD_LOGIC;
        ad_ram_wea      : out STD_LOGIC_VECTOR (0 downto 0);
        ad_ram_enb      : out STD_LOGIC;
        ram0_ena        : out STD_LOGIC;
        ram0_wea        : out STD_LOGIC_VECTOR (0 downto 0);
        ad_latch_en     : out STD_LOGIC);
end controller_ad;

architecture Behavioral of controller_ad is
  type state_t is (st_reset,
                   st_ready,
                   st_sync0,
                   st_sync1,
                   st_clearwait0,
                   st_clearwait1,
                   st_delay0,
                   st_delay1,
                   st_read0,
                   st_read1
                   );

  signal CS, NS : state_t;
  
  COMPONENT counter
    PORT(
      clk  : IN  std_logic;
      ce   : IN  std_logic;
      sclr : IN  std_logic;
      q    : OUT std_logic_vector(10 downto 0)
      );
  END component;

  signal count_ad_ram_ce   : std_logic;
  signal count_ad_ram_sclr : std_logic;
  signal count_ad_ram_q    : std_logic_vector(10 downto 0);

begin
  -- Instantiate the Unit Under Test (UUT)
  uut: counter PORT MAP (
    clk  => s_clk,
    ce   => count_ad_ram_ce,
    sclr => count_ad_ram_sclr,
    q    => count_ad_ram_q
    );

  clk_proc: process(s_clk, clr)
  begin
    if(clr = '1') then
      CS <= st_reset;
    elsif (rising_edge(s_clk)) then
      CS <= NS;
    end if;
  end process;
  
  detect_proc: process(s_clk)
  begin
    count_ad_ram_ce   <= '0';
    count_ram0_ce     <= '0';
    count_ad_ram_sclr <= '0';
    count_ram0_sclr   <= '0';
    mux_ram0_sel      <= '0';
    ad_ram_ena        <= '0';
    ad_ram_wea        <= "0";
    ad_ram_enb        <= '0';
    ram0_ena          <= '0';
    ram0_wea          <= "0";
    ad_latch_en       <= '0';

    case CS is
      when st_reset =>
        count_ad_ram_sclr <= '1';
        count_ram0_sclr   <= '1';

        count_ad_ram_ce   <= '0';
        count_ram0_ce     <= '0';
        mux_ram0_sel      <= '0';
        ad_ram_ena        <= '0';
        ad_ram_wea        <= "0";
        ad_ram_enb        <= '0';
        ram0_ena          <= '0';
        ram0_wea          <= "0";
        ad_latch_en       <= '0';

        if(ad_ram0_addr = '1') then
          NS <= st_ready;
        else
          NS <= st_reset;
        end if;

      when st_ready =>
        count_ad_ram_sclr <= '1';
        count_ram0_sclr   <= '1';

        count_ad_ram_ce   <= '0';
        count_ram0_ce     <= '0';
        mux_ram0_sel      <= '0';
        ad_ram_ena        <= '0';
        ad_ram_wea        <= "0";
        ad_ram_enb        <= '0';
        ram0_ena          <= '0';
        ram0_wea          <= "0";
        ad_latch_en       <= '0';

        if(sys_clk = '0') then
          NS <= st_sync0;
        else
          NS <= st_ready;
        end if;

      when st_sync0 =>
        count_ad_ram_sclr <= '1';
        count_ram0_sclr   <= '1';

        count_ad_ram_ce   <= '0';
        count_ram0_ce     <= '0';
        mux_ram0_sel      <= '0';
        ad_ram_ena        <= '0';
        ad_ram_wea        <= "0";
        ad_ram_enb        <= '0';
        ram0_ena          <= '0';
        ram0_wea          <= "0";
        ad_latch_en       <= '0';

        if(sys_clk = '1') then
          NS <= st_sync1;
        else
          NS <= st_sync0;
        end if;

      when st_sync1 =>
        count_ad_ram_sclr <= '1';
        count_ram0_sclr   <= '1';
        ad_latch_en       <= '1';

        count_ad_ram_ce   <= '0';
        count_ram0_ce     <= '0';
        mux_ram0_sel      <= '0';
        ad_ram_ena        <= '0';
        ad_ram_wea        <= "0";
        ad_ram_enb        <= '0';
        ram0_ena          <= '0';
        ram0_wea          <= "0";

        if(sys_clk = '0') then
          NS <= st_clearwait0;
        else
          NS <= st_sync1;
        end if;

      when st_clearwait0 =>
        ad_latch_en       <= '1';

        count_ad_ram_sclr <= '0';
        count_ram0_sclr   <= '0';
        count_ad_ram_ce   <= '0';
        count_ram0_ce     <= '0';
        mux_ram0_sel      <= '0';
        ad_ram_ena        <= '0';
        ad_ram_wea        <= "0";
        ad_ram_enb        <= '0';
        ram0_ena          <= '0';
        ram0_wea          <= "0";

        if(sys_clk = '1') then
          NS <= st_clearwait1;
        else
          NS <= st_clearwait0;
        end if;

      when st_clearwait1 =>
        ad_ram_ena        <= '1';
        ad_ram_wea        <= "1";
        ad_latch_en       <= '1';

        count_ad_ram_ce   <= '0';
        count_ram0_ce     <= '0';
        count_ad_ram_sclr <= '0';
        count_ram0_sclr   <= '0';
        mux_ram0_sel      <= '0';
        ram0_ena          <= '0';
        ram0_wea          <= "0";

        if(sys_clk = '0') then
          NS <= st_delay0;
        else
          NS <= st_clearwait1;
        end if;

      when st_delay0 =>
        ad_ram_ena        <= '1';
        ad_ram_wea        <= "1";
        ad_latch_en       <= '1';
        ad_ram_enb        <= '1';

        count_ram0_ce     <= '0';
        ram0_ena          <= '0';
        ram0_wea          <= "0";
        mux_ram0_sel      <= '0';
        count_ad_ram_sclr <= '0';
        count_ram0_sclr   <= '0';

        if(sys_clk = '1') then
          NS <= st_delay1;
        else
          NS <= st_delay0;
        end if;

      when st_delay1 =>
        mux_ram0_sel      <= '1';
        ram0_ena          <= '1';
        ram0_wea          <= "1";
        count_ram0_ce     <= '1';
        ad_ram_ena        <= '1';
        ad_ram_wea        <= "1";
        ad_ram_enb        <= '1';
        ad_latch_en       <= '1';

        count_ad_ram_sclr <= '0';
        count_ram0_sclr   <= '0';

        if(count_ad_ram_q = reg_ad_data(7 downto 0)) then
          NS <= st_reset;
        else
          NS <= st_read0;
        end if;

      when st_read0 =>
        ad_latch_en       <= '1';
        ad_ram_ena        <= '1';
        ad_ram_wea        <= "1";
        ad_ram_enb        <= '1';
        
        ram0_ena          <= '0';
        ram0_wea          <= "0";
        count_ram0_ce     <= '0';
        mux_ram0_sel      <= '0';
        count_ad_ram_sclr <= '0';
        count_ram0_sclr   <= '0';

        if(sys_clk = '0') then
          NS <= st_read1;
        else
          NS <= st_read0;
        end if;

      when st_read1 =>
        ad_latch_en       <= '1';
        ad_ram_ena        <= '1';
        ad_ram_wea        <= "1";
        ad_ram_enb        <= '1';
        
        ram0_ena          <= '0';
        ram0_wea          <= "0";
        count_ram0_ce     <= '0';
        mux_ram0_sel      <= '0';
        count_ad_ram_sclr <= '0';
        count_ram0_sclr   <= '0';

        if(sys_clk = '1') then
          NS <= st_delay1;
        else
          NS <= st_read1;
        end if;

      when others =>
        NS <= st_reset;
    end case;
  end process;

end Behavioral;

