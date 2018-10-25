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
	signal rd_clken : in std_logic := '1';
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