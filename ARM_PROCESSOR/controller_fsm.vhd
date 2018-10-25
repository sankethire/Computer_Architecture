library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_fsm is
port(
	ins : in std_logic_vector(2 downto 0);
	clk : in std_logic;
	reset : in std_logic 
	);
end entity;

architecture cf of controller_fsm is
type State_type is (fetch , rdAB , arith , addr , brn , wrRF , wrM , rdM , M2RF);
signal state : State_type ; 
begin

process(clk,reset)
begin
	if reset = '1' then state <= fetch;
	
	elsif rising_edge(clk) then
	case state is
                when fetch =>
                             state <= rdAB;
                when rdAB =>
                             if ins(2 downto 1) = "00" then
                             state <= arith;
                             elsif ins(2 downto 1) = "01" then
                             state <= addr;
                             elsif ins(2 downto 1) = "10" then
                             state <= brn;
                             end if;
                when arith =>
                             state <= wrRF;
                when wrRF =>
                             state <= fetch;
                when addr =>
                             if ins(3) = '0' then 
                             state <= wrM;
                             elsif ins(3) ='1' then
                             state <= rdM;
                             end if;
                 when wrM =>
                             state <= fetch;
                 when rdM =>
                             state <= M2RF;
                 when M2RF =>
                             state <= fetch;
                 when brn =>
                             state <= fetch;
                                                                                  
    end case;                              
    end if;
    end process;
    
    end architecture;                              



		

		