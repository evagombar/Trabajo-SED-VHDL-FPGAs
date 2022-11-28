library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity maq1 is
    port(
    	bfuera: in std_logic_vector(3 downto 0);
	bdentro: in std_logic_vector (3 downto 0);
	piso:out std_logic_vector(3 downto 0);
	puerta: in std_logic_vector (1 downto 0); --10=pabierta, 01=pcerrada
	presencia: in std_logic;

	reset:in std_logic;
	clk:in std_logic;
	
	motor: out std_logic_vector (1 downto 0) -- 10=subiendo,01=bajando ,00=parada
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


maquina: process(ESTADO_ACT,bdentro,bfuera,puerta)
	begin
	case ESTADO_ACT is
		when PARADA=>
		    motor<="00";
			if(bfuera=piso or bdentro=piso) then
				ESTADO_SIG<=ABRIR; --ascensor está en el piso que quiero

			elsif(bfuera/="0000" or bdentro/="0000" ) then
				ESTADO_SIG<=MOV; --ascensor se mueve al piso del boton pulsado
			
			else
				ESTADO_SIG<=PARADA;
			end if;


		when MOV=>
--!!!!!!!!!!!!!!!!motor subiendo o bajando!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			if(bfuera=piso or bdentro=piso) then
				ESTADO_SIG<=PARADA; --ascensor ha llegado a destino
			else
				ESTADO_SIG<=MOV; --ascensor sigue en movimiento
			end if;

		when ABRIR=>
		    motor<="00";
			if(presencia='0' and puerta="10")then --puerta esta abierta y no hay presencia
				ESTADO_SIG<=CERRAR; --se cierran las puertas
			else
				ESTADO_SIG<=ABRIR;
			end if;

		when CERRAR=>
		    motor<="00";
			if(bdentro="0000" and puerta="01")then --bdentro='0000' es que no se ha pulsado ninguna botón
				ESTADO_SIG<=PARADA;
			elsif(bdentro/=piso and puerta="01") then
				ESTADO_SIG<=MOV;
			else
				ESTADO_SIG<=CERRAR;
			end if;
	end case;

end process maquina;



end Behavioral;
