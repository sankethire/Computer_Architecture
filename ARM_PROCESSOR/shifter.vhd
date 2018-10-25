library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.arm_reg_condition.all;--local vhdl file access

entity shifter is
port(shift_amount : in std_logic_vector(4 downto 0);--since maximum shifting is 32 
	 shift_type   : in std_logic_vector(1 downto 0);
	 data         : in unsigned(31 downto 0);
	 shifted_data  : out unsigned(31 downto 0);
	 shift_c      : out  std_logic   );
end entity;

architecture aa of shifter is
signal shiftIn : unsigned(31 downto 0);
signal shift_amnt : std_logic_vector(4 downto 0);
signal d_out1,d_out2,d_out3,d_out4,d_out5 : unsigned(31 downto 0);
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

