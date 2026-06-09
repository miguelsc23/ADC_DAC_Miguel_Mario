----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2026 09:13:41
-- Design Name: 
-- Module Name: Calc_param - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Calc_param is
    Port (
           -- ENTRADAS
           D1_out    : in STD_LOGIC_VECTOR (11 downto 0);
           max_found : in STD_LOGIC;
           clk       : in STD_LOGIC;
           DRDY      : in STD_LOGIC;
           cnt       : in STD_LOGIC_VECTOR (31 downto 0);

           -- SALIDAS
           T         : out STD_LOGIC_VECTOR (31 downto 0);
           sum_acum  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end Calc_param;

architecture Behavioral of Calc_param is

  signal sum : unsigned (31 downto 0) := (others => '0');
signal u16_Data : unsigned (11 downto 0);
  -- Señales para detección de flancos
  signal drdy_d      : std_logic := '0';
  signal max_found_d : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then

            drdy_d      <= DRDY;
            max_found_d <= max_found;

            -- Suma una vez por cada muestra válida del ADC
            if DRDY = '1' and drdy_d = '0' then
                sum <= sum + unsigned(D1_out);
            end if;

            -- Cuando se detecta máximo, guarda suma y contador
            if max_found = '1' and max_found_d = '0' then
                sum_acum <= std_logic_vector(sum);
                T        <= cnt;

                sum <= (others => '0');
            end if;

        end if;
    end process;

end Behavioral;