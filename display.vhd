library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity display is
    Port (
        reset_n : in std_logic;
        clk3 : in std_logic;  
        piso_actual : in std_logic_vector (2 downto 0);
        led : out STD_LOGIC_VECTOR (6 downto 0)
       
    );
end display;

architecture Behavioral of display is

signal numero : std_logic_vector (6 downto 0):="1111111";  

begin

    process (reset_n, clk3)
    begin
        if reset_n = '0' then
            numero <= "0000000"; -- se enciende todo.  
        elsif rising_edge (clk3) then
                case (piso_actual) is
                    when "001" =>
                        numero <= "1001111";   --numero 1
                    when "010" =>
                        numero <= "0010010";   --numero 2
                    when "011" =>
                        numero <= "0000110";   --numero 3
                    when "100" =>
                        numero <= "1001100";   --numero 4
                    when others =>
                        numero <= "1111110";   --espera
                end case;
           end if;
                         
    end process;

    led <= numero;
   
end architecture Behavioral;
