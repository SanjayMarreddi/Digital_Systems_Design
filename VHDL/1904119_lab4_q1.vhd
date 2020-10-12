-- This file contains VHDL Code that is required for Structural Description for an N-bit Ripple-Carry Adder using Full adders as components.
-- Author: Sanjay Marreddi
-- Date  : 10th October, 2020.



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
architecture arch_FA of Full_adder is
    begin
        
        -- Defining the sum(s)
        s <= ( a xor (b xor c_in) ) ;
        
        -- Defining the carry(c_out)
        c_out <= (  ( c_in and (a xor b) )  or  (a and b)  );
        
end arch_FA;



------------------------------------------------------------


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;



-- An N-bit Ripple_adder uses N Full_adder instances connected 
-- together by signals to add two N bit input vectors a and b along with a carry in (c_in) and generates a N bit sum (s) and a carry out (c_out)

entity N_Ripple_adder is 
    generic(N:integer:=4);
    port(
    a,b	:in std_logic_vector(N-1 downto 0);
    c_in:in std_logic;
    s	:out std_logic_vector(N-1 downto 0);
    c_out:out std_logic);
end N_Ripple_adder;


-- Defining the architecture for above N_Ripple_adder entity.
architecture arch_N_RA of N_Ripple_adder is
    
    -- Declaring the Full adder component.
    component Full_adder 
	port(
    a,b	: in std_logic;
    c_in: in std_logic;
	s	: out std_logic;
	c_out: out std_logic);
	end component;


	-- the following signals will be useful for connecting together the full adders.
	signal carry: std_logic_vector(N-1 downto 0) := (N-1 downto 0 =>'0') ;

begin

    each_bit: for i in (N-1) downto 0 generate 

        Initial_bit: if i = 0 generate
            FA_0: Full_adder port map (a(i),b(i),c_in, s(i),carry(i));
        end generate Initial_bit;

        Other_bits: if i>0 generate
            FA_i: Full_adder port map (a(i),b(i),carry(i-1), s(i),carry(i));
        end generate Other_bits;
    
    end generate each_bit;
    
    c_out <= carry(N-1) ;
	
end arch_N_RA;

------------------------------------------------------------

-- TEST BENCH

-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- The testbench for the Ripple_adder:
entity Testbench is 
generic(N:integer:= 4);
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture arch_test of Testbench is

    -- Declaring the Ripple adder component.
    component N_Ripple_adder 
        generic(N:integer:= 4);
        port(
        a,b	:in std_logic_vector(N-1 downto 0);
        c_in:in std_logic;
        s	:out std_logic_vector(N-1 downto 0);
        c_out:out std_logic);
	end component;
    
    
    -- Declaring the signals and initializing.
    signal a,b,s:std_logic_vector(N-1 downto 0) := (N-1 downto 0 =>'0') ;
    signal c_in, c_out: std_logic:='0';
    

    
begin

	-- Instantiating the Ripple_adder
    RA: N_Ripple_adder port map(a, b, c_in, s, c_out);
    
	-- Assigning values to input signals.
	a <= std_logic_vector(unsigned(a)+1) after 7 ns;
    b <= std_logic_vector(unsigned(b)+1) after 14 ns;
   
    -- NOTE:- Use atleast 100 ns Run Time for checking to cover max possibilites.

end arch_test;

------------------------------------------------------------