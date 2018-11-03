----------------------------------------------------------------------------------
-- Company:    SPS & CMSR
-- Engineer:   Jang, Jintae
-- Updated by:   Jang, Jintae
-- Modify :			 
-- Create Date:    2018
-- Design Name:    Modelling behavior of 8254
-- Module Name:    TOP_8254 - Behavioral 
-- Project Name:   PCFG
-- Target Devices: Spartan 3E
-- Tool versions:  ISE 10.1
-- Description:    This code supports only Mode2 and Mode3. No read operations are available.
--                 Supports all kinds of writing operation - LSB write only, MSB write only, LSB and MSB write 
-- Dependencies:   Read 8254 data sheet to set modes and registers correctly.
--
-- Revision: 
-- Revision 0.01 - File Created in Beijing, China. (UFFC)
--          0.02 - Debugged : Odd number counter part modified(Mode3)
--          0.03 - Debugged : Modified to operate correctly when there are command signals on input ports during more than 1 clock.
--          1.00 - File Released
--          1.01 - Write signals and chip select signals are tied to be drived together.
-- Additional Comments: This 8254 code is not optimized. You may try to optimize this code with your coding skills. Good luck.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TOP_8254 is
    Port ( m_clk0    : in  STD_LOGIC;
           m_clk1    : in  STD_LOGIC;
           m_clk2    : in  STD_LOGIC;
           m_clk_ctr : in  STD_LOGIC;
           m_reset   : in STD_LOGIC;
           m_data    : in  STD_LOGIC_VECTOR (7 downto 0);
           m_gate0   : in  STD_LOGIC;
           m_gate1   : in  STD_LOGIC;
           m_gate2   : in  STD_LOGIC;
           m_addr    : in  STD_LOGIC_VECTOR (1 downto 0);
           m_cs_b    : in  STD_LOGIC;
           m_wr_b    : in  STD_LOGIC;
           
			  
			  --test1 : out std_logic;
			  --test2 : out std_logic;
			  
		     m_out0    : out  STD_LOGIC;
           m_out1    : out  STD_LOGIC;
           m_out2    : out  STD_LOGIC);
end TOP_8254;

architecture Behavioral of TOP_8254 is
	
	signal s_data   : std_logic_vector(7 downto 0);
	signal s_cw0    : std_logic;	
	signal s_cw1    : std_logic;	
	signal s_cw2    : std_logic;	
	signal s_wr0_b  : std_logic;
	signal s_wr1_b  : std_logic;
   signal s_wr2_b  : std_logic;
	
	
	component TW_8254_CNT is
	port(  m_clk    : in  STD_LOGIC;
          m_reset  : in STD_LOGIC;
		    m_gate   : in  STD_LOGIC;
          m_out    : out  STD_LOGIC;
		    m_data   : in  STD_LOGIC_VECTOR (7 downto 0);
		    m_cw     : in std_logic;
          m_wr_b   : in  STD_LOGIC);
	end component;
	
	signal s_LSB_wr   : std_logic;
	signal s_MSB_wr   : std_logic;
	signal s_LM_wr    : std_logic;
	signal s_WR_WAIT  : std_logic;
	signal s_addr     : std_logic_vector(1 downto 0);
   signal s_wr_b     : std_logic;
    
    type state_type is (ready, latched, latched1, latched2, wait1, wait2);
    signal state : state_type;
	
	
begin
  
	process(m_clk_ctr)
		begin
			
			if rising_edge(m_clk_ctr) then
				if m_reset='1' then
			     s_addr <= "10";
			   
			     s_wr_b <= '1';
			     s_data  <= "00000000";
			     state <= ready;
				else
				  
			  case state is 
			   when ready=>	 
			    if m_wr_b='0' and m_cs_b='0'then
			     s_addr <= m_addr; 
			     
			     s_wr_b <= '1';  
			     state <= latched;
			    else 
			     state <= ready;
			     s_wr_b <= '1'; 
			    end if;
			    
			   when latched =>
			     s_wr_b <= '1';
			     state <= latched1;
			     s_data <= m_data;
				  
				when latched1 =>
				  state <= latched2;
			    
			   when   latched2=>
			     s_wr_b <= '0';
			     state <= wait1;
			    
			   when   wait1=>
			    if  ( m_wr_b='0' AND  m_cs_b='0') then
			     
			     s_wr_b <= '0';
			     state <= wait1;
			    
			    else
			     state <= wait2;
			     s_wr_b <= '1';
			    end if;
				 
				when wait2 =>
					s_wr_b <= '1';
					state <= ready;
					
			    end case;
				 end if;
			end if;
		end process;
	
	
	s_wr0_b <= '0' when (s_addr="11" and m_gate0='1' and s_wr_b='0' and  s_data(7 downto 6)="00") OR (s_addr="00" and m_gate0='1' and s_wr_b='0' ) else '1';
	s_wr1_b <= '0' when (s_addr="11" and m_gate1='1' and s_wr_b='0' and  s_data(7 downto 6)="01") OR (s_addr="01" and m_gate1='1' and s_wr_b='0' ) else '1';
	s_wr2_b <= '0' when (s_addr="11" and m_gate2='1' and s_wr_b='0' and  s_data(7 downto 6)="10") OR (s_addr="10" and m_gate2='1' and s_wr_b='0' ) else '1';
	
	---s_cw0   <= '1' when (s_addr="11" and m_gate0='1' and s_wr_b='0' and s_data(7 downto 6)="00") OR  (s_addr="11" and m_gate0='1' and s_data(7 downto 6)="00" and state = wait2) OR (s_addr="11" and m_gate0='1' and m_wr_b='0' and s_data(7 downto 6)="00") else '0';
	---s_cw1   <= '1' when (s_addr="11" and m_gate1='1' and s_wr_b='0' and s_data(7 downto 6)="01") OR  (s_addr="11" and m_gate1='1' and s_data(7 downto 6)="01" and state = wait2) OR (s_addr="11" and m_gate1='1' and m_wr_b='0' and s_data(7 downto 6)="01") else '0';
	---s_cw2   <= '1' when (s_addr="11" and m_gate2='1' and s_wr_b='0' and s_data(7 downto 6)="10") OR  (s_addr="11" and m_gate2='1' and s_data(7 downto 6)="10" and state = wait2) OR (s_addr="11" and m_gate2='1' and m_wr_b='0' and s_data(7 downto 6)="10") else '0';
	s_cw0 <= '1' when (s_addr="11" and m_gate0='1' and s_data(7 downto 6)="00" and (state = latched1 OR state = latched2 OR state = wait1 OR state = wait2)) else '0';
	s_cw1 <= '1' when (s_addr="11" and m_gate1='1' and s_data(7 downto 6)="01" and (state = latched1 OR state = latched2 OR state = wait1 OR state = wait2)) else '0';
	s_cw2 <= '1' when (s_addr="11" and m_gate2='1' and s_data(7 downto 6)="10" and (state = latched1 OR state = latched2 OR state = wait1 OR state = wait2)) else '0';
	
	---
	--test1 <= s_wr0_b;
	--test2 <= s_cw0;
	
   CNT0 : TW_8254_CNT
	port map (
	    m_clk   => m_clk0,
		m_reset => m_reset,
		m_gate  => m_gate0,
		m_out   => m_out0,
		m_data  => s_data,
		m_cw    => s_cw0,
	
		m_wr_b  => s_wr0_b
	);
   
   CNT1 : TW_8254_CNT
	port map (
	    m_clk   => m_clk1,
		m_reset => m_reset,
		m_gate  => m_gate1,
		m_out   => m_out1,
		m_data  => s_data,
		m_cw    => s_cw1, 

		m_wr_b  => s_wr1_b
	);
   
 CNT2 : TW_8254_CNT
	port map (
	    m_clk   => m_clk2,
		m_reset => m_reset,
		m_gate  => m_gate2,
		m_out   => m_out2,
		m_data  => s_data,
		m_cw    => s_cw2,
		
		m_wr_b  => s_wr2_b
	);
   
 

end Behavioral;

