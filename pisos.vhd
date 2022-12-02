----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2022 10:00:42
-- Design Name: 
-- Module Name: pisos - Behavioral
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

entity pisos is
    port(
        clk:in std_logic;
        bdentro:in std_logic_vector(3 downto 0);
        bfuera:in std_logic_vector(3 downto 0);
        piso:out std_logic_vector(2 downto 0) --piso donde quiero ir
    );
end pisos;

architecture Behavioral of pisos is
begin
    movimiento_pisos:process(clk)
    begin
        if rising_edge(clk) then
            case bdentro or bfuera is
                when "0001" => piso<= "001";
                when "0010" => piso<= "010";
                when "0100" => piso<= "011";
                when "1000" => piso<= "100";
            end case;
        end if;
     end process movimiento_pisos;

end Behavioral;
