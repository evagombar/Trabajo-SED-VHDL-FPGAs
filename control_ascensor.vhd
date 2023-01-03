library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use ieee.std_logic_arith.ALL;

use ieee.std_logic_unsigned.ALL;



entity control_ascensor is

    port(

        clk2:in std_logic; --maquina de estados

        reset_n: in std_logic;

        piso:in std_logic_vector(2 downto 0); --piso donde quiero ir 

        actual: in std_logic_vector(2 downto 0); --piso donde se encuentra el ascensor
        
        presencia:in std_logic;

        pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01

        aux: out std_logic; --habilitacion boton

        motorpuertas: out std_logic_vector(1 downto 0); --10=abriendo puertas, 01=cerrando puertas,00=parada de puertas

        motor: out std_logic_vector (1 downto 0) --movimiento del ascensor: "10"=subiendo, "01"=bajando, "00"=parada

    );

end control_ascensor;




architecture Behavioral of control_ascensor is




  type estados is (PARADA,ABRIENDO,CERRANDO,ESPERA,PAUSASEGURIDAD); --valora puertas

  signal ESTADO_ACT,ESTADO_SIG: estados;

  

  type estadosmotor is (PARADAM,SUBE,BAJA); --valora motor

  signal ESTADO_ACT_M,ESTADO_SIG_M: estadosmotor;







begin

	clockmotor: process(reset_n,clk2)
		begin

          if(reset_n='0') then

              ESTADO_ACT_M<=PARADAM;
             
    

          elsif (rising_edge(clk2)) then

              ESTADO_ACT_M<=ESTADO_SIG_M;

          end if;

	end process clockmotor;
	
	
	clockpuertas: process(reset_n,clk2, piso, actual)
		begin

          if(reset_n='0') then

	      ESTADO_ACT<=ESPERA;

          elsif (rising_edge(clk2)) then

              ESTADO_ACT<=ESTADO_SIG;

            

          end if;

	end process clockpuertas;


    maquina: process(ESTADO_ACT,pabierta_pcerrada,presencia,piso,actual)

	begin

	  case ESTADO_ACT is

		  when PARADA=>
            aux<='0';
        	motorpuertas<="00";
        
			    if(pabierta_pcerrada="01" and actual=piso) then 

				    ESTADO_SIG<=ABRIENDO; --apertura de puertas

			    else

				ESTADO_SIG<=PARADA; 

             end if;



		  when ABRIENDO=>

        	motorpuertas<="10";
        	aux<='0';

		    if(pabierta_pcerrada="10") then

				  ESTADO_SIG<=PAUSASEGURIDAD; --ascensor ha llegado a apertura completa

			  else

				  ESTADO_SIG<=ABRIENDO; 

			  end if;




		  when PAUSASEGURIDAD=>

      		motorpuertas<="00";

		
                if (presencia='0') then
				    ESTADO_SIG<=CERRANDO; --se cierran las puertas

			     else

                    ESTADO_SIG<=PAUSASEGURIDAD;
                 end if;

			




		  when CERRANDO=>

            motorpuertas<="01";
           aux<='0';

			if(presencia='1' and pabierta_pcerrada/="01")then --esta cerrando y nota presencia

				ESTADO_SIG<=ABRIENDO;

			elsif(pabierta_pcerrada="01") then

				ESTADO_SIG<=ESPERA;

			else

				ESTADO_SIG<=CERRANDO;

			end if;


         when ESPERA=>

            motorpuertas<="00";
            aux<='1';

			if(piso/=actual)then 

				ESTADO_SIG<=PARADA;

			else

				ESTADO_SIG<=ESPERA;

			end if;


      

	end case;

		

 end process maquina;

 

 maquinamotor:process(actual,piso,ESTADO_ACT_M)

 	begin

    	case ESTADO_ACT_M is

        	when PARADAM=>

            	motor<="00";

                if(actual< piso) then

                	ESTADO_SIG_M<=SUBE;

                elsif(actual>piso) then

                	ESTADO_SIG_M<=BAJA;

                else

                	ESTADO_SIG_M<=PARADAM;

             	end if;

           	when SUBE=>

            	motor<="10";

                if(actual= piso) then

                	ESTADO_SIG_M<=PARADAM;

                else

                	ESTADO_SIG_M<=SUBE;

                    

             	end if;

          	when BAJA=>

            	motor<="01";

                if(actual= piso) then

                	ESTADO_SIG_M<=PARADAM;

                else

                	ESTADO_SIG_M<=BAJA;

             	end if;

      	end case;

 end process maquinamotor;

end Behavioral;
