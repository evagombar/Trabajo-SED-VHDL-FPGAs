----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2022 10:41:57
-- Design Name: 
-- Module Name: control_motor - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_motor is
    Port ( 
        motor: out std_logic_vector (1 downto 0); -- 10=subiendo,01=bajando ,00=parada
        bfuera: in std_logic_vector(3 downto 0);
	    bdentro: in std_logic_vector (3 downto 0);
	    piso:inout std_logic_vector(3 downto 0)
    );
end control_motor;

architecture Behavioral of control_motor is

begin
motormov:process(bdentro, bfuera, piso)
begin
    if(bdentro=piso or bfuera=piso) then
        motor<="00"; --motor parado
        
    elsif(bdentro>piso or bfuera>piso) then
        motor<="10"; --motor subiendo
       
    else
        motor<="01"; --motor bajando
     
    end if;
 end process motormov;

end Behavioral;
