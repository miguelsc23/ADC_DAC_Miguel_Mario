----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.02.2026 07:49:16
-- Design Name: 
-- Module Name: shift_reg_adc - Behavioral
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

entity SR_ADC is           
  Port (
    -- ENTRADAS
    clk        : in  STD_LOGIC;  -- reloj 20 MHz (SCLK)
    serial_in  : in  STD_LOGIC;  -- dato serie del ADC
    shift_en   : in  STD_LOGIC;  -- habilita el desplazamiento

    -- SALIDAS
    data_out   : out STD_LOGIC_VECTOR (11 downto 0); -- dato ADC paralelo
    bit_count  : out STD_LOGIC_VECTOR (3 downto 0)   -- número de bits desplazados
  );
end SR_ADC;

architecture Behavioral of SR_ADC is

  -- Registro de desplazamiento serie ? paralelo (16 bits)
  signal shift_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

  -- Contador de bits desplazados
  signal bit_cnt_i : unsigned(3 downto 0) := (others => '0');

begin

  p_shift_register : process (clk)
  begin
    if rising_edge(clk) then
      if shift_en = '1' then
        -- desplazamiento
        shift_reg(15 downto 1) <= shift_reg(14 downto 0);
        shift_reg(0) <= serial_in;

        -- cuando se han recibido 16 bits
        if bit_cnt_i = "1111" then
          data_out <= shift_reg(11 downto 0); -- 12 bits útiles
        end if;

        bit_cnt_i <= bit_cnt_i + 1;

      else
        bit_cnt_i <= (others => '0');
      end if;
    end if;
  end process;

  bit_count <= STD_LOGIC_VECTOR(bit_cnt_i);

end Behavioral;