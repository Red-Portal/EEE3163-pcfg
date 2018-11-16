----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:50:38 11/16/2018 
-- Design Name: 
-- Module Name:    controller_da - Behavioral 
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

entity controller_da is
    Port (s_clk                : in  STD_LOGIC;
           sys_clk             : in  STD_LOGIC;
           m_reset             : in  STD_LOGIC;
           da_ram_ena          : out STD_LOGIC;
           da_ram_wea          : out STD_LOGIC_VECTOR (0 downto 0);
           da_ram_addra        : out STD_LOGIC_VECTOR (10 downto 0);
           da_ram_enb          : out STD_LOGIC;
           da_ram_addrb        : out STD_LOGIC_VECTOR (10 downto 0);
           ram1_enb            : out STD_LOGIC;
           ram1_addrb          : out STD_LOGIC_VECTOR (10 downto 0);
           count_ram1_ce       : out STD_LOGIC;
           count_ram1_sclr     : out STD_LOGIC;
           count_ram1_q        : in  STD_LOGIC_VECTOR (10 downto 0);
           reg_data_count_dout : in  STD_LOGIC;
           ctrl_da_start       : in  STD_LOGIC;
           ctrl_da_stop        : in  STD_LOGIC
          );
end controller_da;
architecture Behavioral of controller_da is
begin
end Behavioral;

