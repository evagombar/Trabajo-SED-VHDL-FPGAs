library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pisoactual is
    port(
        clk:in std_logic;
        reset: in std_logic;
        piso:in std_logic_vector(2 downto 0); --piso donde quiero ir (viene de bloque pisos)->binario
        actual: out std_logic_vector(2 downto 0); --piso donde se encuentra el ascensor->binario
        motor: out std_logic_vector (1 downto 0) --movimiento del ascensor: "10"=subiendo, "01"=bajando, "00"=parada
    );
end pisoactual;

architecture Behavioral of pisoactual is
  signal p_act: std_logic_vector (2 downto 0):="001"; --asignación del piso cero por defecto

begin
    valoracion_piso:process(clk)
    begin
      if reset='0' then
        if rising_edge(clk) then
           if piso>p_act and p_act<"100" then --puede subir solo hasta el piso 4
             p_act<=p_act+1;
             motor<="10"; --motor subiendo
          
          elsif piso<p_act and p_act>"001" then --puede bajar solo hasta el piso 1
             p_act<=p_act-1;
             motor <="01"; --motor bajando
          else 
            p_act<=piso; 
            motor<="00"; --motor parado
            
          end if;
        end if;
      else 
        p_act<="001"; --si se resetea el piso por defecto es el 1
      end if;
     --AÑADIR LEDs y mirar asignación
      
     end process valoracion_piso;
   actual<=p_act;

end Behavioral;
