-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
  COMPONENT multiplexer_2to1
    PORT(
      sel : in  std_logic;
      in0 : in  std_logic_vector(7 downto 0);       
      in1 : in  std_logic_vector(7 downto 0);
      o   : out std_logic_vector(7 downto 0)
      );
  END COMPONENT;

  SIGNAL sel : std_logic := '0';
  SIGNAL in0 : std_logic_vector(7 downto 0) := (others => '0');
  SIGNAL in1 : std_logic_vector(7 downto 0) := (others => '0');
  SIGNAL o   : std_logic_vector(7 downto 0) := (others => '0');

BEGIN

  -- Component Instantiation
  uut: multiplexer_2to1 PORT MAP(
    sel => sel,
    in0 => in0,
    in1 => in1,
    o   => o
    );

  --  Test Bench Statements
  tb : PROCESS
  BEGIN

    wait for 100 ns; 
    sel <= '0';
    in0 <= x"01";
    in1 <= x"02";
    wait for 10 ns;
    sel <= '1';
    wait for 10 ns;
    wait; 
  END PROCESS tb;
END;
