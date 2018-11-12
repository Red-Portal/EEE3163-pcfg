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
    Port ( sys_clk : in  STD_LOGIC;
           s_clk : in  STD_LOGIC;
           mux_ram0_sel : out  STD_LOGIC;
           ad_ram_ena : out  STD_LOGIC;
           ad_ram_wea : out  STD_LOGIC_VECTOR (0 downto 0);
           ad_ram_enb : out  STD_LOGIC;
           ram0_ena : out  STD_LOGIC;
           ram0_wea : out  STD_LOGIC_VECTOR (0 downto 0);
           reg_ad_data : in  STD_LOGIC_VECTOR (7 downto 0);
           ad_ram0_addr : in  STD_LOGIC;
           ad_latch_en : out  STD_LOGIC);
end controller_ad;

architecture Behavioral of controller_ad is

begin


end Behavioral;

