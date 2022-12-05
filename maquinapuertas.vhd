  --mirar si hay que asignar un estado inicial
--HACER TEMPORIZADOR TEMP1
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity maquinapuertas is
    port(
	   motor: in std_logic_vector(1 downto 0);
	   presencia: in std_logic; --sensor que detecta la presencia
	   pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01
     bdentro,bfuera: in std_logic_vector(3 downto 0); 
     motorpuertas: out std_logic_vector(1 downto 0); --10=abriendo puertas, 01=cerrando puertas,00=parada de puertas

	   reset:in std_logic;
	   clk1:in std_logic; --reloj para pasar de estado
	    clk2:in std_logic --reloj espera de seguridad de cerrar puertas
);
	
end maquinapuertas;

architecture Behavioral of maquinapuertas is
   type estados is (PARADA,ABRIENDO,CERRANDO,PAUSASEGURIDAD,ESPERABOTON);
   signal ESTADO_ACT,ESTADO_SIG: estados;

begin

clock: process(reset,clk1)
	begin
		if(reset='1') then
			ESTADO_ACT<=PARADA;
		elsif (rising_edge(clk1)) then
			ESTADO_ACT<=ESTADO_SIG;
		end if;
end process clock;

maquina: process(ESTADO_ACT,motor,pabierta_pcerrada,presencia,bdentro,bfuera,clk2)
	begin
	  case ESTADO_ACT is
		  when PARADA=>
        motorpuertas<="00";
			  if(pabierta_cerrada="01" and motor="00") then
				  ESTADO_SIG<=ABRIENDO; --apertura de puertas
			  else
				ESTADO_SIG<=PARADA; 
        end if;


		  when ABRIENDO=>
        motorpuertas<="10";
		    if(pabierta_cerrada="10") then
				  ESTADO_SIG<=PAUSASEGURIDAD; --ascensor ha llegado a destino
			  else
				  ESTADO_SIG<=ABRIENDO; --ascensor sigue en movimiento
			  end if;

		  when PAUSASEGURIDAD=>
      motorpuertas<="00";
			if(presencia='0' and rising_edge(clk2))then --puerta esta abierta, no hay presencia y ha pasado el tiempo de seguridad
				ESTADO_SIG<=CERRANDO; --se cierran las puertas
			else
				ESTADO_SIG<=ABRIENDO;
			end if;

		  when CERRANDO=>
      motorpuertas<="01";
			if(presencia='1' and pabierta_pcerrada/="01")then --está cerrando y nota presencia
				ESTADO_SIG<=ABRIENDO;
			elsif(pabierta_pcerrada="01") then
				ESTADO_SIG<=ESPERABOTON;
			else
				ESTADO_SIG<=CERRANDO;
			end if;
        
      when ESPERABOTON=>
        motorpuertas<="00";
			if(bdentro/="0000" or bfuera/="0000") then --se pulsa un botón
				ESTADO_SIG<=PARADA;
      else
        ESTADO_SIG<=ESPERABOTON;
      end if;
	end case;
		
 end process maquina;

end Behavioral;
