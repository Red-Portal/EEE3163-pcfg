library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TW_8254_CNT is
    Port ( m_clk : in  STD_LOGIC;
           m_reset : in STD_LOGIC;
		   m_gate : in  STD_LOGIC;
           m_out : out  STD_LOGIC;
		   m_data : in  STD_LOGIC_VECTOR (7 downto 0);
		   m_cw : in std_logic;
           m_wr_b : in  STD_LOGIC);
end TW_8254_CNT;

architecture Behavioral of TW_8254_CNT is
    signal s_cw : std_logic;
	signal s_wr : std_logic;
	signal s_out2 : std_logic;
	signal s_out3 : std_logic;
    signal s_gate : std_logic;
	signal s_wr_M : std_logic;
	signal s_wr_L : std_logic;
	signal s_wr_LM : std_logic;
	signal s_wr_wait : std_logic;
	signal s_mode : std_logic;   -- 0 : mode2, 1 : mode3
	signal s_REG : std_logic_vector(15 downto 0);
	signal s_CNT2 : std_logic_vector(15 downto 0);
	signal s_CNT3_1 : std_logic_vector(15 downto 0);
	signal s_CNT3_2 : std_logic_vector(15 downto 0);
		
	signal s_CNT3_1_rst	: STD_LOGIC_VECTOR(15 downto 0);
	signal s_CNT3_2_rst	: STD_LOGIC_VECTOR(15 downto 0);
		
		
	signal s_even : std_logic;
    signal s_CNT3 : std_logic_vector(15 downto 0);
	signal s_CNT3_U : std_logic_vector(14 downto 0);
	signal s_CNT3_D : std_logic_vector(14 downto 0);  	
	signal s_CNT3_UD : std_logic; 
	signal s_temp1 : std_logic;
	signal s_temp2 : std_logic;
	
	constant c_0 : std_logic_vector(15 downto 0):=(others=>'0');
	constant c_1 : std_logic_vector(15 downto 0):=(0=>'1',others=>'0');
	constant c_1_2 : std_logic_vector(14 downto 0) :=(0=>'1',others=>'0');
	constant c_0_2 : std_logic_vector(14 downto 0) :=(others=>'0');
	
begin
    
	-- 2018 sign
	-- signal / port
	s_gate <= m_gate; 
    s_cw <= m_cw;
	m_out <= s_out2 when s_mode='0' and s_gate='1' else 
	         s_out3 when s_mode='1' and s_gate='1' else '1';		
    s_wr <= not m_wr_b;

    -- control LSB, MSB reg ( not for control word )
    process(s_wr,m_reset)
	begin
	 if m_reset='1' then
		 s_REG(15 downto 8) <= (8=>'1',others=>'0');
		 s_REG(7 downto 0) <= conv_std_logic_vector(4,8);
		 s_wr_wait <= '0';   
	 elsif rising_edge(s_wr) then
	    if s_cw='0' then
		 s_wr_wait <='0';
          if s_wr_L='1' and s_wr_LM='0' then 
		    s_REG(7 downto 0) <= m_data; 
		  elsif s_wr_M='1' and s_wr_LM='0' then 
		    s_REG(15 downto 8) <= m_data; 
		  elsif s_wr_LM='1' and s_wr_wait='0' then
		    s_REG(7 downto 0) <= m_data; 
		    s_wr_wait<='1';
		  elsif s_wr_LM='1' and s_wr_wait='1' then
		    s_REG(15 downto 8) <= m_data; 
		  end if;
	   end if;
	 end if;
	end process;
	
	-- control mode and write command
	process(m_reset,s_wr)
	begin
	   if m_reset='1' then
	        s_mode <= '0';  -- default mode : rate gen.
			s_wr_L <='0';
			s_wr_M <='0';
	   elsif rising_edge(s_wr) then		
	       if s_cw='1' then
		     s_mode <= m_data(1);
			  s_wr_L <= m_data(4);
			  s_wr_M <= m_data(5);
		   end if;
	   end if;
	end process;
	s_wr_LM <= '1' when s_wr_L='1' and s_wr_M='1' else '0';
	
   -----------------------------------------------------------------------------
   -- MODE 2
   process(m_reset,m_clk)
   begin
     if m_reset='1' then
		  s_CNT2 <= "0000000100000100";
	  elsif falling_edge(m_clk) then
	   if s_gate = '1' and s_mode='0' then
	     s_CNT2 <= s_CNT2 - '1' ;	 
		    if s_CNT2=c_1 then
               s_CNT2<=s_REG;
          end if;
		end if;	 
	  end if;
	end process;
	
	s_out2  <= '0' when s_CNT2=c_1 OR (s_mode='0' and (s_REG=c_1 OR s_REG=c_0)) else '1';	
	
   ------------------------------------------------------------------------------
   -- MODE 3
	
	s_CNT3_1 <= s_REG + '1';
	s_CNT3_2 <= s_REG - '1';
	
	s_CNT3_1_rst	<= x"0105";
	s_CNT3_2_rst	<= x"0103";
	
	s_even   <= s_REG(0);  -- 1 : odd, 0 : even
   process(m_reset,m_clk)
   begin
		-- 2018 sign
	  if falling_edge(m_clk) then
	  
	  if m_reset='1' then
        s_CNT3 <= x"0104";--s_REG;
		  s_CNT3_UD <= '1';
		  if s_even='1' then
		    s_CNT3_U <= s_CNT3_1_rst(15 downto 1);
	        s_CNT3_D <= s_CNT3_2_rst(15 downto 1); 
		  else
		    s_CNT3_U <= ("000"&x"082");--s_REG(15 downto 1);
	        s_CNT3_D <= ("000"&x"082");--s_REG(15 downto 1);
		  end if;
	   elsif s_gate='1' and s_even='1' and s_mode='1' then   -- odd
			 s_CNT3_D <= s_CNT3_D - 1;
			 s_CNT3_UD <='0';
			 if s_CNT3_D = c_1_2 and s_CNT3_U = c_0_2 then
			     s_CNT3_U <= s_CNT3_1(15 downto 1);
	             s_CNT3_D <= s_CNT3_2(15 downto 1);
			 elsif s_CNT3_D = c_1_2 then
			     s_CNT3_U <= s_CNT3_U - 1;
				 s_CNT3_D <= c_1_2(14 downto 0);
				 s_CNT3_UD <='1';
			 end if;
		  elsif s_gate='1' and s_even='0' and s_mode='1'  then  -- even
             s_CNT3_D <= s_CNT3_D - 1;
			 s_CNT3_UD <='0';
			 if s_CNT3_U = c_0_2 then   
			     s_CNT3_U <= s_REG(15 downto 1);
	             s_CNT3_D <= s_REG(15 downto 1);
			 elsif s_CNT3_D = c_1_2 then
			     s_CNT3_U <= s_CNT3_U - 1;
				 s_CNT3_D <= c_1_2;
				 s_CNT3_UD <='1';
			 end if;
		  end if;
	  end if;
	end process;
	
	s_out3 <= m_clk when ((s_REG=c_1 OR s_REG=c_0) and s_mode='1') else s_CNT3_UD;

end Behavioral;
