-- This file contains VHDL Code for Structural Description and an appropriate Testbench for a 4x1 Multiplexor.
-- Author: Sanjay Marreddi
-- Date  : 26th September, 2020.


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for 4x1 Multiplexor.
entity Mux4X1 is 
	port(a,b,c,d: in std_logic; 
    	 s: in std_logic_vector(1 downto 0);
         y: out std_logic);
end Mux4X1;

-- Defining the architecture for above Mux4X1 entity.
architecture Struc of Mux4X1 is
begin
    --  Upon Drawing the Truth Table and Evaluating We get the following Expression.
    
	y <= ( (a and ( not(s(0)) ) and ( not(s(1)) ) ) or ( b and s(0) and ( not(s(1)) ) ) or ( c and ( not(s(0)) ) and s(1) ) or ( d and s(0) and s(1) ));  

end Struc;



------------------------------------------------------------



-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;

-- The testbench for the  4x1 Multiplexor:
entity Testbench is 
--Testbench has no ports 
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture Struc of Testbench is

    -- Declaring the  4x1 Multiplexor component.
	component Mux4X1 
	port(a,b,c,d: in std_logic; 
    	 s: in std_logic_vector(1 downto 0);
         y: out std_logic);
	end component;
    
    
    -- Declaring the signals and initializing.
    signal a,b,c,d,y: std_logic:='0';
    signal s: std_logic_vector(1 downto 0):="00";
   
    
begin

	-- Instantiating the Mux4X1
    Mu: Mux4X1 port map(a, b, c, d, s, y);
    
	-- Altering the values at the input signals.
	s(0) <= not s(0) after 10 ns;
    s(1) <= not s(1) after 9  ns;
    a <= not a after 8ns;
    b <= not b after 7ns;
    c <= not c after 6ns;
    d <= not d after 5ns;
   

end Struc;
