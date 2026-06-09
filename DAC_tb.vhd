library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DAC_tb is
end DAC_tb;

architecture Behavioral of DAC_tb is

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

  constant C_ADDR_WIDTH : integer := 14;
  constant C_DATA_BITS  : integer := 12;

  signal clk50     : std_logic := '0';
  signal nRST      : std_logic := '0';
  signal wr_en     : std_logic := '0';
  signal addr_wr   : std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal data_in   : std_logic_vector(C_DATA_BITS-1 downto 0) := (others => '0');
  signal START_Reg : std_logic := '0';

  signal D1        : std_logic;
  signal CLK_OUT   : std_logic;
  signal nSYNC     : std_logic;

begin

  -- Instancia del DUT
  UUT : DAC
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

  -- Reloj 50 MHz
  clk_gen : process
  begin
    clk50 <= '0';
    wait for 10 ns;
    clk50 <= '1';
    wait for 10 ns;
  end process;

  -- Estímulos
  stim : process
  begin
    -- Reset activo
    nRST <= '0';
    wr_en <= '0';
    START_Reg <= '0';
    wait for 40 ns;

    -- Escribir algunas muestras en RAM
    addr_wr <= std_logic_vector(to_unsigned(0, C_ADDR_WIDTH));
    data_in <= "000000000000";
    wr_en   <= '1';
    wait until rising_edge(clk50);
    wr_en   <= '0';
    wait until rising_edge(clk50);

    addr_wr <= std_logic_vector(to_unsigned(1, C_ADDR_WIDTH));
    data_in <= "111111110000";
    wr_en   <= '1';
    wait until rising_edge(clk50);
    wr_en   <= '0';
    wait until rising_edge(clk50);

    addr_wr <= std_logic_vector(to_unsigned(2, C_ADDR_WIDTH));
    data_in <= "101010101010";
    wr_en   <= '1';
    wait until rising_edge(clk50);
    wr_en   <= '0';
    wait until rising_edge(clk50);

    -- Quitar reset
    nRST <= '1';
    wait until rising_edge(clk50);

    -- Arrancar DAC
    START_Reg <= '1';

    -- Esperar para ver la transmisión
    wait for 20 us;

    wait;
  end process;

end Behavioral;