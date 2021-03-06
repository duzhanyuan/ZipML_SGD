library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fixed_vector_subtract is
generic (VECTOR_SIZE : integer := 16);
port (
	clk : in std_logic;
	trigger : in std_logic;
	vector1 : in std_logic_vector(32*VECTOR_SIZE-1 downto 0);
	vector2 : in std_logic_vector(32*VECTOR_SIZE-1 downto 0);
	result_almost_valid : out std_logic;
	result_valid : out std_logic;
	result : out std_logic_vector(32*VECTOR_SIZE-1 downto 0));
end fixed_vector_subtract;

architecture behavioral of fixed_vector_subtract is

begin

GenFIXED_SUB: for k in 0 to VECTOR_SIZE-1 generate
	result(k*32+31 downto k*32) <= std_logic_vector( signed(vector1(k*32+31 downto k*32)) - signed(vector2(k*32+31 downto k*32)) );
end generate GenFIXED_SUB;

result_almost_valid <= trigger;
result_valid <= trigger;

end architecture;