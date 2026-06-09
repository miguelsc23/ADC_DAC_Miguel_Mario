----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2026 12:20:37
-- Design Name: 
-- Module Name: FSM_ADC_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_ADC_tb is
--  Port ( );
end FSM_ADC_tb;

architecture sim of FSM_ADC_tb is

  -- DUT signals
  signal clk_100 : std_logic := '0';
  signal rst     : std_logic := '0';  -- activo a '0'
  signal START   : std_logic := '0';
  signal cntData : std_logic_vector(3 downto 0) := (others => '0');

  signal DRDY    : std_logic;
  signal CS      : std_logic;
  signal en_cnt  : std_logic;

 constant CLK100_PERIOD : time := 10 ns;  -- 100 MHz
  constant TICK20_PERIOD : time := 50 ns;  -- 20 MHz


  -- helper: ciclo contador de bits
  signal bit_cnt_u : unsigned(3 downto 0) := (others => '0');

begin

  -- Clock generation
  clk_100 <= not clk_100 after CLK100_PERIOD/2;

  -- Instantiate DUT
  uut: entity work.FSM_ADC
    port map (
      clk_100 => clk_100,
      rst     => rst,
      START   => START,
      cntData => cntData,
      DRDY    => DRDY,
      CS      => CS,
      en_cnt  => en_cnt
    );

  --------------------------------------------------------------------------
  -- Stimulus
  --------------------------------------------------------------------------
--------------------------------------------------------------------------
  -- Estímulos: reset + START periódico
  --------------------------------------------------------------------------
  p_stim : process
  begin
    rst <= '0';
    wait for 100 ns;
    rst <= '1';

    while true loop
      wait for 300 ns;
      START <= '1';
      wait for CLK100_PERIOD; -- 1 ciclo a 100 MHz
      START <= '0';
    end loop;
  end process;

  --------------------------------------------------------------------------
  -- Contador de bits a 20 MHz (tick) -> genera cntData = 0..15
  -- Cuenta SOLO cuando en_cnt='1' (SHIFTING).
  --------------------------------------------------------------------------
  p_cnt_20mhz : process
  begin
    wait for TICK20_PERIOD/2; -- para centrar los cambios
    while true loop
      wait for TICK20_PERIOD; -- tick cada 50 ns (20 MHz)

      if rst = '0' then
        bit_cnt_u <= (others => '0');
      else
        if en_cnt = '1' then
          bit_cnt_u <= bit_cnt_u + 1;  -- wrap automático 0..15
        else
          bit_cnt_u <= (others => '0');
        end if;
      end if;
    end loop;
  end process;

  cntData <= std_logic_vector(bit_cnt_u);
end architecture;