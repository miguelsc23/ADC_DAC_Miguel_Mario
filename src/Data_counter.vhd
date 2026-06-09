----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2026 10:19:01
-- Design Name: 
-- Module Name: Data_counter - Behavioral
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

entity Data_counter is
    Port (
           -- ENTRADAS
           DRDY    : in STD_LOGIC;
           clk_in  : in STD_LOGIC;
           rst_cnt : in STD_LOGIC;

           -- SALIDAS
           cnt     : out STD_LOGIC_VECTOR (31 downto 0)
    );
end Data_counter;

architecture Behavioral of Data_counter is

    signal cuenta_actual : unsigned (31 downto 0) := (others => '0');

    -- Detección de flanco de subida de DRDY
    signal drdy_d : std_logic := '0';

begin

counter: process(clk_in)
begin
    if rising_edge(clk_in) then

        -- Guarda valor anterior de DRDY
        drdy_d <= DRDY;

        -- Reset contador
        if rst_cnt = '1' then

            cuenta_actual <= (others => '0');

        -- Cuenta una sola vez por muestra ADC válida
        elsif (DRDY = '1' and drdy_d = '0') then

            cuenta_actual <= cuenta_actual + 1;

        end if;

    end if;
end process;

    cnt <= std_logic_vector(cuenta_actual);

end Behavioral;


