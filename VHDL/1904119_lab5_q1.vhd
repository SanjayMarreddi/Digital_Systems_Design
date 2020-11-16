-- This file contains VHDL Code for a 3-to-8 Line Decoder with an Enable input in Structural Style and Dataflow Style architectures.
-- Author: Sanjay Marreddi
-- Date  : 31st October, 2020.


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


-- Creating an entity for 3x8 Decoder.
entity Decoder_3x8_stru is 
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
end  Decoder_3x8_stru;



-- Defining the architecture for above 3x8 Decoder entity in Structural Style.
architecture Structural of Decoder_3x8_stru is
begin
    
        D0 <=  (not(X(2)) and not(X(1)) and not(X(0)) and E);
        D1 <=  (not(X(2)) and not(X(1)) and X(0) and E);
        D2 <=  (not(X(2)) and X(1) and not(X(0)) and E);
        D3 <=  (not(X(2)) and X(1) and X(0) and E);
        D4 <=  ( X(2) and not(X(1)) and not(X(0)) and E);
        D5 <=  (X(2) and not(X(1)) and X(0) and E);
        D6 <=  (X(2) and X(1) and not(X(0)) and E);
        D7 <=  (X(2) and X(1) and X(0) and E);
	
end Structural;


    
------------------------------------------------------------

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
-- TESTBENCH

-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;


entity Testbench is 
--Testbench has no ports 
end Testbench;


-- Defining the architecture for above Testbench entity.
architecture test of Testbench is

    -- Declaring the 3x8 Decoder component in Structural style.
	component Decoder_3x8_stru 
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
    signal X: std_logic_vector(2 downto 0):="000";
    signal D0 : std_logic ;
    signal D1 : std_logic ;
    signal D2 : std_logic ;
    signal D3 : std_logic ;
    signal D4 : std_logic ;
    signal D5 : std_logic ;
    signal D6 : std_logic ;
    signal D7 : std_logic ;

   
    
begin

    Structural: Decoder_3x8_stru port map(X,E,D0,D1,D2,D3,D4,D5,D6,D7);
    Data: Decoder_3x8_Data port map(X,E,D0,D1,D2,D3,D4,D5,D6,D7);

	-- Altering the values at the input signals.
    X(0) <= not X(0) after 3ns;
    X(1) <= not X(1) after 6ns;
    X(2) <= not X(2) after 9ns;
    E <= not E after 50ns;


end test;