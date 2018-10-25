library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bctrl is
 port(
 	Z : in std_logic;
 	C : in std_logic;
 	N : in std_logic;
 	V : in std_logic;
 	ins : in std_logic_vector(3 downto 0);
 	clk : in std_logic;
 	p1 : out std_logic
 );
 end entity;

 architecture bc of bctrl is
signal EQ : std_logic_vector(3 downto 0) := "0000";
signal NE : std_logic_vector(3 downto 0) := "0001";
signal HS_CS : std_logic_vector(3 downto 0) := "0010";
signal LO_CC : std_logic_vector(3 downto 0) := "0011";
signal MI : std_logic_vector(3 downto 0) := "0100";
signal PL : std_logic_vector(3 downto 0) := "0101";
signal VS : std_logic_vector(3 downto 0) := "0110";
signal VC : std_logic_vector(3 downto 0) := "0111";
signal HI : std_logic_vector(3 downto 0) := "1000";
signal LS : std_logic_vector(3 downto 0) := "1001";
signal GE : std_logic_vector(3 downto 0) := "1010";
signal LT : std_logic_vector(3 downto 0) := "1011";
signal GT : std_logic_vector(3 downto 0) := "1100";
signal LE : std_logic_vector(3 downto 0) := "1101";
signal AL : std_logic_vector(3 downto 0) := "1110";
signal p : std_logic := '0';



 begin 

process(clk)
begin
if ins = EQ then 
	if Z = '1' then p <= '1';  else p <= '0'; end if; end if;
if ins = NE then 
	if Z = '0' then p <= '1'; else p <= '0'; end if; end if;	
if ins = HS_CS then 
	if C = '1' then p <= '1'; else p <= '0'; end if; end if;
if ins = LO_CC then 
	if C = '0' then p <= '1'; else p <= '0'; end if; end if;
if ins = MI then 
	if N = '1' then p <= '1'; else p <= '0'; end if; end if;
if ins = PL then 
	if N = '0' then p <= '1'; else p <= '0'; end if; end if;
if ins = VS then 
	if V = '1' then p <= '1'; else p <= '0'; end if; end if;
if ins = VC then 
	if V = '0' then p <= '1'; else p <= '0'; end if; end if;
if ins = HI then 
	if (not(Z) and C) = '1' then p <= '1'; else p <= '0'; end if; end if;
if ins = LS then 
	if (not(Z) and C) = '0' then p <= '1'; else p <= '0'; end if; end if;
if ins = GE then 
	if (N xor V) = '1' then p <= '1'; else p <= '0'; end if; end if;
if ins = LT then 
	if (N xor V) = '0' then p <= '1'; else p <= '0'; end if; end if;
if ins = GT then 
	if (not(Z) and (N xor V)) = '1' then p <= '1'; else p <= '0'; end if; end if;
if ins = LE then 
	if (not(Z) and (N xor V)) = '0' then p <= '1'; else p <= '0'; end if; end if;
end process;
	
	p1 <= p;

 end architecture;