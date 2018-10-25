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
  b(i)<=0;
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
  b(i)<=0;
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
x3:entity work.half_extension(cc)
   port map(a=>m_in,
            b=>m_in1);
x4:entity work.byte_extension(cc)
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
