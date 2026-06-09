----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 08:38:30
-- Design Name: 
-- Module Name: DAC_controller_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity DAC_tb is
end DAC_tb;

architecture tb of DAC_tb is

  --------------------------------------------------------------------
  -- Constantes
  --------------------------------------------------------------------
  constant SHIFT_ANCHO : integer := 4;
  constant N_BITS_D    : integer := 12;
  constant N_BITS_SPI  : integer := 16;
  constant N_BITS_DIV  : integer := 16;
  constant VAL_DIV     : integer := 4;
  constant ADDR_WIDTH  : integer := 14;

  --------------------------------------------------------------------
  -- Componente DAC completo
  --------------------------------------------------------------------
  component DAC is
    generic (
      SHIFT_ANCHO : integer := 4;
      N_BITS_D    : integer := 12;
      N_BITS_SPI  : integer := 16;
      N_BITS_DIV  : integer := 16;
      VAL_DIV     : integer := 4;
      ADDR_WIDTH  : integer := 14
    );
    port (
      clk50     : in  std_logic;
      nRST      : in  std_logic;

      wr_en     : in  std_logic;
      addr_wr   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
      data_in   : in  std_logic_vector(N_BITS_D-1 downto 0);
      START_Reg : in  std_logic;

      D1        : out std_logic;
      CLK_OUT   : out std_logic;
      nSYNC     : out std_logic
    );
  end component;

  --------------------------------------------------------------------
  -- Señales del testbench
  --------------------------------------------------------------------
  signal clk50     : std_logic := '0';
  signal nRST      : std_logic := '0';

  signal wr_en     : std_logic := '0';
  signal addr_wr   : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
  signal data_in   : std_logic_vector(N_BITS_D-1 downto 0) := (others => '0');
  signal START_Reg : std_logic := '0';

  signal D1        : std_logic;
  signal CLK_OUT   : std_logic;
  signal nSYNC     : std_logic;

begin

  --------------------------------------------------------------------
  -- Instancia del DAC completo
  --------------------------------------------------------------------
  UUT : DAC
    generic map (
      SHIFT_ANCHO => SHIFT_ANCHO,
      N_BITS_D    => N_BITS_D,
      N_BITS_SPI  => N_BITS_SPI,
      N_BITS_DIV  => N_BITS_DIV,
      VAL_DIV     => VAL_DIV,
      ADDR_WIDTH  => ADDR_WIDTH
    )
    port map (
      clk50     => clk50,
      nRST      => nRST,
      wr_en     => wr_en,
      addr_wr   => addr_wr,
      data_in   => data_in,
      START_Reg => START_Reg,
      D1        => D1,
      CLK_OUT   => CLK_OUT,
      nSYNC     => nSYNC
    );

  --------------------------------------------------------------------
  -- Reloj de 50 MHz
  --------------------------------------------------------------------
  clk_process : process
  begin
    clk50 <= '0';
    wait for 10 ns;
    clk50 <= '1';
    wait for 10 ns;
  end process;

  --------------------------------------------------------------------
  -- Proceso de estímulos
  --------------------------------------------------------------------
  stim_process : process
  begin

    ------------------------------------------------------------------
    -- 1. Reset inicial
    ------------------------------------------------------------------
    nRST      <= '0';
    wr_en     <= '0';
    addr_wr   <= (others => '0');
    data_in   <= (others => '0');
    START_Reg <= '0';

    wait for 200 ns;

    nRST <= '1';

    wait for 100 ns;

    ------------------------------------------------------------------
    -- 2. Cargar la RAM
    ------------------------------------------------------------------

    -- Dirección 0
    addr_wr <= std_logic_vector(to_unsigned(0, ADDR_WIDTH));
    data_in <= x"000";
    wr_en   <= '1';
    wait for 20 ns;
    wr_en   <= '0';
    wait for 20 ns;

    -- Dirección 1
    addr_wr <= std_logic_vector(to_unsigned(1, ADDR_WIDTH));
    data_in <= x"111";
    wr_en   <= '1';
    wait for 20 ns;
    wr_en   <= '0';
    wait for 20 ns;

    -- Dirección 2
    addr_wr <= std_logic_vector(to_unsigned(2, ADDR_WIDTH));
    data_in <= x"222";
    wr_en   <= '1';
    wait for 20 ns;
    wr_en   <= '0';
    wait for 20 ns;

    -- Dirección 3
    addr_wr <= std_logic_vector(to_unsigned(3, ADDR_WIDTH));
    data_in <= x"333";
    wr_en   <= '1';
    wait for 20 ns;
    wr_en   <= '0';
    wait for 20 ns;

    -- Dirección 4
    addr_wr <= std_logic_vector(to_unsigned(4, ADDR_WIDTH));
    data_in <= x"444";
    wr_en   <= '1';
    wait for 20 ns;
    wr_en   <= '0';
    wait for 20 ns;

    -- Dirección 5
    addr_wr <= std_logic_vector(to_unsigned(5, ADDR_WIDTH));
    data_in <= x"555";
    wr_en   <= '1';
    wait for 20 ns;
    wr_en   <= '0';
    wait for 20 ns;

    -- Dirección 6
    addr_wr <= std_logic_vector(to_unsigned(6, ADDR_WIDTH));
    data_in <= x"666";
    wr_en   <= '1';
    wait for 20 ns;
    wr_en   <= '0';
    wait for 20 ns;

    -- Dirección 7
    addr_wr <= std_logic_vector(to_unsigned(7, ADDR_WIDTH));
    data_in <= x"777";
    wr_en   <= '1';
    wait for 20 ns;
    wr_en   <= '0';
    wait for 20 ns;

    ------------------------------------------------------------------
    -- 3. RAM cargada
    ------------------------------------------------------------------
    wait for 200 ns;

    ------------------------------------------------------------------
    -- 4. Arrancar el DAC
    ------------------------------------------------------------------
    START_Reg <= '1';

    ------------------------------------------------------------------
    -- 5. Dejar que el DAC vaya leyendo la RAM
    ------------------------------------------------------------------
    wait for 30 us;

    ------------------------------------------------------------------
    -- 6. Parar simulación
    ------------------------------------------------------------------
    assert false report "Fin de simulacion DAC completo con RAM cargada" severity failure;

  end process;

end tb;
