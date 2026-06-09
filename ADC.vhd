----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.02.2026 08:06:47
-- Design Name: 
-- Module Name: ADC - Behavioral
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

entity ADC is
 Port ( -- ENTRADAS
    D1_in     : in  STD_LOGIC;
    START     : in  STD_LOGIC;
    rst       : in  STD_LOGIC := '1';   -- FSM usa reset activo a '0'
    clk_in    : in  STD_LOGIC;          -- 200 MHz

    -- SALIDAS
    DRDY    : out STD_LOGIC;
    D1_out  : out STD_LOGIC_VECTOR (11 downto 0);
    clk_out : out STD_LOGIC;
    CS      : out STD_LOGIC );
end ADC;

architecture Behavioral of ADC is

 component Prescaler is
    generic (
      N_BITS  : integer;
      VAL_DIV : integer
    );
    Port (
      rst     : in  STD_LOGIC;
      clk_in  : in  STD_LOGIC;
      clk_out : out STD_LOGIC
    );
  end component;

  component SR_ADC is
    Port (
      clk       : in  STD_LOGIC;
      serial_in : in  STD_LOGIC;
      shift_en  : in  STD_LOGIC;
      data_out  : out STD_LOGIC_VECTOR (11 downto 0);
      bit_count : out STD_LOGIC_VECTOR (3 downto 0)
    );
  end component;

  component FSM_ADC is
    Port (
      clk_100 : in  STD_LOGIC;
      rst     : in  STD_LOGIC;  -- activo a '0' según tu FSM
      START   : in  STD_LOGIC;
      cntData : in  STD_LOGIC_VECTOR (3 downto 0);
      DRDY    : out STD_LOGIC;
      CS      : out STD_LOGIC;
      en_cnt  : out STD_LOGIC
    );
  end component;

  ----------------------------------------------------------------------------
  -- Señales internas
  ----------------------------------------------------------------------------
  signal clk_20     : STD_LOGIC;
  signal clk_100    : STD_LOGIC;

  signal en_shift   : STD_LOGIC;
  signal bit_cnt    : STD_LOGIC_VECTOR(3 downto 0);

begin

  ----------------------------------------------------------------------------
  -- Prescalers (clk_in = 200 MHz)
  ----------------------------------------------------------------------------
  PSC_20MHz: Prescaler
    generic map (
      N_BITS  => 4,
      VAL_DIV => 5          -- 200/10 = 20 MHz
    )
    port map (
      rst     => rst,
      clk_in  => clk_in,
      clk_out => clk_20
    );

  PSC_100MHz: Prescaler
    generic map (
      N_BITS  => 2,
      VAL_DIV => 1           -- 200/2 = 100 MHz
    )
    port map (
      rst     => rst,
      clk_in  => clk_in,
      clk_out => clk_100
    );

  ----------------------------------------------------------------------------
  -- Shift Register ADC (20 MHz)
  ----------------------------------------------------------------------------
  ShiftR_ADC: SR_ADC
    port map (
      clk       => clk_20,
      serial_in => D1_in,
      shift_en  => en_shift,
      data_out  => D1_out,
      bit_count => bit_cnt
    );

  ----------------------------------------------------------------------------
  -- FSM ADC (100 MHz)
  ----------------------------------------------------------------------------
  FSMach_ADC: FSM_ADC
    port map (
      clk_100 => clk_100,
      rst     => rst,        -- IMPORTANTE: tu FSM resetea con rst='0'
      START   => START,
      cntData => bit_cnt,
      DRDY    => DRDY,
      CS      => CS,
      en_cnt  => en_shift
    );

  ----------------------------------------------------------------------------
  -- Clock de salida hacia el ADC (SCLK)
  ----------------------------------------------------------------------------
  clk_out <= clk_20;


end Behavioral;
