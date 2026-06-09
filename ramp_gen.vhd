----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2026 10:42:02
-- Design Name: 
-- Module Name: ramp_gen - Behavioral
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

entity ramp_gen is
    Port (
           clk_200M : in  STD_LOGIC;
           rst      : in  STD_LOGIC;
           Data_out : out STD_LOGIC_VECTOR (11 downto 0)
    );
end ramp_gen;

architecture Behavioral of ramp_gen is

    signal cuenta_actual : unsigned (11 downto 0) := (others => '0');

begin

    process(clk_200M)
    begin
        if rising_edge(clk_200M) then
            if rst = '0' then
                cuenta_actual <= (others => '0');
            else
                if cuenta_actual = 4095 then
                    cuenta_actual <= (others => '0');
                else
                    cuenta_actual <= cuenta_actual + 1;
                end if;
            end if;
        end if;
    end process;

    Data_out <= std_logic_vector(cuenta_actual);

end Behavioral;

