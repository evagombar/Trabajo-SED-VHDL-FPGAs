library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;


entity top is
    port ( 
    	reset_n:in std_logic;
    	clk:in std_logic --clk general del programa
        
      	bfuera: in std_logic_vector(3 downto 0);
      	bdentro: in std_logic_vector (3 downto 0);
	 
       presencia: in std_logic; --sensor que detecta la presencia
       pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01
	   
       puerta_motor: out std_logic_vector (1 downto 0); --leds
       motor: inout std_logic_vector (1 downto 0);--leds (motor de ascensor)

       
	    
    );
end top;

architecture Structural of top is

--señales que se asignan a los relojes del programa
	signal frec1:std_logic; --reloj con menor frecuencia; apertura y cierre de puertas
	signal frec2:std_logic;--reloj con mayor frecuencia; maquinas de estados
	signal frec3:std_logic; --reloj con frecuencia intermedia;avanzar piso

--señales 
	signal piso:std_logic_vector (2 downto 0); --piso a donde quiero ir
	signal pisoactual:std_logic_vector (2 downto 0); --piso en el que estoy
	
COMPONENT clockdivider
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
      bdentro,bfuera: in std_logic_vector(3 downto 0);
      clk3:in std_logic; --reloj para ir avanzando de piso
       
      piso:out std_logic_vector(2 downto 0);--piso al que quiero ir
      actual:out std_logic_vector(2 downto 0)--piso en el que estoy 
	);	
	
END COMPONENT;
	
COMPONENT control_ascensor
	PORT(
		clk1:in std_logic; --cierre de puertas
        clk2:in std_logic; --maquina de estados
        reset_n: in std_logic;
        piso:in std_logic_vector(2 downto 0); --piso donde quiero ir (viene de bloque pisos)->binario
        actual: in std_logic_vector(2 downto 0); --piso donde se encuentra el ascensor->binario
        presencia:in std_logic;
        pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01
        
        motorpuertas: out std_logic_vector(1 downto 0); --10=abriendo puertas, 01=cerrando puertas,00=parada de puertas
        motor: out std_logic_vector (1 downto 0); --movimiento del ascensor: "10"=subiendo, "01"=bajando, "00"=parada	
        led:out std_logic_vector (6 downto 0) --display
	);
END COMPONENT;

COMPONENT display
	PORT(
    	reset_n : in std_logic;
        clk3 : in std_logic;  
        piso_actual : in std_logic_vector (2 downto 0);
        led : out STD_LOGIC_VECTOR (6 downto 0)
   	);
END COMPONENT;

	
	
begin

	clock1:clockdivider 
		GENERIC MAP (frecuencia=>10000000 ) --10MHz 
   		PORT MAP ( 
        		clock=>clk,
        		reset_n=>reset_n,
       			 clk=>frec1
        	);
		
	clock2:clockdivider 
		GENERIC MAP (frecuencia=>150000000 ) --150MHz 150000000
   		PORT MAP ( 
        		clock=>clk,
        		reset_n=>reset_n,
       			 clk=>frec2
        	);
		
	clock3:clockdivider 
		GENERIC MAP (frecuencia=>100000000 ) --100MHz
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
          bdentro=>bdentro,
          bfuera=>bfuera,
          clk3=>frec3,

          piso=>piso,
          actual=>pisoactual
			
		);
	
	c_ascensor:control_ascensor
		PORT MAP(
          clk1=>frec1,
          clk2=>frec2,
          reset_n=>rest_n,
          piso=>piso,
          actual=>pisoactual,
          presencia=>presencia,
          pabierta_pcerrada=>pabierta_pcerrada,
          motorpuertas=>motorpuertas,
          motor=>motor
		);
		
end Structural;
