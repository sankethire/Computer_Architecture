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

--proc_mem : processor_memory_path port map(rd2_B,rd,wd_rf,wd_memory,)
b_ram : BRAM_wrapper port map(ad,clk1,wd_memory,rd,MR,reset,fourbit_MW);



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