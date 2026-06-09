----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.02.2026 08:15:54
-- Design Name: 
-- Module Name: Prescaler - Behavioral
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

entity Prescaler is
generic (
    N_BITS  : integer := 3;   -- bits del contador
    VAL_DIV : integer := 10   -- factor de división
  );
  port (
    rst     : in  STD_LOGIC;  -- reset activo a '0'
    clk_in  : in  STD_LOGIC;  -- reloj de entrada
    clk_out : out STD_LOGIC   -- reloj dividido
  );
end Prescaler;

architecture Behavioral of Prescaler is


  signal cnt      : unsigned(N_BITS-1 downto 0) := (others => '0');
  signal clk_div  : std_logic := '0';

begin

  process(clk_in, rst)
  begin
    if rst = '0' then
      cnt     <= (others => '0');
      clk_div <= '0';
    elsif rising_edge(clk_in) then
      if cnt = VAL_DIV-1 then
        cnt     <= (others => '0');
        clk_div <= not clk_div;
      else
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  clk_out <= clk_div;

end Behavioral;
