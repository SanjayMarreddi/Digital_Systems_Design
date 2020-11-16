-- This file contains VHDL Code for a Behavioral-style Architecture Description for an 8-to-3 Priority Encoder using a Process block and sequential statements

-- Inputs: D of type std_logic_vector(7 downto 0), where D(7) has the highest priority
-- Outputs: x,y,z,V (of type std_logic)

-- Author: Sanjay Marreddi
-- Date  : 8th November, 2020.


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Creating an entity for 8-to-3 Priority Encoder 
entity Encoder_8x3 is 
    port( D: in std_logic_vector(7 downto 0);
          x : out std_logic;
          y : out std_logic;
          z : out std_logic;
          V : out std_logic);
end  Encoder_8x3 ;

-- Behavioral-style Architecture Description 
architecture Behavioral of Encoder_8x3 is
begin
    Encoder_Process : process (D)
   
    begin

    V <= '1';

    If    (D(7) = '1') then  x <= '1'; y <= '1' ; z <= '1';   

    elsif (D(6) = '1') then  x <= '1'; y <= '1' ; z <= '0'; 
    
    elsif (D(5) = '1') then  x <= '1'; y <= '0' ; z <= '1'; 

    elsif (D(4) = '1') then  x <= '1'; y <= '0' ; z <= '0'; 

    elsif (D(3) = '1') then  x <= '0'; y <= '1' ; z <= '1'; 

    elsif (D(2) = '1') then  x <= '0'; y <= '1' ; z <= '0'; 

    elsif (D(1) = '1') then  x <= '0'; y <= '0' ; z <= '1'; 

    elsif (D(0) = '1') then  x <= '0'; y <= '0' ; z <= '0'; 

    else

    V <= '0';

    --  X can be either 0 or 1.
    x <= 'X';
    y <= 'X';
    z <= 'X';

    end if ;

    end process Encoder_Process ;

end Behavioral;


-----------------------------------------------------------

-- TEST BENCH

-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- The testbench for the 8-to-3 Priority Encoder 
entity Testbench is 
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture arch_test of Testbench is

    -- Declaring the 8-to-3 Priority Encoder component.    
    component Encoder_8x3 is 
    port( D: in std_logic_vector(7 downto 0);
          x : out std_logic;
          y : out std_logic;
          z : out std_logic;
          V : out std_logic);
    end component;

    
    -- Declaring the signals and initializing.
    signal x,y,z,V:std_logic ;
    signal D : std_logic_vector(7 downto 0) := "00000000";
    
begin

	-- Instantiating and mapping the Encoder_8x3
    Encoder: Encoder_8x3 port map(D,x,y,z,V);
    
	-- Altering values to input signals.
	D <= std_logic_vector(unsigned(D)+1) after 2 ns;
   
end arch_test;

------------------------------------------------------------