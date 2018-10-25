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

architecture mc of main_controller is
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
-----------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bctrl is
 port(
    Z : in std_logic;
    N : in std_logic;
    V : in std_logic;
    C : in std_logic;
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
 ----------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Actrl is
port(
    ins : in std_logic_vector(6 downto 0);
    op : out std_logic_vector(3 downto 0)
    );
end entity;

architecture ac of Actrl is
begin

end architecture;





library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
port(ins:in std_logic_vector(31 downto 0);
     Z,C,N,V:in std_logic;
     Rsrc,MR,M2R,MW,Fset,Asrc,RW,Psrc:out std_logic;
     clk2 : in std_logic;
     op:out std_logic_vector(3 downto 0));
end entity;

architecture beh of controller is
signal p:std_logic;
begin
bc:entity work.Bctrl(bc)
   port map(Z=>Z,
            N=>N,
            V=>V,
            C=>C,
            ins=>ins(31 downto 28),
            clk2 => clk,
            p1=>p);

ac:entity work.Actrl(ac)
   port map(ins=>ins,
            op=>op);

mc:entity work.main_controller(mc)
   port map(ins=>ins(27 downto 20),
            p=>p,
            Rsrc=>Rsrc,
           Asrc=>Asrc,
           M2R=>M2R,
           RW=>RW,
           MW=>MW,
           MR=>MR,
           Psrc=>Psrc,
           Fset=>Fset
            );

end beh;