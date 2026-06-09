----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2026 11:34:25
-- Design Name: 
-- Module Name: ADC_controller - Behavioral
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

entity FSM_ADC is
  Port (
    clk_100 : in  STD_LOGIC;
    rst     : in  STD_LOGIC;     -- reset activo a '0'
    START   : in  STD_LOGIC;
    cntData : in  STD_LOGIC_VECTOR (3 downto 0);

    DRDY    : out STD_LOGIC;
    CS      : out STD_LOGIC;
    en_cnt  : out STD_LOGIC
  );
end FSM_ADC;

architecture Behavioral of FSM_ADC is

  type t_state is (HOLD, FPORCH, SHIFTING, BPORCH);
  signal state_reg, state_next : t_state;

  signal bit_cnt   : STD_LOGIC_VECTOR(3 downto 0);
  signal porch_cnt : UNSIGNED(1 downto 0) := "00";
  signal sync_cnt  : UNSIGNED(2 downto 0) := "000";

begin

  bit_cnt <= cntData;

  -- 1) Registro de estado
  p_state_reg : process(clk_100, rst)
  begin
    if rst = '0' then
      state_reg <= HOLD;
    elsif rising_edge(clk_100) then
      state_reg <= state_next;
    end if;
  end process;

  -- 2) Lógica combinacional de próxima transición + salidas
  p_fsm_comb : process(state_reg, START, bit_cnt, porch_cnt, sync_cnt)
  begin
    -- valores por defecto
    CS       <= '0';
    DRDY     <= '1';
    en_cnt   <= '0';
    state_next <= state_reg;

    case state_reg is

      when HOLD =>
        CS     <= '1';
        DRDY   <= '0';
        en_cnt <= '0';
        if START = '1' then
          state_next <= FPORCH;
        end if;

      when FPORCH =>
        CS     <= '0';
        DRDY   <= '0';
        en_cnt <= '0';
        if porch_cnt = "11" then
          state_next <= SHIFTING;
        end if;

      when SHIFTING =>
        CS     <= '0';
        DRDY   <= '0';
        en_cnt <= '1';
        if (bit_cnt = "1111") and (sync_cnt = "100") then --(sync_cnt = "100")
          state_next <= BPORCH;
        end if;

      when BPORCH =>
        CS     <= '0';
        DRDY   <= '1';
        en_cnt <= '0';

        if porch_cnt = "01" then
          state_next <= HOLD;
        end if;

      when others =>
        state_next <= HOLD;

    end case;
  end process;

  -- 3) Contadores (temporización)
  p_counters : process(clk_100, rst)
  begin
    if rst = '0' then
      porch_cnt <= "00";
      sync_cnt  <= "000";
    elsif rising_edge(clk_100) then
      case state_reg is

        when FPORCH =>
          porch_cnt <= porch_cnt + 1;
          sync_cnt  <= "000";

        when SHIFTING =>
          if bit_cnt = "1111" then
            sync_cnt <= sync_cnt + 1;
          end if;

        when BPORCH =>
          porch_cnt <= porch_cnt + 1;

        when others =>
          porch_cnt <= "00";
          sync_cnt  <= "000";

      end case;
    end if;
  end process;

end Behavioral;
