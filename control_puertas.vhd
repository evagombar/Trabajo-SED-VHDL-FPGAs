----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2022 10:51:11
-- Design Name: 
-- Module Name: control_puertas - Behavioral
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

entity control_puertas is
    Port ( 
        clk:in std_logic;
    
        pabierta_pcerrada: in std_logic_vector(1 downto 0); --sensor detecta puerta abierta 10, o puerta cerrada 01
        puerta_motor: out std_logic_vector (1 downto 0); --10=abriendo puertas, 01=cerrando puertas
	    presencia: in std_logic --sensor que detecta la presencia
    );
end control_puertas;

architecture Behavioral of control_puertas is
begin
puertasmov:process(clk)
begin
    if rising_edge(clk) then
        if motor="00" then --primero comprueba que el ascensor está parado
            if pabierta_pcerrada="10" and presencia='0' then--puerta abierta y sin presencia
                puerta_motor<="01"; --puerta cerrando
            elsif pabierta_pcerrada="01" then
                puerta_motor<="10"; --puerta abriendo
            else
                puerta_motor<="00"; --puerta sin movimiento
            end if;
         else
            puerta_motor<="00";
         end if;
     end if;
 end process puertasmov;    
end Behavioral;
