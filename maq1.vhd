----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2022 09:51:48
-- Design Name: 
-- Module Name: maq1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity maq1 is
    port(
       bfuera: in std_logic_vector(3 downto 0);
	   bdentro: in std_logic_vector (3 downto 0);
	   piso:inout std_logic_vector(3 downto 0);
	   presencia: in std_logic; --sensor que detecta la presencia
	   pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01

	   reset:in std_logic;
	   clk:in std_logic
	
	   
);
	
end maq1;

architecture Behavioral of maq1 is
   type estados is (PARADA,MOV,ABRIR,CERRAR);
   signal ESTADO_ACT,ESTADO_SIG: estados;

begin

clock: process(reset,clk)
	begin
		if(reset='1') then
			ESTADO_ACT<=PARADA;
		elsif (rising_edge(clk)) then
			ESTADO_ACT<=ESTADO_SIG;
		end if;
end process clock;


maquina: process(ESTADO_ACT,bdentro,bfuera,pabierta_pcerrada, presencia,piso)
	begin
	case ESTADO_ACT is
		when PARADA=>
			if(bfuera=piso or bdentro=piso) then
				ESTADO_SIG<=ABRIR; --ascensor está en el piso que quiero

			elsif(bfuera/="0000" or bdentro/="0000" ) then
				ESTADO_SIG<=MOV; --ascensor se mueve al piso del boton pulsado
			
			else
				ESTADO_SIG<=PARADA;
			end if;


		when MOV=>
		    if(bfuera=piso or bdentro=piso) then
				ESTADO_SIG<=PARADA; --ascensor ha llegado a destino
			else
				ESTADO_SIG<=MOV; --ascensor sigue en movimiento
			end if;

		when ABRIR=>
			if(presencia='0' and pabierta_pcerrada="10")then --puerta esta abierta y no hay presencia
				ESTADO_SIG<=CERRAR; --se cierran las puertas
			else
				ESTADO_SIG<=ABRIR;
			end if;

		when CERRAR=>
			if(bdentro="0000" and pabierta_pcerrada="01")then --bdentro='0000' es que no se ha pulsado ningun botón
				ESTADO_SIG<=PARADA;
			elsif(bdentro/=piso and pabierta_pcerrada="01") then
				ESTADO_SIG<=MOV;
			elsif(presencia='1' and pabierta_pcerrada/="01") then --la puerta no se ha cerrado completamente y nota presencia
				ESTADO_SIG<=ABRIR;
			else
				ESTADO_SIG<=CERRAR;
			end if;
	end case;

end process maquina;

end Behavioral;
