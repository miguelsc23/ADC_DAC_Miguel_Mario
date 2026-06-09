----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.02.2026 08:27:33
-- Design Name: 
-- Module Name: ADC_tb - Behavioral
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

entity ADC_tb is
--  Port ( );
end ADC_tb;

architecture Behavioral of ADC_tb is

component ADC is
    Port (
      D1_in     : in  STD_LOGIC;
      START     : in  STD_LOGIC;
      rst       : in  STD_LOGIC;
      clk_in    : in  STD_LOGIC;

      DRDY    : out STD_LOGIC;
      D1_out  : out STD_LOGIC_VECTOR (11 downto 0);
      clk_out : out STD_LOGIC;
      CS      : out STD_LOGIC
    );
  end component;

  signal D1_in   : STD_LOGIC:= '1';
  signal START   : STD_LOGIC:= '0';
  signal clk_in  : STD_LOGIC;
  signal rst     : STD_LOGIC:= '0';

  signal DRDY    : STD_LOGIC;
  signal clk_out : STD_LOGIC;
  signal CS      : STD_LOGIC;
  signal D1_out  : STD_LOGIC_VECTOR (11 downto 0);

begin

  UUT: ADC
    port map (
      D1_in   => D1_in,
      START   => START,
      rst     => rst,
      clk_in  => clk_in,
      DRDY    => DRDY,
      D1_out  => D1_out,
      clk_out => clk_out,
      CS      => CS
    );

  -- Reloj 200 MHz (igual que tu TB)
  GEN_CLK: process
  begin
    clk_in <= '1';
    wait for 2.5 ns; -- Ton
    clk_in <= '0';
    wait for 2.5 ns; -- Toff
  end process;

  -- Estímulos (igual que tu TB, con reset añadido)
  D1_in <= '0';

p_stim: process
begin
  rst <= '0';
  START <= '0';
  wait for 100 ns;

  rst <= '1';
  wait for 100 ns;

  START <= '1';

  wait;
end process;

end Behavioral;
