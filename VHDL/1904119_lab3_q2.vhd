-- This file contains VHDL Code for Dataflow-style description for a 4x1 Multiplexor using only conditional assignments and using only selected assignments
-- Author: Sanjay Marreddi
-- Date  : 26th September, 2020.


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for 4x1 Multiplexor.
entity Mux4X1_Conditional is 
	port(a,b,c,d:  std_logic_vector(7 downto 0);
    	 s: in std_logic_vector(1 downto 0);
         y: out std_logic_vector(7 downto 0));
end Mux4X1_Conditional;


-- Defining the architecture using conditional assignments for above Mux4X1 entity.
architecture Conditional of Mux4X1_Conditional is
begin
	y <= a when (s="00") else
         b when (s="01") else
         c when (s="10") else
    	 d; 
end Conditional;


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;

-- Creating other entity for 4x1 Multiplexor.
entity Mux4X1_Selected is 
	port(a,b,c,d:  std_logic_vector(7 downto 0);
    	 s: in std_logic_vector(1 downto 0);
         y: out std_logic_vector(7 downto 0));
end Mux4X1_Selected;


-- Defining the architecture using Selected assignments for above Mux4X1 entity.
architecture Selected of Mux4X1_Selected is
begin
	with s select
    y<= a when "00",
    	b when "01",
        c when "10",
        d when "11",
        "00000000" when others;
        
end Selected;


------------------------------------------------------------


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- The testbench for the  4x1 Multiplexor:
entity Testbench is 
--Testbench has no ports 
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture Test of Testbench is

    -- Declaring the  4x1 Multiplexor component made using Conditional Assignments.
	component Mux4X1_Conditional 
      port(a,b,c,d:  std_logic_vector(7 downto 0);
           s: in std_logic_vector(1 downto 0);
           y: out std_logic_vector(7 downto 0));
	end component;
    
     -- Declaring the  4x1 Multiplexor component made using Selected Assignments.
	component Mux4X1_Selected 
      port(a,b,c,d:  std_logic_vector(7 downto 0);
           s: in std_logic_vector(1 downto 0);
           y: out std_logic_vector(7 downto 0));
	end component;
    
    
    -- Declaring the signals and initializing.
    signal a,b,c,d,y : std_logic_vector(7 downto 0):="00000000";
    signal s: std_logic_vector(1 downto 0):="00";
   
    
begin

	-- Instantiating the Mux4X1 and Mapping 
    Mu_Co: Mux4X1_Conditional port map(a, b, c, d, s, y);
    Mu_Se: Mux4X1_Selected port map(a, b, c, d, s, y);
    
	
    
    -- TESTING STRATEGY
    -- In Total there are (2^8)*(2^8)*(2^8)*(2^8)*(2^2) = 2^34 Possible Input Combinations.
    -- Simulating all of them is a Tedious Task.
    -- As we know that Output Value depends on the Select port value, Checking the Output for all the possible Select port values and some random values of a,b,c,d would be sufficient to ensure proper functionality of Multiplexor.


    -- Altering the values at the input signals.
    a <= std_logic_vector(unsigned(a)+1) after 2 ns;
    b <= std_logic_vector(unsigned(b)+1) after 3 ns;
    c <= std_logic_vector(unsigned(c)+1) after 4 ns;
    d <= std_logic_vector(unsigned(d)+1) after 5 ns;
	s <= std_logic_vector(unsigned(s)+1) after 6 ns;

    -- NOTE:
    -- I have used the same port names for both Mux4X1's to stick with given names.
    -- To check the outputs of MUx4X1 individually/Combined  without any confusion, Please opt Mu_Co or/and Mu_Se in "Get Signals" option as per requirement.


end Test;
