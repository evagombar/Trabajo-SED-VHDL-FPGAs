library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ascensor is
    port(
	   motor: in std_logic_vector(1 downto 0);
	   presencia: in std_logic; --sensor que detecta la presencia
	   pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01
           bdentro,bfuera: in std_logic_vector(3 downto 0); 
           motorpuertas: out std_logic_vector(1 downto 0); --10=abriendo puertas, 01=cerrando puertas,00=parada de puertas
	   piso:out std_logic_vector(2 downto 0);--piso al que quiero ir 

	   reset_n:in std_logic;
	   clk:in std_logic;--reloj para determinar el piso al que quiero ir
	   clk1:in std_logic; --reloj para pasar de estado
	   clk2:in std_logic --reloj espera de seguridad de cerrar puertas
);
	
end ascensor;

architecture Behavioral of ascensor is
   type estados is (PARADA,ABRIENDO,CERRANDO,PAUSASEGURIDAD,ESPERABOTON);
   signal ESTADO_ACT,ESTADO_SIG: estados;

begin

clock: process(reset_n,clk1)
	begin
		if(reset_n='1') then
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
			  if(pabierta_pcerrada="01" and motor="00") then
				  ESTADO_SIG<=ABRIENDO; --apertura de puertas
			  else
				ESTADO_SIG<=PARADA; 
        end if;


		  when ABRIENDO=>
        motorpuertas<="10";
		    if(pabierta_pcerrada="10") then
				  ESTADO_SIG<=PAUSASEGURIDAD; --ascensor ha llegado a destino
			  else
				  ESTADO_SIG<=ABRIENDO; --ascensor sigue en movimiento
			  end if;

		  when PAUSASEGURIDAD=>
      motorpuertas<="00";
			if(presencia='0' and rising_edge(clk2))then --puerta esta abierta, no hay presencia y ha pasado el tiempo de seguridad
				ESTADO_SIG<=CERRANDO; --se cierran las puertas
			else
				ESTADO_SIG<=PAUSASEGURIDAD;
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

    piso_deseado:process(clk, motor)
    begin
        if rising_edge(clk) then
		if (motor="00") then --solo hace caso al botón si el  motor del ascensor está parado
		    case bdentro or bfuera is
			when "0001" => piso<= "001";
			when "0010" => piso<= "010";
			when "0100" => piso<= "011";
			when "1000" => piso<= "100";
	         	when others => piso<= "000";
		    end case;
		end if;
        end if;
     end process piso_deseado;

end Behavioral;
