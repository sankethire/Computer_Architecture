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
-----------------------------------------------------
--Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
--Date        : Wed Mar 07 15:39:22 2018
--Host        : LAPTOP-I9OM1OOH running 64-bit major release  (build 9200)
--Command     : generate_target BRAM_wrapper.bd
--Design      : BRAM_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity BRAM_wrapper is
  port (
    BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_clk : in STD_LOGIC;
    BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_en : in STD_LOGIC;
    BRAM_PORTA_rst : in STD_LOGIC;
    BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end BRAM_wrapper;

architecture STRUCTURE of BRAM_wrapper is
  component BRAM is
  port (
    BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_clk : in STD_LOGIC;
    BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_en : in STD_LOGIC;
    BRAM_PORTA_rst : in STD_LOGIC;
    BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component BRAM;
begin
BRAM_i: component BRAM
     port map (
      BRAM_PORTA_addr(31 downto 0) => BRAM_PORTA_addr(31 downto 0),
      BRAM_PORTA_clk => BRAM_PORTA_clk,
      BRAM_PORTA_din(31 downto 0) => BRAM_PORTA_din(31 downto 0),
      BRAM_PORTA_dout(31 downto 0) => BRAM_PORTA_dout(31 downto 0),
      BRAM_PORTA_en => BRAM_PORTA_en,
      BRAM_PORTA_rst => BRAM_PORTA_rst,
      BRAM_PORTA_we(3 downto 0) => BRAM_PORTA_we(3 downto 0)
    );
end STRUCTURE;
--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.arm_reg_condition.all;--local vhdl file access

entity shifter is
port(shift_amount : in std_logic_vector(4 downto 0);--since maximum shifting is 32 
	 shift_type   : in std_logic_vector(1 downto 0);
	 data         : in std_logic_vector(31 downto 0);
	 shifted_data  : out std_logic_vector(31 downto 0);
	 shift_c      : out  std_logic   );
end entity;

architecture aa of shifter is
signal shiftIn : std_logic_vector(31 downto 0);
signal shift_amnt : std_logic_vector(4 downto 0);
signal d_out1,d_out2,d_out3,d_out4,d_out5 : std_logic_vector(31 downto 0);
signal c_out1,c_out2,c_out3,c_out4,c_out5 : std_logic;
signal c : std_logic := '0';
begin

shiftIn <= data;
shift_amnt <= shift_amount;
shift_by_1position : process(shiftIn,shift_amnt,shift_type)
begin
if shift_amnt(0) = '1'
then	
case shift_type is
when "00" =>		-- LSL #1
				d_out1 <= shiftIn(30 downto 0) & '0';
				c_out1 <= shiftIn(31);
when "01" =>		-- LSR #1
				d_out1 <= '0' & shiftIn(31 downto 1);
				c_out1 <= shiftIn(0);
when "10" =>		-- ASR #1
				d_out1 <= shiftIn(31) & shiftIn(31 downto 1);
				c_out1 <= shiftIn(0);
when others =>		-- ROR #1
				d_out1 <= shiftIn(0) & shiftIn(31 downto 1);
				c_out1 <= shiftIn(0);
end case;
else
			d_out1 <= shiftIn;
			c_out1 <= c;
end if;
end process;

shift_by_2positions : process(d_out1,c_out1,shift_amnt,shift_type)
begin
if shift_amnt(1) = '1'
then
case shift_type is
when "00" =>		-- LSL #2
				d_out2 <= d_out1(29 downto 0) & "00";
				c_out2 <= d_out1(30);
when "01" =>		-- LSR #2
				d_out2 <= "00" & d_out1(31 downto 2);
				c_out2 <= d_out1(1);
when "10" =>		-- ASR #2
				d_out2 <= (1 downto 0 => d_out1(31)) & d_out1(31 downto 2);
				c_out2 <= d_out1(1);
when others =>		-- ROR #2
				d_out2 <= d_out1(1 downto 0) & d_out1(31 downto 2);
				c_out2 <= d_out1(1);
end case;
else
			d_out2 <= d_out1;
			c_out2 <= c_out1;
end if;
end process;

shift_by_4positions : process(d_out2,c_out2,shift_amnt,shift_type)
begin
if shift_amnt(2) = '1'
then
case shift_type is
when "00" =>		-- LSL #4
				d_out3 <= d_out2(27 downto 0) & "0000";
				c_out3 <= d_out2(28);
when "01" =>		-- LSR #4
				d_out3 <= "0000" & d_out2(31 downto 4);
				c_out3 <= d_out2(3);
when "10" =>		-- ASR #4
				d_out3 <= (3 downto 0 => d_out2(31)) & d_out2(31 downto 4);
				c_out3 <= d_out2(3);
when others =>		-- ROR #4
				d_out3 <= d_out2(3 downto 0) & d_out2(31 downto 4);
				c_out3 <= d_out2(3);
end case;
else
			d_out3 <= d_out2;
			c_out3 <= c_out2;
end if;
end process;

shift_by_8positions : process(d_out3,c_out3,shift_amnt,shift_type)
begin
if shift_amnt(3) = '1'
then
case shift_type is
when "00" =>		-- LSL #8
				d_out4 <= d_out3(23 downto 0) & (7 downto 0 => '0');
				c_out4 <= d_out3(24);
when "01" =>		-- LSR #8
				d_out4 <= (7 downto 0 => '0') & d_out3(31 downto 8);
				c_out4 <= d_out3(7);
when "10" =>		-- ASR #8
				d_out4 <= (7 downto 0 => d_out3(31)) & d_out3(31 downto 8);
				c_out4 <= d_out3(7);
when others =>		-- ROR #8
				d_out4 <= d_out3(7 downto 0) & d_out3(31 downto 8);
				c_out4 <= d_out3(7);
end case;
else
			d_out4 <= d_out3;
			c_out4 <= c_out3;
end if;
end process;

shift_by_16positions : process(d_out4,c_out4,shift_amnt,shift_type)
begin
if shift_amnt(4) = '1'
then
case shift_type is
when "00" =>		-- LSL #16
				d_out5 <= d_out4(15 downto 0) & (15 downto 0 => '0');
				c_out5 <= d_out4(15);
when "01" =>		-- LSR #16
				d_out5 <= (15 downto 0 => '0') & d_out4(31 downto 16);
				c_out5 <= d_out4(15);
when "10" =>		-- ASR #16
				d_out5 <= (15 downto 0 => d_out4(31)) & d_out4(31 downto 16);
				c_out5 <= d_out4(15);
when others =>		-- ROR #16
				d_out5 <= d_out4(15 downto 0) & d_out4(31 downto 16);
				c_out5 <= d_out4(15);
end case;
else
			d_out5 <= d_out4;
			c_out5 <= c_out4;
end if;
end process;
shifted_data <= d_out5;
shift_c <= c_out5;

end architecture;
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity register_file is
    port(
        clk    : in std_logic;
        aa     : in  std_logic_vector( 3 downto 0);--read address
        ab     : in  std_logic_vector( 3 downto 0);--read address
		aw     : in  std_logic_vector( 3 downto 0);-- write address
        write_enable   : in  std_logic;
		wrdata : in  std_logic_vector(31 downto 0);
		reset : in std_logic;

        a      : out std_logic_vector(31 downto 0);
        b      : out std_logic_vector(31 downto 0);
        pc_out : out std_logic_vector(31 downto 0)
    );
end register_file;

architecture dinesh of register_file is
    type reg_type is array (0 to 15) of std_logic_vector(31 downto 0);
    signal reg_array : reg_type := (others=>(others=>'0'));
	signal aal, abl : std_logic_vector(3 downto 0);
	signal rd_clken :  std_logic := '1';
begin

process(clk) is
	variable aav, abv : std_logic_vector(3 downto 0);
begin
	


    if(rising_edge(clk))then
		if rd_clken = '1'
		then
			aav := aa;
			abv := ab;
			
		else
			aav := aal;
			abv := abl;
			
		end if;

		a <= reg_array(conv_integer(aav));
		b <= reg_array(conv_integer(abv));
		pc_out <= reg_array(15);
		
		aal <= aav;
		abl <= abv;
		

        if(write_enable='1')then
            reg_array(conv_integer(aw)) <= wrdata;
        end if;

        if(reset = '1')then
        	for i in 0 to 15 loop
        	reg_array(i) <= "00000000000000000000000000000000";
        	end loop;
        end if;	

    end if;
end process;

end dinesh;
---------------------------------------------------
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
      clk: in std_logic;
     -- reset : in std_logic;
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

--with reset select alu_res <= "00000000000000000000000000000000" when '1',
						--	 alu_res when others;

end architecture;
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_3 is
port(a1,a2,a3:in std_logic_vector(31 downto 0);
     x:in std_logic_vector(1 downto 0);
     a:out std_logic_vector(31 downto 0));
end entity;

architecture cc of multiplexer_3 is
begin
with x select
a<=a1 when "00",
   a2 when "01",
   a3 when others;
end cc;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_duplicate is
port(a:in std_logic_vector(31 downto 0);
     b:out std_logic_vector(31 downto 0));
end entity;

architecture cc of half_duplicate is
signal k:std_logic_vector(15 downto 0);
begin
k<=a(31 downto 16);
b(31 downto 16)<=k;
b(15 downto 0)<=k;
end cc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity byte_duplicate is
port(a:in std_logic_vector(31 downto 0);
     b:out std_logic_vector(31 downto 0));
end entity;

architecture cc of byte_duplicate is
signal k:std_logic_vector(7 downto 0);
begin
k<=a(31 downto 24);
b(31 downto 24)<=k;
b(23 downto 16)<=k;
b(15 downto 8)<=k;
b(7 downto 0)<=k;
end cc;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_sign_extension is
port(a:in std_logic_vector(31 downto 0);
     b:out std_logic_vector(31 downto 0));
end entity;

architecture cc of half_sign_extension is
signal k:std_logic_vector(15 downto 0);
begin
k<=a(31 downto 16);
p:for i in 16 to 31 generate
  b(i)<=a(31);
  end generate;
b(15 downto 0)<=k;
end cc;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_zero_extension is
port(a:in std_logic_vector(31 downto 0);
     b:out std_logic_vector(31 downto 0));
end entity;

architecture cc of half_zero_extension is
signal k:std_logic_vector(15 downto 0);
begin
k<=a(31 downto 16);
p:for i in 16 to 31 generate
  b(i)<='0';
  end generate;
b(15 downto 0)<=k;
end cc;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity byte_sign_extension is
port(a:in std_logic_vector(31 downto 0);
     b:out std_logic_vector(31 downto 0));
end entity;

architecture cc of byte_sign_extension is
signal k:std_logic_vector(7 downto 0);
begin
k<=a(31 downto 24);
p:for i in 8 to 31 generate
  b(i)<=a(31);
  end generate;
b(7 downto 0)<=k;
end cc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity byte_zero_extension is
port(a:in std_logic_vector(31 downto 0);
     b:out std_logic_vector(31 downto 0));
end entity;

architecture cc of byte_zero_extension is
signal k:std_logic_vector(7 downto 0);
begin
k<=a(31 downto 24);
p:for i in 8 to 31 generate
  b(i)<='0';
  end generate;
b(7 downto 0)<=k;
end cc;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity processor_memory_path is
port(p_in,m_in:in std_logic_vector(31 downto 0);
     p_out,m_out:out std_logic_vector(31 downto 0);
     instruction:in std_logic_vector(2 downto 0);
     offset:in std_logic_vector(7 downto 0);
     mwren:out std_logic_vector(3 downto 0));
end entity;

architecture cc of processor_memory_path is
signal p_in1,p_in2,m_in1,m_in2:std_logic_vector(31 downto 0);
signal k:std_logic_vector(1 downto 0);
begin
x1:entity work.half_duplicate(cc)
   port map(a=>p_in,
            b=>p_in1);
x2:entity work.byte_duplicate(cc)
   port map(a=>p_in,
            b=>p_in2);
x3:entity work.half_sign_extension(cc)
   port map(a=>m_in,
            b=>m_in1);
x4:entity work.byte_sign_extension(cc)
   port map(a=>m_in,
            b=>m_in2);
x5:entity work.multiplexer_3(cc)
   port map(a1=>p_in,
            a2=>p_in1,
            a3=>p_in2,
            x=>instruction(1 downto 0),
            a=>m_out);
x6:entity work.multiplexer_3(cc)
   port map(a1=>m_in,
            a2=>m_in1,
            a3=>m_in2,
            x=>instruction(1 downto 0),
            a=>p_out);
k<=instruction(1 downto 0);
with k select
mwren<="0000" when "00",
       "0011" when "01",
       "0001" when others;
end cc;
-------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity datapath is
port(
	PW : in std_logic;
	IorD : in std_logic;
	MR : in std_logic;
	MW : in std_logic;
	IW : in std_logic;
	DW : in std_logic;
	M2R : in std_logic_vector(1 downto 0);
	Rsrc1 : in std_logic;
	Rsrc2 : in std_logic;
	Wsrc  : in std_logic;
	RW : in std_logic;
	AW : in std_logic;
	BW : in std_logic;
	Asrc1 : in std_logic;
	Asrc2 : in std_logic_vector(2 downto 0);
	op : in std_logic_vector(3 downto 0);
	Fset : in std_logic;
	ReW : in std_logic;
	clk1 : in std_logic;
	reset : in std_logic;
	mult_mux : in std_logic;
	shifting_mux : in std_logic;
	shift_enable : in std_logic;
	F : out std_logic_vector(3 downto 0)

	);
end entity;

architecture beh of datapath is

component multiplier
port(op1,op2 : in std_logic_vector(31 downto 0);
	result   : out std_logic_vector(31 downto 0)
	);
end component;

component BRAM_wrapper 
  port (
    BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_clk : in STD_LOGIC;
    BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_en : in STD_LOGIC;
    BRAM_PORTA_rst : in STD_LOGIC;
    BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end component;

component shifter 
port(shift_amount : in std_logic_vector(4 downto 0);--since maximum shifting is 32 
	 shift_type   : in std_logic_vector(1 downto 0);
	 data         : in std_logic_vector(31 downto 0);
	 shifted_data  : out std_logic_vector(31 downto 0);
	 shift_c      : out  std_logic   );
end component;

component register_file
    port(
        clk    : in std_logic;
        aa     : in  std_logic_vector( 3 downto 0);--read address 1
        ab     : in  std_logic_vector( 3 downto 0);--read address 2
		aw     : in  std_logic_vector( 3 downto 0);-- write address
        write_enable   : in  std_logic;
		wrdata : in  std_logic_vector(31 downto 0);
		reset : in std_logic;

        a      : out std_logic_vector(31 downto 0);
        b      : out std_logic_vector(31 downto 0);
        pc_out : out std_logic_vector(31 downto 0)
    );
end component;

component alu 
port (op1,op2:in std_logic_vector(31 downto 0);
      operation:in std_logic_vector(3 downto 0);
      carry:in std_logic;
      clk: in std_logic;
     -- reset : in std_logic;
      flags:out std_logic_vector(3 downto 0);
      alu_res:out std_logic_vector(31 downto 0));
end  component;

component processor_memory_path 
port(p_in,m_in:in std_logic_vector(31 downto 0);
     p_out,m_out:out std_logic_vector(31 downto 0);
     instruction:in std_logic_vector(2 downto 0);
     offset:in std_logic_vector(7 downto 0);
     mwren:out std_logic_vector(3 downto 0));
end component;

signal IR , DR , RES :  std_logic_vector(31 downto 0);
signal ad , rd , wd_memory :  std_logic_vector(31 downto 0);
signal rad1 , rad2 , wad :  std_logic_vector(3 downto 0);
signal rd1 , rd2 , wd_rf :  std_logic_vector(31 downto 0);
signal rd1_A , rd2_B : std_logic_vector(31 downto 0);
signal S2 , EX : std_logic_vector(31 downto 0);
signal op1 , op2 , alu_out , multiplier_out : std_logic_vector(31 downto 0);
signal pc_o : std_logic_vector(31 downto 0);
signal F_tmp : std_logic_vector(3 downto 0);
signal shiftby : std_logic_vector(4 downto 0);
signal shifter_out : std_logic_vector(31 downto 0);
signal fourbit_MW : std_logic_vector(3 downto 0);
signal aluout_tmp : std_logic_vector(31 downto 0);
signal rd2_str_tmp : std_logic_vector(31 downto 0);
signal shift_carr : std_logic;
signal shft_typ : std_logic_vector(1 downto 0); 
signal shifted_rd2 : std_logic_vector(31 downto 0);
signal ror_a : std_logic_vector(3 downto 0);
signal ror_b : std_logic_vector(7 downto 0);
signal ror_carr : std_logic;
signal shft_amt_ror : std_logic_vector(4 downto 0);
signal EX_ror_b : std_logic_vector(31 downto 0);
signal shifter_out_ror: std_logic_vector(31 downto 0);

begin

--if (PW = '1')then pc_o <= alu_out; else pc_o <= pc_o; end if;
--if (IorD = '0')then ad <= pc_o; else ad <= RES; end if;

with PW select	pc_o <= alu_out when '1',
						pc_o when others;
with IorD select ad <= pc_o when '0',
				 	   RES when others;						


wd_memory <= rd2_B;

fourbit_MW(3 downto 1) <= "000";
fourbit_MW(0) <= MW;

proc_mem : BRAM_wrapper port map(ad,clk1,wd_memory,rd,MR,reset,fourbit_MW);

--if(IW = '1')then IR <= rd ; else IR <= IR; end if;
--if(DW = '1')then DR <= rd; else DR <= DR; end if;

with IW select	IR<= rd when '1',
				     IR when others;
with DW select DR <= rd when '1',
			   		 DR when others; 				     



--if(Rsrc1 = '0')then IR(19 downto 16) <= rad1; else IR(11 downto 8) <= rad1; end if;
--if(Rsrc2 = '0')then IR(3 downto 0) <= rad2; else IR(15 downto 12) <= rad2; end if;
--if(Wsrc = '0')then IR(15 downto 12) <= wad; else IR(19 downto 16) <= wad; end if;

with Rsrc1 select	rad1 <= IR(19 downto 16) when '0',
							IR(11 downto 8) when others;
with Rsrc2 select   rad2 <= IR(3 downto 0) when '0',
							IR(15 downto 12) when others;
with Wsrc select    wad <= IR(15 downto 12) when '0',
						   IR(19 downto 16) when others;							



with M2R select
	wd_rf <= RES when "00",
			 DR when "01",
			 pc_o when others;

EX(11 downto 0) <= IR(11 downto 0);EX(31 downto 12) <= "00000000000000000000";
S2(1 downto 0) <= "00";S2(25 downto 2) <= IR(23 downto 0);
sign_extend: 
S2(26) <= IR(25);S2(27) <= IR(25);S2(28) <= IR(25);
S2(29) <= IR(25);S2(30) <= IR(25);S2(31) <= IR(25);

rf : register_file port map(clk1,rad1,rad2,wad,RW,wd_rf,reset,rd1,rd2,pc_o);
	
with AW select
	rd1_A<=rd1 when '1',
	       rd1_A when others;
with BW select 
	rd2_B<= rd2 when '1',
	           rd2_B when others;

with shifting_mux select
	shiftby <= IR(11 downto 7) when '0',
	rd1_A(4 downto 0) when others;

shft_typ <= IR(6 downto 5);


shift : Shifter port map(shiftby,shft_typ,rd2_B,shifter_out,shift_carr);
shift_carr <= F_tmp(3);
multiply : multiplier port map(rd1_A,rd2_B,multiplier_out);

with shift_enable select shifted_rd2 <= rd2_B when '0',
									    shifter_out when others;

ror_a <= IR(11 downto 8);
ror_b <= IR(7 downto 0);
EX_ror_b(31 downto 8) <= "000000000000000000000000"; EX_ror_b(7 downto 0) <= ror_b;
shft_amt_ror <= ror_a & '0'; --multiply by 2
shift_ror : shifter port map(shft_amt_ror,"11",EX_ror_b,shifter_out_ror,ror_carr);





with Asrc1 select op1 <= pc_o when '0',
				  	     rd1_A when others;
with Asrc2 select op2 <= shifted_rd2 when "000",
						 "00000000000000000000000000000100" when "001", -- 4
						 EX when "010",
						 S2 when "011",
						 shifter_out_ror when others;

arith_logic_unit : alu port map(op1,op2,op,'0',clk1,F_tmp,aluout_tmp);				
alu_out <= aluout_tmp;

with mult_mux select rd2_B <= rd2 when '0',
						      multiplier_out when others;

with ReW select RES<=alu_out when '1',
	                  RES when others;
with Fset select F<=F_tmp when '1',
                    "0000" when others;




end architecture;