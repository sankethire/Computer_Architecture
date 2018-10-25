library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_controller is
port(
	ins : in std_logic_vector(4 downto 0);
	p : in std_logic;
	Rsrc,Asrc,M2R,RW,MW,MR,Psrc,Fset : out std_logic
	);
end entity;

architecture ac of main_controller is
signal and1 : std_logic;
signal and2 : std_logic;
signal and3 : std_logic;
signal and4 : std_logic;
signal and5 : std_logic;
signal and6 : std_logic;
signal and7 : std_logic;
signal and8 : std_logic;

signal or1 : std_logic;
signal or2 : std_logic;
signal or3 : std_logic;

begin

and1 <= (not(ins(4)) and not(ins(3)) and not(ins(2)) and not(ins(0)));
and2 <= (not(ins(4)) and not(ins(3)) and not(ins(2)) and ins(0));
and3 <= (not(ins(4)) and not(ins(3)) and ins(1) and not(ins(0)));
and4 <= (not(ins(4)) and not(ins(3)) and ins(1) and ins(0)); 
and5 <= (not(ins(4)) and not(ins(3)) and ins(2) and not(ins(1)));
and6 <= (not(ins(4)) and ins(3) and not(ins(0)));
and7 <= (not(ins(4)) and ins(3) and ins(0));
and8 <= (ins(4) and not(ins(3)));

or1 <= and6 or and7;
or2 <= and1 or and2 or and3 or and4 or and7;
or3 <= and2 or and4 or and5;

Rsrc <= or1;
Asrc <= or1;
M2R <= or1;

RW <= or2 and p;

MW <= and6 and p;

MR <= and7;

Psrc <= and8 and p;

Fset <= or3 and p;

end architecture;