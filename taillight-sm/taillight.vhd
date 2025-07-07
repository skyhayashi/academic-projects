library ieee;
use ieee.std_logic_1164.all;

entity taillight is
port(clk    : in std_logic;
     rst    : in std_logic;
     leftt  : in std_logic;
     rightt : in std_logic;
     hazard : in std_logic;
     L3     : out std_logic; -- LC
     L2     : out std_logic; -- LB
     L1     : out std_logic; -- LA
     R1     : out std_logic; -- RA
     R2     : out std_logic; -- RB
     R3     : out std_logic  -- RC
);
end taillight;

architecture rtl of taillight is
  type state_t is (OFF, HAZARDS, LA, LAB, LABC, RA, RAB, RABC);
  signal cur_state, next_state : state_t;

  attribute enum_encoding : string;
  attribute enum_encoding of state_t : type is "sequential";

begin
  machine: process(leftt, rightt, hazard, cur_state)
  begin
    -- default
    next_state <= OFF;

    case cur_state is
      when OFF =>
        L1 <= '0';
        L2 <= '0';
        L3 <= '0';
        R1 <= '0';
        R2 <= '0';
        R3 <= '0';
        if(hazard='1') then
          next_state <= HAZARDS;
        elsif(leftt='1') then
          next_state <= LA;
        elsif(rightt='1') then
          next_state <= RA;
        else
          next_state <= OFF;
        end if;
          
      when HAZARDS =>
        L1 <= '1';
        L2 <= '1';
        L3 <= '1';
        R1 <= '1';
        R2 <= '1';
        R3 <= '1';
        if(hazard='1') then
          next_state <= OFF;
        elsif(leftt='1') then
          next_state <= LA;
        elsif(rightt='1') then
          next_state <= RA;
        else
          next_state <= OFF;
        end if;
      
      when LA =>
        L1 <= '1';
        L2 <= '0';
        L3 <= '0';
        R1 <= '0';
        R2 <= '0';
        R3 <= '0';
        if(hazard='1') then
          next_state <= HAZARDS;
        elsif(leftt='1') then
          next_state <= LAB;
        elsif(rightt='1') then
          next_state <= RA;
        else
          next_state <= OFF;
        end if;
          
      when LAB =>
        L1 <= '1';
        L2 <= '1';
        L3 <= '0';
        R1 <= '0';
        R2 <= '0';
        R3 <= '0';
        if(hazard='1') then
          next_state <= HAZARDS;
        elsif(leftt='1') then
          next_state <= LABC;
        elsif(rightt='1') then
          next_state <= RA;
        else
          next_state <= OFF;
        end if;
          
      when LABC =>
        L1 <= '1';
        L2 <= '1';
        L3 <= '1';
        R1 <= '0';
        R2 <= '0';
        R3 <= '0';
        if(hazard='1') then
          next_state <= HAZARDS;
        elsif(leftt='1') then
          next_state <= OFF;
        elsif(rightt='1') then
          next_state <= RA;
        else
          next_state <= OFF;
        end if;

      when RA =>
        L1 <= '0';
        L2 <= '0';
        L3 <= '0';
        R1 <= '1';
        R2 <= '0';
        R3 <= '0';
        if(hazard='1') then
          next_state <= HAZARDS;
        elsif(leftt='1') then
          next_state <= LA;
        elsif(rightt='1') then
          next_state <= RAB;
        else
          next_state <= OFF;
        end if;
          
      when RAB =>
        L1 <= '0';
        L2 <= '0';
        L3 <= '0';
        R1 <= '1';
        R2 <= '1';
        R3 <= '0';
        if(hazard='1') then
          next_state <= HAZARDS;
        elsif(leftt='1') then
          next_state <= LA;
        elsif(rightt='1') then
          next_state <= RABC;
        else
          next_state <= OFF;
        end if;
          
      when RABC =>
        L1 <= '0';
        L2 <= '0';
        L3 <= '0';
        R1 <= '1';
        R2 <= '1';
        R3 <= '1';
        if(hazard='1') then
          next_state <= HAZARDS;
        elsif(leftt='1') then
          next_state <= LA;
        elsif(rightt='1') then
          next_state <= OFF;
        else
          next_state <= OFF;
        end if;
          
      when others =>
        -- do nothing
      end case;
  end process machine;

  registers: process(clk, rst)
  begin
    if(rst='0') then
      cur_state <= OFF:
    elsif(rising_edge(clk)) then
      cur_state <= next_state;
    end if;
  end process registers;
      
end rtl;
