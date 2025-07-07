library ieee;
use ieee.std_logic_1164.all;

entity taillight_tb is
end taillight_tb;

architecture beh of taillight_tb is
  signal clk    : std_logic;
  signal rst    : std_logic;
  signal leftt  : std_logic;
  signal rightt : std_logic;
  signal hazard : std_logic;
  signal L3     : std_logic;
  signal L2     : std_logic;
  signal L1     : std_logic;
  signal R1     : std_logic;
  signal R2     : std_logic;
  signal R3     : std_logic;

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
    
begin
  taillight_inst: taillight
  port map(clk => clk,
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

  clk_tb: process
  begin
    clk <= '0';
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
  end process clk_tb;

  tb: process
  begin
    -- right turn signal
    leftt <= '0';
    rightt <= '1';
    hazard <= '0';
    wait for 50 ns;
      
    -- left turn signal
    leftt <= '1';
    rightt <= '1';
    hazard <= '0';
    wait for 50 ns;
      
    -- hazard signal on
    leftt <= '1';
    rightt <= '1';
    hazard <= '1';
    wait for 50 ns;

    assert false
    report "End of Testbench"
    severity failure;
  end process tb;

end architecture beh;
