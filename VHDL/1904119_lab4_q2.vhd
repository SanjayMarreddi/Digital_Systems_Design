-- This file contains VHDL Code that is required for Structural Description for an N-bit Adder-Subtractor module that
-- can either perform Signed Addition(A+B) or Signed Subtraction(A-B) based on the value of an “op_sel” input

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

-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for N-bit 2x1 MUX

entity N_Mux_2X1 is 
    generic(N:integer:=4);
	port(a,b:in   std_logic_vector(N-1 downto 0);
    	 s: in std_logic;
         y: out std_logic_vector(N-1 downto 0));
end N_Mux_2X1;

architecture arch_N_Mux of N_Mux_2X1 is
    begin
        y <= a when (s='0') else
             b when (s='1') ;               
end arch_N_Mux;

------------------------------------------------------------


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for 1-bit 2x1 MUX

entity Mux_2X1 is 
	port(a,b:in std_logic;
    	 s: in std_logic;
         y: out std_logic);
end Mux_2X1;

architecture arch_1_Mux of Mux_2X1 is
    begin
        y <= a when (s='0') else
             b when (s='1') ;               
    end arch_1_Mux;

------------------------------------------------------------


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for NOT_GATE

entity NOT_GATE is 
	port(a : in  std_logic;
         a_inv: out std_logic);
end NOT_GATE;

architecture arch_Not of NOT_GATE is

begin
	a_inv <= NOT a ;
end arch_Not;

------------------------------------------------------------


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for Bitwise_Invertor

entity Bitwise_Invert is 
    generic(N:integer:=4);
	port(a :in   std_logic_vector(N-1 downto 0);
         a_inv: out std_logic_vector(N-1 downto 0));
end Bitwise_Invert;

architecture arch_Bit_Inv of Bitwise_Invert is

    component NOT_GATE is
    	port(a : in  std_logic;
             a_inv: out std_logic);
    end component;

    begin
         not_array : for i in (N-1) downto 0 generate 
            not_i: NOT_GATE port map(a(i), a_inv(i));
        end generate not_array;
        
end arch_Bit_Inv;

------------------------------------------------------------


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for Checking Over Flow 

entity Over_Flow_Checker is 
	port(a,b,y,op_sel: in std_logic;
    	 ov: out std_logic);
end Over_Flow_Checker;

architecture arch_Over_Flow of Over_Flow_Checker is
    begin

        -- Upon Solving for Boolean Function of Over_Flow existence, We get below expression.

        ov <= (( a and b and not(y) and not(op_sel) ) or ( not(a) and b and y and op_sel ) or 
              ( a and not(b) and not(y) and op_sel ) or ( not(a) and not(b) and y and not(op_sel)));
	         
end arch_Over_Flow;

------------------------------------------------------------

-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating Adder-Subtractor Module

entity N_Add_Sub is 
    generic(N:integer:=4);
	port(a,b:in  std_logic_vector(N-1 downto 0);
         op_sel: in std_logic;
         y: out std_logic_vector(N-1 downto 0);
         Cout: out std_logic;
         OV: out std_logic);

end N_Add_Sub;


architecture arch_add_sub of N_Add_Sub is

    -- Declaring the Component of N-bit Ripple Carry Adder.
    component N_Ripple_adder
        generic(N:integer:=4);
        port(
        a,b	:in std_logic_vector(N-1 downto 0);
        c_in:in std_logic;
        s	:out std_logic_vector(N-1 downto 0);
        c_out:out std_logic);
    end component;

    -- Declaring the Component of N-bit 2X1 Mux.
    component N_Mux_2X1
        generic(N:integer:=4);
        port(a,b:in   std_logic_vector(N-1 downto 0);
            s: in std_logic;
            y: out std_logic_vector(N-1 downto 0));
    end component;
    
     -- Declaring the Component of 1-bit 2X1 Mux.
    component Mux_2X1
        port(a,b:in std_logic;
             s: in std_logic;
             y: out std_logic);
    end component;
    
    -- Declaring the Component of Bitwise_Invertor.
    component Bitwise_Invert is 
        generic(N:integer:=4);
        port(a :in   std_logic_vector(N-1 downto 0);
            a_inv: out std_logic_vector(N-1 downto 0));
    end component;
	
    -- Declaring the Component of Over_Flow_Checker.
    component Over_Flow_Checker is 
        port(a,b,y,op_sel: in std_logic;
             ov: out std_logic);
     end component;


    -- Declaring the Signals

    signal BitInv_b,Y_N_Mux : std_logic_vector(N-1 downto 0) ;
    
    signal Y_1_Mux : std_logic:='0';
    
    signal one : std_logic := '1';

	signal zero : std_logic := '0';
    
    begin
        
        Bit_Inv : Bitwise_Invert port map (b,BitInv_b);

        N_Mux   : N_Mux_2X1 port map (b,BitInv_b,op_sel,Y_N_Mux);

        One_Mux : Mux_2X1   port map (zero,one,op_sel,Y_1_Mux);

        Add_Sub : N_Ripple_adder port map(a,Y_N_MUX,Y_1_MUX,y,Cout);

		Overflow : Over_Flow_Checker port map(a(N-1),b(N-1),y(N-1),op_sel,OV);
       

end arch_add_sub;

------------------------------------------------------------

-- TEST BENCH

-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity Testbench is  
generic(N:integer:= 4);
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture arch_test of Testbench is

    -- Declaring the N_Add_Sub component.
    component N_Add_Sub 
      generic(N:integer:=4);
      port(a,b:in  std_logic_vector(N-1 downto 0);
           op_sel: in std_logic;
            y: out std_logic_vector(N-1 downto 0);
            Cout: out std_logic;
            OV: out std_logic);
	end component;
    
    
    -- Declaring the signals and initializing.
    signal A,B,Y: std_logic_vector(N-1 downto 0) := (N-1 downto 0=>'0') ;
    signal C_OUT: std_logic ;
	signal OP_SEL: std_logic := '0';
    signal OV: std_logic ;
    

begin
	-- Instantiating the N_Add_Sub
    ADD_SUB: N_Add_Sub port map(A, B, OP_SEL, Y, C_OUT, OV);
    
	-- Assigning values to input signals.
	A <= std_logic_vector(signed(A)+1) after 6 ns;
    B <= std_logic_vector(signed(B)+1) after 12 ns;



    OP_SEL <= not OP_SEL after 50ns ;
 
    -- NOTE:- Use atleast 100 ns Run Time for checking to cover max possibilites.

end arch_test;