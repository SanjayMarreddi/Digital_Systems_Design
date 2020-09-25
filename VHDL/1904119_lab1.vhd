-- This contains simple entities for AND gate & XOR gate.
-- Author: Sanjay Marreddi
-- Date  : 11th September, 2020.


-- Creating an entity for AND Gate.
entity And_gate is 
	port(a1,b1: in bit; c1: out bit);
end And_gate;

-- Defining the architecture for above And_gate entity.
architecture Arch1 of And_gate is
begin
	c1<= a1 and b1;
end Arch1;


-- Creating an entity for XOR Gate.
entity Xor_gate is 
	port(a2,b2: in bit; c2: out bit);
end Xor_gate;

-- Defining the architecture for above Xor_gate entity.
architecture Arch2 of Xor_gate is
begin
    -- Output of XOR Gate with inputs x, y is xy' + x'y
	c2<= (( a2 and (not b2) ) or ( (not a2) and b2));  
end Arch2;








-- This is a testbench for a Half Adder which takes two inputs a, b of type 'bit' and two outputs s (sum) and c (carry) of type 'bit'.  
-- Author: Sanjay Marreddi
-- Date  : 11th September, 2020



-- Creating an entity for Testbench.
entity Testbench is 
--Testbench has no ports 
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture Arch_test of Testbench is

	--Declaring the components
    component And_gate 
    port(a1,b1: in bit; c1: out bit);
    end component;
    
    component Xor_gate  
	port(a2,b2: in bit; c2: out bit);
	end component;
    
    -- Declaring the signals which are 1 bit wide and initializing them to '0'
    signal a,b,c,s:bit:='0';
    
begin
	A1: And_gate port map(a1=>a,b1=>b,c1=>c);
    A2: Xor_gate port map(a2=>a,b2=>b,c2=>s);
    
    -- toggle values of these signals after regular intervals.
    a <= not a after 10ns;
    b <= not b after 7ns;
    
end Arch_test;
