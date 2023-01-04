
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use ieee.std_logic_arith.ALL;

use ieee.std_logic_unsigned.ALL;




entity display is

    Port (

        reset_n : in std_logic;

        clk3 : in std_logic;  
        --clk1:in std_logic;

        piso_actual : in std_logic_vector (2 downto 0);
        
       -- digsel: out STD_LOGIC_VECTOR (7 downto 0);

        led : out STD_LOGIC_VECTOR (6 downto 0)

       

    );

end display;




architecture Behavioral of display is




signal numero : std_logic_vector (6 downto 0):="1111111";  
--signal digitos: natural range 0 to 4:=0; 
--signal clk_counter: natural range 0 to 20000:=0;



begin
--    digit: process (clk1)
--    begin
--        --if rising_edge (clk1) then
--          --  clk_counter<=clk_counter + 1;
            
--            if clk_counter>=20000 then 
--                clk_counter<=0;
--                digitos<=digitos + 1;
--            end if;
            
--            if digitos > 4 then
--                digitos<=0;
--            end if;
            
--        end if;
--    end process digit;
            
            
            
    pdisplay:process (reset_n, clk3)

    begin

        if reset_n = '0' then

            numero <= "0000000"; -- se enciende todo.  
       -- else
            --case digitos is
--                when 0=>
--                    numero<="0011000";--P
--                    digsel<="01111111";
                    
--                when 1=>
--                    numero<="1001111";--I
--                    digsel<="10111111";
                    
--                when 2=>
--                    numero<="0100101";--S
--                    digsel<="11011111";
                    
--                when 3=>
--                    numero<="0000001";--O
--                    digsel<="11101111";
                    
--                when 4=>
                    
                   -- digsel<="11110111";
                    
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

          -- end case;              
   --end if;
    end process pdisplay;




    led <= numero;

   

end architecture Behavioral;
