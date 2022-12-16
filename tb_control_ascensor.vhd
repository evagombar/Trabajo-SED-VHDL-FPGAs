library ieee;
use ieee.std_logic_1164.all;

entity tb_control_ascensor is
end tb_control_ascensor;

architecture tb of tb_control_ascensor is

    component control_ascensor
        port (clk1              : in std_logic;
              clk2              : in std_logic;
              reset_n           : in std_logic;
              piso              : in std_logic_vector (2 downto 0);
              actual            : in std_logic_vector (2 downto 0);
              presencia         : in std_logic;
              pabierta_pcerrada : in std_logic_vector (1 downto 0);
              motorpuertas      : out std_logic_vector (1 downto 0);
              motor             : out std_logic_vector (1 downto 0));
    end component;

    signal clk1              : std_logic;
    signal clk2              : std_logic;
    signal reset_n           : std_logic;
    signal piso              : std_logic_vector (2 downto 0);
    signal actual            : std_logic_vector (2 downto 0);
    signal presencia         : std_logic;
    signal pabierta_pcerrada : std_logic_vector (1 downto 0);
    signal motorpuertas      : std_logic_vector (1 downto 0);
    signal motor             : std_logic_vector (1 downto 0);

    constant TbPeriod1 : time := 100 ns; -- EDIT Put right period here
    constant TbPeriod2 : time := 6.66 ns; -- EDIT Put right period here

    signal TbClock1 : std_logic := '0';

    signal TbClock2 : std_logic := '0';


begin

    dut : control_ascensor
    port map (clk1              => clk1,
              clk2              => clk2,
              reset_n           => reset_n,
              piso              => piso,
              actual            => actual,
              presencia         => presencia,
              pabierta_pcerrada => pabierta_pcerrada,
              motorpuertas      => motorpuertas,
              motor             => motor);

    -- Clock generation
    TbClock1 <= not TbClock1 after TbPeriod1/2 ;
   TbClock2 <= not TbClock2 after TbPeriod2/2 ;

    -- EDIT: Check that clk1 is really your main clock signal
  clk1 <= TbClock1;
  clk2 <= TbClock2;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        
        piso <= (others => '0');
        actual <= (others => '0');
        presencia <= '0';
        pabierta_pcerrada <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;
      
        -- EDIT Add stimuli here
      piso<= "100";
      actual<="100";
      pabierta_pcerrada <="01";
      wait for 2 * TbPeriod2;
      pabierta_pcerrada <="10";
      wait for 2 * TbPeriod2;
      presencia<='0';
      wait for 15 * TbPeriod2;
      pabierta_pcerrada <="00";
      presencia<='1';
      
      

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_control_ascensor of tb_control_ascensor is
    for tb
    end for;
end cfg_tb_control_ascensor;
