library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity adder is
port(a,b:in std_logic_vector(31 downto 0);
     carry:in std_logic;
     carry_out:out std_logic_vector(1 downto 0);
     out_put:out std_logic_vector(31 downto 0));
end entity;

architecture beh of adder is
signal tmp1,tmp2:std_logic_vector(31 downto 0);
begin
tmp2(0)<=carry;
tmp1(0)<=a(0) xor b(0) xor tmp2(0);
sc:for i in 1 to 31 generate
      tmp2(i)<=(a(i-1) and b(i-1))or(a(i-1) and tmp2(i-1))or(b(i-1) and tmp2(i-1));
      tmp1(i)<=a(i) xor b(i) xor tmp2(i);
   end generate; 
carry_out(1)<=(a(31) and b(31))or(a(31) and tmp2(31))or(b(31) and tmp2(31));
carry_out(0)<=tmp2(31);
out_put<=tmp1;
end beh;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu is
port (op1,op2:in std_logic_vector(31 downto 0);
      operation:in std_logic_vector(3 downto 0);
      carry:in std_logic;
      flags:out std_logic_vector(3 downto 0);
      alu_res:out std_logic_vector(31 downto 0));
end alu;

architecture beh of alu is
signal a,b,c,d:std_logic;
signal tmp1,add_sig,tmp3,tmp4,tmp5,tmp6,tmp7:std_logic_vector(31 downto 0); 
signal tmpe1,tmpe3,tmpe:std_logic_vector(1 downto 0);         
begin
a <= ((not operation(3)) and  operation(1) and operation(0)) ;      --not op1
b <= ((not operation(0)) and operation(1)) ;                  --not op2
c <= (((not operation(0)) and  operation(1) and operation(3)) or ((not operation(3)) and (not operation(2)) and operation(1))) ;
adder1:entity work.adder(beh)
      port map(a=>op1,
               b=>op2,
               carry=>'0',
               carry_out=>tmpe1,                     --tmpe1=c31 and c32 when op1+op2
               out_put=>add_sig);                      --tmp2=op1+op2
with operation select                            --tmp7=outp dup
tmp7<=op1 and op2  when "0000",               --and
    op1 xor op2  when "0001",               --eor
    op1 and op2  when "1000",               --tst
    op1 xor op2  when "1001",               --teq
    op1 or  op2  when "1100",               --orr
    op2          when "1101",               --mov
    op1 and (not(op2)) when "1110",         --bic
    not(op2)     when "1111",               --mvn
    add_sig           when "0100",               --add
    add_sig           when "1011",               --cmn
    tmp4           when others;
    
    
with a select
tmp5<=not(op1) when '1',
    op1      when others;

with b select
tmp6<=not(op2) when '1',
    op2      when others;

with c select
d<='1'   when '1',
   carry when others;

adder2:entity work.adder(beh)
      port map(a=>tmp5,
               b=>tmp6,
               carry=>d,
               carry_out=>tmpe3,
               out_put=>tmp4);

with operation select
tmpe<=tmpe1 when "0100",
    tmpe1 when "1011",
    tmpe3 when others;

alu_res<=tmp7;
--flags are Z,N,V,C
with tmp7 select
flags(0)<='1' when "00000000000000000000000000000000",
          '0' when others;

flags(1)<=tmp7(31);

flags(2)<=tmpe(1) xor tmpe(0);

flags(3)<=tmpe(1);


end architecture;



