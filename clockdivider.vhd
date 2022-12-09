--genera la señal cuadrada del reloj
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity clk_divider is
    Generic (
        frecuencia: integer:=50000000         --50 MHz
       
    );            
    Port ( 
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk : OUT STD_LOGIC
    );
end clk_divider;

architecture Behavioral of clk_divider is
SIGNAL clk_signal: STD_LOGIC;

begin

    process (reset, clock)
    variable count: integer;
    
    begin
    if(reset='1')   then
        count := 0;
        clk_signal<='0';
    elsif rising_edge(clock)  then
        if (count = frecuencia)   then
            count := 0;
            clk_signal<=not (clk_signal);
        else 
            count := count + 1;
        end if;
    end if;
    end process;
    
clk <= clk_signal;

end Behavioral;
