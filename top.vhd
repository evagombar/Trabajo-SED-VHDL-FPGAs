
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( 
       bfuera: in std_logic_vector(3 downto 0);
       bdentro: in std_logic_vector (3 downto 0);
	 
       presencia: in std_logic; --sensor que detecta la presencia
       pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01
	    
	    
       puerta_motor: out std_logic_vector (1 downto 0); --leds
       motor: out std_logic_vector (1 downto 0);--leds (motor de ascensor)

       reset:in std_logic;
       clk:in std_logic --clk general del programa
	    
    );
end top;

architecture Structural of top is
--señales que se asignan a los relojes del programa
	signal frec1:std_logic; --reloj con mayor frecuencia; apertura y cierre de puertas
	signal frec2:std_logic;
	signal frec3:std_logic; --reloj con menor frecuencia.

--señales 
	signal piso:std_logic_vector (2 downto 0); --piso a donde quiero ir
	signal pisoactual:std_logic_vector (2 downto 0); --piso en el que estoy
	
COMPONENT clockdivider
    GENERIC (frecuencia: integer := 50000000 );
    PORT ( 
        clock: in std_logic;
        reset: in std_logic;
        clk: out std_logic
        );

END COMPONENT;

COMPONENT ascensor
	PORT(
		motor: in std_logic_vector(1 downto 0);
		presencia: in std_logic;
		pabierta_pcerrada: in std_logic_vector(1 downto 0);
		bdentro, bfuera: in std_logic_vector(3 downto 0);
		piso:out std_logic_vector(2 downto 0);
		motorpuertas: out std_logic_vector(1 downto 0);
		reset,clk,clk1,clk2: in std_logic	
	);	
	
END COMPONENT;
	
COMPONENT control_ascensor
	PORT(
		clk,reset:in std_logic;
		piso:in std_logic_vector (2 downto 0);
		actual: out std_logic_vector (2 downto 0);
		motor: out std_logic_vector (1 downto 0)	
	);
END COMPONENT;
	
COMPONENT pisos
	PORT(
		piso:out std_logic_vector (2 downto 0);
		bdentro, bfuera: in std_logic_vector(3 downto 0);
		clk: in std_logic	
	);
END COMPONENT;
	

begin
	clock1:clockdivider 
		GENERIC MAP (frecuencia=>150000000 ) --150MHz
   		PORT MAP ( 
        		clock=>clk,
        		reset=>reset,
       			 clk=>frec1
        	);
		
	clock2:clockdivider 
		GENERIC MAP (frecuencia=>100000000 ) --100MHz
   		PORT MAP ( 
        		clock=>clk,
        		reset=>reset,
       			 clk=>frec2
        	);
		
	clock3:clockdivider 
		GENERIC MAP (frecuencia=>100000 ) --100KHz
   		PORT MAP ( 
        		clock=>clk,
        		reset=>reset,
       			 clk=>frec3
        	);
	mpuertas:maquinapuertas
		PORT MAP(
			motor=> motor,
			presencia=> presencia,
			pabierta_pcerrada=> pabierta_pcerrada,
			bdentro=>bdentro, 
			bfuera=>bfuera,
			motorpuertas=> puerta_motor,
			reset=> reset,
			clk1=>frec1,
			clk2=>frec2
		);
	
	pactual:pisoactual
		PORT MAP(
			clk=> frec3,
			reset=> reset,
			piso=>piso,
			actual=>pisoactual,
			motor=>motor --motor del ascensor
		);
		
	pisos1:pisos
		PORT MAP (
			piso=>piso,
			bdentro=>bdentro,
			bfuera=>bfuera,
			clk=>frec3	
		);

end Structural;
