library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity multiplier is
port(op1,op2 : in std_logic_vector(31 downto 0);
	result   : out std_logic_vector(31 downto 0)
	);
end entity;

architecture cc of multiplier is
signal res : std_logic_vector(63 downto 0);
begin
res <= op1 * op2;
result(31 downto 0) <= res(31 downto 0);
end architecture;