library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity float_vector_mult is
generic (VECTOR_SIZE : integer := 16);
port (
	clk : in std_logic;
	trigger : in std_logic;
	vector1 : in std_logic_vector(32*VECTOR_SIZE-1 downto 0);
	vector2 : in std_logic_vector(32*VECTOR_SIZE-1 downto 0);
	result_almost_valid : out std_logic;
	result_valid : out std_logic;
	result : out std_logic_vector(32*VECTOR_SIZE-1 downto 0));
end float_vector_mult;

architecture behavioral of float_vector_mult is

type result_type is array (VECTOR_SIZE-1 downto 0) of std_logic_vector(31 downto 0);
signal internal_result : result_type;

signal internal_trigger : std_logic_vector(4 downto 0);

component my_float_mult
	PORT
	(
		clock		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

begin

Genfloat_MULT: for k in 0 to VECTOR_SIZE-1 generate
	my_float_mult_inst : my_float_mult PORT MAP (
		clock	 => clk,
		dataa	 => vector1(k*32+31 downto k*32),
		datab	 => vector2(k*32+31 downto k*32),
		result	 => internal_result(k));

	result(k*32+31 downto k*32) <= internal_result(k);
end generate Genfloat_MULT;

result_almost_valid <= internal_trigger(1);
result_valid <= internal_trigger(4);

process(clk)
begin
if clk'event and clk = '1' then
	internal_trigger(0) <= trigger;
	for k in 1 to 4 loop
		internal_trigger(k) <= internal_trigger(k-1);
	end loop;
end if;
end process;

end architecture;