library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use ieee.std_logic_arith.ALL;

use ieee.std_logic_unsigned.ALL;


entity top is

    port ( 

    	reset_n:in std_logic;

    	clk:in std_logic; --clk general del programa

        

      	boton: in std_logic_vector(3 downto 0);

	   aux: inout std_logic; --habilitacion boton

       presencia: in std_logic; --sensor que detecta la presencia

       pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01

	
       puerta_motor: out std_logic_vector (1 downto 0); 

       motor: inout std_logic_vector (1 downto 0);
       
        
       led: out std_logic_vector (6 downto 0) --display

    );

end top;




architecture Structural of top is

--senales
    

	signal frec2:std_logic;--reloj con menor frecuencia; maquinas de estados

	signal frec3:std_logic; --reloj con mayor frecuencia;avanzar piso


	signal piso:std_logic_vector (2 downto 0); --piso a donde quiero ir

	signal pisoactual:std_logic_vector (2 downto 0); --piso en el que estoy

	

COMPONENT clk_divider

    GENERIC (frecuencia: integer := 50000000 );

    PORT ( 

        clock: in std_logic;

        reset_n: in std_logic;

        clk: out std_logic

        );




END COMPONENT;




COMPONENT ascensor

	PORT(

      motor: in std_logic_vector(1 downto 0);

       reset_n:in std_logic;

       boton: in std_logic_vector(3 downto 0);

       clk3:in std_logic; --reloj para ir avanzando de piso

       aux: in std_logic;

       piso:out std_logic_vector(2 downto 0);--piso al que quiero ir

       actual:out std_logic_vector(2 downto 0)--piso en el que estoy 

	);	

	

END COMPONENT;

	

COMPONENT control_ascensor

	PORT(

        clk2:in std_logic; --maquina de estados

        reset_n: in std_logic;

        piso:in std_logic_vector(2 downto 0); --piso donde quiero ir

        actual: in std_logic_vector(2 downto 0); --piso donde se encuentra el ascensor

        presencia:in std_logic;

        pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01

        aux: out std_logic;

        motorpuertas: out std_logic_vector(1 downto 0); --10=abriendo puertas, 01=cerrando puertas,00=parada de puertas

        motor: out std_logic_vector (1 downto 0) 

	);

END COMPONENT;




COMPONENT display

	PORT(

    	reset_n : in std_logic;

        clk3 : in std_logic;  
       

        piso_actual : in std_logic_vector (2 downto 0);
        

        led : out std_logic_vector (6 downto 0)

   	);

END COMPONENT;



begin


	clock2:clk_divider 

		GENERIC MAP (frecuencia=>100000000 ) --100MHz 

   		PORT MAP ( 

        		clock=>clk,

        		reset_n=>reset_n,

       			 clk=>frec2

        	);

		

	clock3:clk_divider 

		GENERIC MAP (frecuencia=>150000000 ) --150MHz

   		PORT MAP ( 

        		clock=>clk,

        		reset_n=>reset_n,

       			 clk=>frec3

        	);

            

    display1:display

    	PORT MAP(

          reset_n=>reset_n,

          clk3=>frec3,  
          
          piso_actual=>pisoactual,
          
       

          led=>led
        );

	ascensor1:ascensor

		PORT MAP(

          motor=>motor,

          reset_n=>reset_n,

          boton=>boton,

          aux=>aux,

          clk3=>frec3,

          piso=>piso,

          actual=>pisoactual

		);

	

	c_ascensor:control_ascensor

		PORT MAP(

          clk2=>frec2,

          reset_n=>reset_n,

          piso=>piso,

          actual=>pisoactual,

          presencia=>presencia,

          pabierta_pcerrada=>pabierta_pcerrada,

          motorpuertas=>puerta_motor ,
          
          aux=>aux,

          motor=>motor

		);

		

end Structural;

		
