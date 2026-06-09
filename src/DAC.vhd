----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 09:23:55
-- Design Name: 
-- Module Name: DAC - Behavioral
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

entity DAC is
  generic (
    -- DAC controller
    SHIFT_ANCHO : integer := 4;
    N_BITS_D    : integer := 12;
    N_BITS_SPI  : integer := 16;
    N_BITS_DIV  : integer := 16;
    VAL_DIV     : integer := 4;

    -- RAM / AddrCtrl
    ADDR_WIDTH  : integer := 14  -- 16384 muestras
  );
  port (
    clk50   : in  std_logic;
    nRST    : in  std_logic;

    -- Interfaz de escritura RAM (AXI o TB)
    wr_en   : in  std_logic;
    addr_wr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    data_in : in  std_logic_vector(N_BITS_D-1 downto 0);
   START_Reg : in  std_logic;

    -- Salidas DAC
    D1      : out std_logic;
    CLK_OUT : out std_logic;
    nSYNC   : out std_logic
  );
end DAC;

architecture Behavioral of DAC is

 --------------------------------------------------------------------
  -- Componentes
  --------------------------------------------------------------------
  component DAC_controller is
    generic (
      SHIFT_ANCHO : integer;
      N_BITS_D    : integer;
      N_BITS_SPI  : integer;
      N_BITS_DIV  : integer;
      VAL_DIV     : integer
    );
    port (
      clk50   : in  std_logic;
      nRST    : in  std_logic;
      START   : in  std_logic;
      START2  : in  std_logic;
      DATA1   : in  std_logic_vector(N_BITS_D-1 downto 0);
      D1      : out std_logic;
      CLK_OUT : out std_logic;
      nSYNC   : out std_logic;
      DONE    : out std_logic
    );
  end component;

  component Memoria_RAM is
    generic (
      d_width    : integer;
      addr_width : integer
    );
    port (
      clk      : in  std_logic;
      wr_en    : in  std_logic;
      addr_rd  : in  std_logic_vector(addr_width-1 downto 0);
      addr_wr  : in  std_logic_vector(addr_width-1 downto 0);
      data_in  : in  std_logic_vector(d_width-1 downto 0);
      data_out : out std_logic_vector(d_width-1 downto 0)
    );
  end component;

  component Addrctrl is
    generic (
      ADDR_WIDTH : integer
    );
    port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      DONE    : in  std_logic;
      addr_rd : out std_logic_vector(ADDR_WIDTH-1 downto 0);
      START   : out std_logic;
      START_Reg : in  std_logic  -- habilitación desde AXI
    );
  end component;

  --------------------------------------------------------------------
  -- Señales internas
  --------------------------------------------------------------------
  signal addr_rd_i   : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal data_dac    : std_logic_vector(N_BITS_D-1 downto 0);
  signal start_i     : std_logic;
  signal done_i      : std_logic;

begin

  --------------------------------------------------------------------
  -- AddrCtrl (TU BLOQUE)
  --------------------------------------------------------------------
  U_ADDRCTRL : Addrctrl
    generic map (
      ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
      clk     => clk50,
      rst     => nRST,
      DONE    => done_i,
      addr_rd => addr_rd_i,
      START_Reg => START_Reg,
      START   => start_i
    );

  --------------------------------------------------------------------
  -- RAM
  --------------------------------------------------------------------
  U_RAM : Memoria_RAM
    generic map (
      d_width    => N_BITS_D,
      addr_width => ADDR_WIDTH
    )
    port map (
      clk      => clk50,
      wr_en    => wr_en,
      addr_rd  => addr_rd_i,
      addr_wr  => addr_wr,
      data_in  => data_in,
      data_out => data_dac
    );

  --------------------------------------------------------------------
  -- DAC Controller
  --------------------------------------------------------------------
  U_DACCTRL : DAC_controller
    generic map (
      SHIFT_ANCHO => SHIFT_ANCHO,
      N_BITS_D    => N_BITS_D,
      N_BITS_SPI  => N_BITS_SPI,
      N_BITS_DIV  => N_BITS_DIV,
      VAL_DIV     => VAL_DIV
    )
    port map (
      clk50   => clk50,
      nRST    => nRST,
      START   => '0',
      START2  => START_Reg,
      DATA1   => data_dac,
      D1      => D1,
      CLK_OUT => CLK_OUT,
      nSYNC   => nSYNC,
      DONE    => done_i
    );



end Behavioral;
