library ieee;
use ieee.std_logic_1164.all;

entity counter is
port(clk     : in std_logic;
     rst     : in std_logic;
     clk_out : out std_logic
);
end counter;

architecture rtl of counter is
  constant divide : integer := 25000000;

begin
  clock: process(clk, rst)
    variable count : integer;
    variable clk_slow : std_logic;

  begin
    if(rst='0') then
      count := 0;
      clk_slow := '0';
    elsif(rising_edge(clk)) then
      if(count = divide-1) then
        clk_slow := not clk_slow;
        count := 0;
      else
        count := count+1;
      end if;
    end if;
    clk_out <= clk_slow;
  end process;
        
end rtl;
