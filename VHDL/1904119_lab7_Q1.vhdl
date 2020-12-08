-- This file contains VHDL Code for behavioral description of a Negative Edge-triggered T Flip-Flop with an Asynchronous Reset.
-- Author: Sanjay Marreddi
-- Date  : 8th December, 2020.


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- Creating an entity for Toggle Flip Flop.
entity TFF is
    port(CLK: in std_logic;
        T: in std_logic ; 
        R: in std_logic ;
        Q: out std_logic );
end TFF;


-- Defining a Behavioural architecture of Toggle Flip Flop.
architecture Behav of TFF is 
begin 
    proc: process (CLK,R) is
    begin 
    if R= '1' then                         -- Giving Higher Priority to Reset leads to Asynchronous Reset.
        Q <= '0';
    else
        if CLK'event and CLK = '0'  then   -- It is Negative Edge Triggered since we kept CLK = '0'
            if T = '1' then
                Q <= not Q; 
            end if; 
         end if;
    end if;
    end process proc;
end Behav;

-------------------------------------------------------------------------------------
-- Test Bench for testing the functionality of the T Flip-Flop 


-- Importing the required Library and Packages.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- Creating an entity for Toggle
entity Testbench is
end Testbench;

architecture test of Testbench is
    
    component TFF is 
    port(CLK: in std_logic;
        T: in std_logic ; 
        R: in std_logic ;
        Q: out std_logic );
    end component;

    -- Declaring the signals and initializing.
    signal T0,T1,T2,T : std_logic := '0' ;
    signal Q,CLK : std_logic := '0';
    signal R : std_logic := '1';


begin

    
	-- Instantiating the TFF and Mapping 
    TFFTest : TFF port map (CLK,T,R,Q);


    -- Altering and assigning values to input signals.
    CLK <=  not CLK after 10ns;
    T0 <= not T0 after 5ns;
    T1 <= not T1 after 20ns;
    T2 <= T0 xor T1;
    T  <= T2 after 3ns;
    R <= not R after 16ns;

end test;