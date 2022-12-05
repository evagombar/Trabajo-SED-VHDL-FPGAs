
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
	   
	   piso:inout std_logic_vector(3 downto 0);
	   
	   presencia: in std_logic; --sensor que detecta la presencia
	   pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01
       puerta_motor: out std_logic_vector (1 downto 0);
       
       motor: out std_logic_vector (1 downto 0);

	   reset:in std_logic;
	   clk:in std_logic
    );
end top;

architecture Behavioral of top is

begin


end Behavioral;
