library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity toplevel is
port(clk    : in std_logic;
     rst    : in std_logic;
     leftt  : in std_logic;
     rightt : in std_logic;
     hazard : in std_logic;
     L3     : out std_logic;
     L2     : out std_logic;
     L1     : out std_logic;
     R1     : out std_logic;
     R2     : out std_logic;
     R3     : out std_logic
);
end toplevel;

architecture struct of toplevel is
  component taillight
  port(clk    : in std_logic;
     rst    : in std_logic;
     leftt  : in std_logic;
     rightt : in std_logic;
     hazard : in std_logic;
     L3     : out std_logic;
     L2     : out std_logic;
     L1     : out std_logic;
     R1     : out std_logic;
     R2     : out std_logic;
     R3     : out std_logic
  );
  end component;

  component counter
  port(clk     : in std_logic;
       rst     : in std_logic;
       clk_out : out std_logic
  );
  end component;

  signal clk_slow : std_logic;

begin
  TAILLIGHT_1: taillight
  port map(clk => clk_slow,
           rst => rst,
           leftt => leftt,
           rightt => rightt,
           hazard => hazard,
           L3 => L3,
           L2 => L2,
           L1 => L1,
           R1 => R1,
           R2 => R2,
           R3 => R3
  );

  COUNTER_1: counter
  port map(clk => clk,
           rst => rst,
           clk_out => clk_slow
  );
end struct;
