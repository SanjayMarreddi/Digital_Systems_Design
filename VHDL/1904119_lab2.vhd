-- This file contains VHDL Code that is required for 4 Bit Ripple Carry Adder.
-- Author: Sanjay Marreddi
-- Date  : 18th September, 2020.


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- A Full_adder adds 3 bits (a,b,c_in) to produce a sum (s) and a carry (c_out).
entity Full_adder is 
	port(
    a,b	: in std_logic;
    c_in: in std_logic;
	s	: out std_logic;
	c_out: out std_logic);
end Full_adder;


-- Defining the architecture for above Full_adder entity.
architecture Behav of Full_adder is
begin
    
    -- Defining the sum(s)
    s <= ( a xor (b xor c_in) ) ;
    
    -- Defining the carry(c_out)
    c_out <= (  ( c_in and (a xor b) )  or  (a and b)  );
    
end Behav;

------------------------------------------------------------


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;



-- A Ripple_adder uses four Full_adder instances connected 
-- together by signals to add two four bit input vectors a and b along with a carry in and generates a 4 bit sum (s) and a carry out (c_out)

entity Ripple_adder is 
	port(
	a,b	:in std_logic_vector(3 downto 0);
	c_in:in std_logic;
    s	:out std_logic_vector(3 downto 0);
	c_out:out std_logic);
end Ripple_adder;


-- Defining the architecture for above Ripple_adder entity.
architecture Struct of Ripple_adder is
    
    -- Declaring the Full adder component.
    component Full_adder 
	port(
    a,b	: in std_logic;
    c_in: in std_logic;
	s	: out std_logic;
	c_out: out std_logic);
	end component;


	-- the following signals will be useful for connecting together the full adders.
	signal carry: std_logic_vector(3 downto 0):="0000";

begin

    
    FA0: Full_adder port map (a(0),b(0),c_in,	     s(0),carry(0));
    
    FA1: Full_adder port map (a(1),b(1),carry(0),	 s(1),carry(1));
    
    FA2: Full_adder port map (a(2),b(2),carry(1),	 s(2),carry(2));
    
    FA3: Full_adder port map (a(3),b(3),carry(2),	 s(3),carry(3));
    
    c_out <= carry(3) ;
	
end Struct;

------------------------------------------------------------

-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



-- The testbench for the Ripple_adder:
entity Testbench is 
--Testbench has no ports 
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture Behav of Testbench is

    -- Declaring the Ripple adder component.
	component Ripple_adder 
		port(
		a,b	:in std_logic_vector(3 downto 0);
		c_in:in std_logic;
		s	:out std_logic_vector(3 downto 0);
		c_out:out std_logic);
	end component;
    
    
    -- Declaring the signals and initializing.
    signal A,B,S: std_logic_vector(3 downto 0):="0000";
    signal C_IN,C_OUT: std_logic:='0';
    

begin

	-- Instantiating the Ripple_adder
    RA: Ripple_adder port map(A, B, C_IN, S, C_OUT);
    
	-- Assigning values to input signals.
	A <= std_logic_vector(unsigned(A)+1) after 10 ns;
    B <= std_logic_vector(unsigned(B)+1) after 40 ns;
    C_IN <= '0';
   

end Behav;

