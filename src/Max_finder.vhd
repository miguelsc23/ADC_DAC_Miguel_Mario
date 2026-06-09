----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2026 10:21:43
-- Design Name: 
-- Module Name: Max_finder - Behavioral
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

entity Max_finder is
    Port (
           -- ENTRADAS
           D1_out   : in STD_LOGIC_VECTOR (11 downto 0);
           DRDY     : in STD_LOGIC;
           clk_in   : in STD_LOGIC;
           cnt      : in STD_LOGIC_VECTOR (31 downto 0);

           -- SALIDAS
           max_found : out STD_LOGIC
    );
end Max_finder;

architecture Behavioral of Max_finder is

    signal Data_max_ABS : unsigned (11 downto 0) := (others => '0');
    signal cnt_max      : unsigned (31 downto 0) := (others => '0');

    signal cond_max     : STD_LOGIC := '0';
    signal condicion_d  : std_logic := '0';

    signal err          : unsigned(11 downto 0) := (others => '0');

    -- Detección de flanco de subida de DRDY
    signal drdy_d : std_logic := '0';

    constant tol      : unsigned(11 downto 0) := to_unsigned(10, 12);

    -- Para simulación puedes bajarlo temporalmente
    constant cnt_min  : unsigned(31 downto 0) := to_unsigned(1000, 32);

    constant time_max : unsigned(31 downto 0) := to_unsigned(10, 32);

begin

MAX: process(clk_in)
begin
    if rising_edge(clk_in) then

        drdy_d <= DRDY;

        -- Una sola vez por muestra válida
        if DRDY = '1' and drdy_d = '0' then

            -- Guarda máximo detectado
            if unsigned(D1_out) > Data_max_ABS then
                Data_max_ABS <= unsigned(D1_out);
            end if;

            -- Error absoluto respecto al máximo
            if unsigned(D1_out) > Data_max_ABS then
                err <= unsigned(D1_out) - Data_max_ABS;
            else
                err <= Data_max_ABS - unsigned(D1_out);
            end if;

            -- Número de muestras próximas al máximo
            if err < tol then
                cnt_max <= cnt_max + 1;
            else
                cnt_max <= (others => '0');
            end if;

            -- Condición de máximo detectado
            if (err < tol) and (unsigned(cnt) > cnt_min) then
                cond_max <= '1';
            else
                cond_max <= '0';
            end if;

        end if;

    end if;
end process;

--------------------------------------------------------------------
-- Genera pulso de un ciclo
--------------------------------------------------------------------
one_pulse: process(clk_in)
begin
    if rising_edge(clk_in) then

        condicion_d <= cond_max;

        if (cond_max = '1' and condicion_d = '0') then
            max_found <= '1';
        else
            max_found <= '0';
        end if;

    end if;
end process;

end Behavioral;
