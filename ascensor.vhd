library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity ascensor is
    port(
	   motor: in std_logic_vector(1 downto 0);
       reset_n:in std_logic;
       bdentro,bfuera: in std_logic_vector(3 downto 0);
       clk3:in std_logic; --reloj para ir avanzando de piso
       
       piso:out std_logic_vector(2 downto 0);--piso al que quiero ir
       actual:out std_logic_vector(2 downto 0)--piso en el que estoy 
);
       
	
end ascensor;

architecture Behavioral of ascensor is

	signal p_act: std_logic_vector (2 downto 0); --asignación del piso cero por defecto
	
	begin
    piso_deseado:process(clk3,reset_n)
    	begin
       		if(reset_n='0')then
        		piso<="001";
          	elsif rising_edge(clk3) then
          		case bdentro or bfuera is --asigna el piso al que quiere ir
                  when "0001" => piso<= "001";
                  when "0010" => piso<= "010";
                  when "0100" => piso<= "011";
                  when "1000" => piso<= "100";

                  when others => piso<= "000";
           		end case;
          	end if;
          	
    end process piso_deseado;
    
    
    movimiento:process(motor,clk3,reset_n)
    	begin
        	if(reset_n='0')then
            	p_act<="001";
            elsif(rising_edge(clk3)) then
            
            	if(motor="01")then
                	p_act<=p_act-1;
                elsif(motor="10")then
                	p_act<=p_act+1;
                else
                	p_act<=p_act;
                end if;
                
           	end if;
            
    end process movimiento;
    
    actual<=p_act;
        
  
end Behavioral;
