-- This file contains VHDL Code for Combinational circuit which satisfies the given Conditions. 
-- Author: Sanjay Marreddi
-- Date  : 31st October, 2020.


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for 3x8 Decoder.
entity Decoder_3x8_Data is 
    port(X: in std_logic_vector(2 downto 0);
         E: in std_logic;
         D0: out std_logic;
         D1: out std_logic;
         D2: out std_logic;
         D3: out std_logic;
         D4: out std_logic;
         D5: out std_logic;
         D6: out std_logic;
         D7: out std_logic);
end  Decoder_3x8_Data;


-- Defining the architecture for above 3x8 Decoder entity in Dataflow style.
architecture Data of Decoder_3x8_Data is
begin

    D0 <= E when (X="000") else 
          '0' ;
    D1 <= E when (X="001") else 
            '0' ;
    D2 <= E when (X="010") else 
            '0' ;
    D3 <= E when (X="011") else 
            '0' ;
    D4 <= E when (X="100") else 
            '0' ;
    D5 <= E when (X="101") else 
            '0' ;
    D6 <= E when (X="110") else 
            '0' ;
    D7 <= E when (X="111") else 
            '0' ;
    
	
end Data;

------------------------------------------------------------


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for required Combinational Circuit.
entity Combin_circuit is 
    port(X: in std_logic_vector(2 downto 0);
         F0: out std_logic;
         F1: out std_logic;
         F2: out std_logic;
         F3: out std_logic);
end  Combin_circuit;



-- Defining the architecture for above entity.
architecture arch of Combin_circuit is

    -- Declaring the 3x8 Decoder component in Dataflow style.
    component Decoder_3x8_Data 
    port(X: in std_logic_vector(2 downto 0);
         E: in std_logic;
         D0: out std_logic;
         D1: out std_logic;
         D2: out std_logic;
         D3: out std_logic;
         D4: out std_logic;
         D5: out std_logic;
         D6: out std_logic;
         D7: out std_logic);
    end component;

    -- Declaring the signals and initializing.
    signal E: std_logic:='1';
    signal D0 : std_logic ;
    signal D1 : std_logic ;
    signal D2 : std_logic ;
    signal D3 : std_logic ;
    signal D4 : std_logic ;
    signal D5 : std_logic ;
    signal D6 : std_logic ;
    signal D7 : std_logic ;
    
    begin
        
        Decoder: Decoder_3x8_Data port map(X,E,D0,D1,D2,D3,D4,D5,D6,D7);
        
        -- After writing the Truth Table using the given conditions and evaluating , we get below expressions.
        
        F0 <= D0 ;
        F1 <= (D2 or D3 or D4 or D6) ;
        F2 <= (D6 or  D7);
        F3 <= (D1 or D2 or D4 or D7); 

        -- NOTE : I assumed that 0 in Decimal System is Neither EVEN nor ODD Integer.

    end arch;

------------------------------------------------------------
--TESTBENCH

-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Testbench is 
--Testbench has no ports 
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture test of Testbench is

    -- Declaring the Component of our Combinational Circuit
	component Combin_circuit 
    port(X: in std_logic_vector(2 downto 0);
         F0: out std_logic;
         F1: out std_logic;
         F2: out std_logic;
         F3: out std_logic);
	end component;
    
 
   -- Declaring the signals and initializing.
    signal X: std_logic_vector(2 downto 0):="000";
    signal F0 : std_logic ;
    signal F1 : std_logic ;
    signal F2 : std_logic ;
    signal F3 : std_logic ;

    
begin

    circuit : Combin_circuit port map(X,F0,F1,F2,F3);

	-- Altering the values at the input signals.
    X(0) <= not X(0) after 3ns;
    X(1) <= not X(1) after 6ns;
    X(2) <= not X(2) after 9ns;

    -- We can even Vary the Signal X as follows :
    --  X <= std_logic_vector(unsigned(X)+1) after 3 ns;
    

end test;