----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:01:22 11/16/2018 
-- Design Name: 
-- Module Name:    control_signal_gen - Behavioral 
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

entity control_signal_gen is
  port (
    m_reset      : in  STD_LOGIC;
    s_reset_addr : in  STD_LOGIC;

    s_clk        : in  STD_LOGIC;
    sys_clk      : in  STD_LOGIC;
    mode_addr    : in  STD_LOGIC_VECTOR (2 downto 0);
    s_data       : in  STD_LOGIC_VECTOR (7 downto 0);
    s_wen        : in  STD_LOGIC;
    s_ren        : in  STD_LOGIC;

    ram0_ena     : out STD_LOGIC;
    ram0_wea     : out STD_LOGIC_VECTOR (0 downto 0);
    ram0_addra   : out STD_LOGIC_VECTOR (10 downto 0);
    ram0_dina    : out STD_LOGIC_VECTOR (7 downto 0);
    ram0_enb     : out STD_LOGIC;
    ram0_addrb   : out STD_LOGIC_VECTOR (10 downto 0);
    ram0_doutb   : out STD_LOGIC_VECTOR (7 downto 0);

    ram1_ena     : out STD_LOGIC;
    ram1_wea     : out STD_LOGIC_VECTOR (0 downto 0);
    ram1_addra   : out STD_LOGIC_VECTOR (10 downto 0);
    ram1_dina    : out STD_LOGIC_VECTOR (7 downto 0);
    ram1_enb     : out STD_LOGIC;
    ram1_addrb   : out STD_LOGIC_VECTOR (10 downto 0);
    ram1_outb    : out STD_LOGIC_VECTOR (7 downto 0);

    ad_ram_ena   : out STD_LOGIC;
    ad_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0);
    ad_ram_addra : out STD_LOGIC_VECTOR (10 downto 0);
    ad_ram_dina  : out STD_LOGIC_VECTOR (7 downto 0);
    ad_ram_enb   : out STD_LOGIC;
    ad_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0);
    ad_ram_doutb : out STD_LOGIC_VECTOR (7 downto 0);

    da_ram_ena   : out STD_LOGIC;
    da_ram_wea   : out STD_LOGIC_VECTOR (0 downto 0);
    da_ram_addra : out STD_LOGIC_VECTOR (10 downto 0);
    da_ram_dina  : out STD_LOGIC_VECTOR (7 downto 0);
    da_ram_enb   : out STD_LOGIC;
    da_ram_addrb : out STD_LOGIC_VECTOR (10 downto 0);
    da_ram_doutb : out STD_LOGIC_VECTOR (7 downto 0);

    mux_out_sel  : out STD_LOGIC;
    mux_ram0_sel : out STD_LOGIC;
    mux_ram1_sel : out STD_LOGIC_VECTOR (1 downto 0);

    s_dout_en    : out STD_LOGIC;
    m_led        : out STD_LOGIC_VECTOR (7 downto 0);
    m_TP         : out STD_LOGIC_VECTOR (1 downto 0)
    );
end control_signal_gen;
architecture Behavioral of control_signal_gen is
  COMPONENT fdce11
    PORT(
      clock        : IN  std_logic;
      clock_enable : IN  std_logic;
      clear        : IN  std_logic;
      d            : IN  std_logic_vector(10 downto 0);
      q            : OUT std_logic_vector(10 downto 0)
      );
  END component;

  constant mode_pc0      : std_logic_vector(2 downto 0) := "001";
  constant mode_pc1      : std_logic_vector(2 downto 0) := "010";
  constant mode_transfer : std_logic_vector(2 downto 0) := "011";
  constant mode_da_start : std_logic_vector(2 downto 0) := "100";
  constant mode_da_stop  : std_logic_vector(2 downto 0) := "101";
  constant mode_ad       : std_logic_vector(2 downto 0) := "110";
  constant mode_avg      : std_logic_vector(2 downto 0) := "111";
  
  signal reg_data_count_load  : std_logic;
  signal reg_data_count_clear : std_logic;
  signal reg_data_count_din   : std_logic_vector(10 downto 0);
  signal reg_data_count_dout  : std_logic_vector(10 downto 0);
begin

  data_count_reg: fdce11 PORT MAP (
    clock        => s_clk,
    clock_enable => reg_data_count_load,
    clear        => reg_data_count_clear or m_reset or s_reset_addr,
    d            => reg_data_count_din,
    q            => reg_data_count_dout
    );

  
end Behavioral;

