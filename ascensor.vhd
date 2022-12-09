
architecture Behavioral of pisos is
begin
    piso_deseado:process(clk)
    begin
        if rising_edge(clk) then
            case bdentro or bfuera is
                when "0001" => piso<= "001";
                when "0010" => piso<= "010";
                when "0100" => piso<= "011";
                when "1000" => piso<= "100";
            end case;
        end if;
     end process piso_deseado;

end Behavioral;
