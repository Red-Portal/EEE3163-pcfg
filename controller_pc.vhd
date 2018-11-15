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
    Port ( clr : in  STD_LOGIC;
           sys_clk : in  STD_LOGIC;
           s_clk : in  STD_LOGIC;
			  
			  pc_ram_wr_addr : in  STD_LOGIC;
			  
--         mode_addr : in  STD_LOGIC;
           s_cmd_data : in  STD_LOGIC;
           s_wen : in  STD_LOGIC;
           s_ren : in  STD_LOGIC;
			  
           count_ram_ce : out  STD_LOGIC;
           count_ram_clr : out  STD_LOGIC;

           mux_ram_sel : out  STD_LOGIC;

           latch_in_en : out  STD_LOGIC;
           latch_out_en : out  STD_LOGIC;
           tri_en : out  STD_LOGIC; -- 1 tristate bufr is used at both pc0 and pc1. maybe outside NOR is needed?
			  
			  mux_out_sel : out  STD_LOGIC; -- 1 mux is used at both pc0 and pc1. maybe outside NOR is needed? 
			  
           ram_ena : out  STD_LOGIC;
           ram_wea : out  STD_LOGIC_VECTOR (0 downto 0);
           ram_enb : out  STD_LOGIC
);
end controller_pc;

architecture Behavioral of controller_pc is
 type state_t is (st_reset,
                   st_pc0_reset,
                   st_pc0_read,
                   st_pc0_wait,
                   st_pc1_reset,
                   st_pc1_read,
                   st_pc1_wait
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
  
begin




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
    count_ram_ce   		<= '0';
	 count_ram_clr     	<= '0';
    ram_ena        		<= '0';
    ram_wea          	<= "0";
    ram_enb          	<= '0';
    mux_ram_sel 			<= '0';
    latch_in_en  			<= '1';
    latch_out_en      	<= '0';
    tri_en        		<= '0';
    mux_out_sel         <= '0';

    case CS is
      when st_reset =>
			count_ram_ce   		<= '0';
			count_ram_clr     	<= '0';
			ram_ena        		<= '0';
			ram_wea          		<= "0";
			ram_enb          		<= '0';
			mux_ram_sel 			<= '0';
			latch_in_en  			<= '1';
			latch_out_en      	<= '0';
			tri_en        			<= '0';
			mux_out_sel          <= '0';

        if(pc_ram_wr_addr = '1') then
          NS <= st_ready;
        else
          NS <= st_reset;
        end if;

      when st_first =>
			count_ram_ce   		<= '0';
			count_ram_clr     	<= '1';
			ram_ena        		<= '0';
			ram_wea          		<= "0";
			ram_enb          		<= '0';
			mux_ram_sel 			<= '1';
			latch_in_en  			<= '1';
			latch_out_en      	<= '0';
			tri_en        			<= '0';
			mux_out_sel          <= '0';

        if(ad_ram0_addr = '1') then
          NS <= st_ready;
        else
          NS <= st_reset;
        end if;


      when others =>
        NS <= st_reset;
    end case;
  end process;




end Behavioral;

