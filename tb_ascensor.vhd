library ieee;
use ieee.std_logic_1164.all;

entity tb_ascensor is
end tb_ascensor;

architecture tb of tb_ascensor is

    component ascensor
        port (
        	  motor             : in std_logic_vector (1 downto 0);
              bdentro           : in std_logic_vector (3 downto 0);
              bfuera            : in std_logic_vector (3 downto 0);
              piso              : out std_logic_vector (2 downto 0);
             actual:out std_logic_vector(2 downto 0);--piso en el que estoy 
              reset_n             : in std_logic;
              clk3             : in std_logic
        );
    end component;

    signal motor             : std_logic_vector (1 downto 0);
    signal bdentro           : std_logic_vector (3 downto 0);
    signal bfuera            : std_logic_vector (3 downto 0);
    signal piso              : std_logic_vector (2 downto 0);
    signal actual              : std_logic_vector (2 downto 0);
    signal reset_n             : std_logic;
    signal clk3              : std_logic;

    constant TbPeriod3 : time := 10 ns; -- EDIT Put right period here
    signal TbClock3 : std_logic := '0';
  
begin

    dut : ascensor
    port map (motor             => motor,
              bdentro           => bdentro,
              bfuera            => bfuera,
              piso              => piso,
              reset_n             => reset_n,
               actual              => actual,
              clk3              => clk3);

    -- Clock generation
    TbClock3 <= not TbClock3 after TbPeriod3/2 ;
    

    -- EDIT: Check that clk is really your main clock signal
    clk3 <= TbClock3;


    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        motor <= (others => '0');
        bdentro <= (others => '0');
        bfuera <= (others => '0');
    

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        bfuera<="0100";
        motor<="10";
        
        
        wait for 100 * TbPeriod3;

        -- Stop the clock and hence terminate the simulation
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_ascensor of tb_ascensor is
    for tb
    end for;
end cfg_tb_ascensor;
