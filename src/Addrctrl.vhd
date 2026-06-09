----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 09:20:05
-- Design Name: 
-- Module Name: Addrctrl - Behavioral
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


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 09:20:05
-- Design Name: 
-- Module Name: Addrctrl - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Addrctrl is
  generic (
    ADDR_WIDTH : integer := 14
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    START_Reg : in  std_logic;
    DONE      : in  std_logic;
    addr_rd   : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    START     : out std_logic
  );
end Addrctrl;

architecture Behavioral of Addrctrl is

  signal done_ff1     : std_logic := '0';
  signal done_ff2     : std_logic := '0';
  signal active_run   : std_logic := '0';
  signal addr_counter : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');

  signal start_cnt    : unsigned(2 downto 0) := (others => '0');
  signal start_pulse  : std_logic := '0';

begin

  process(clk, rst)
  begin
    if rst = '0' then
      done_ff1     <= '0';
      done_ff2     <= '0';
      active_run   <= '0';
      addr_counter <= (others => '0');
      start_cnt    <= (others => '0');
      start_pulse  <= '0';

    elsif rising_edge(clk) then
      done_ff1 <= DONE;
      done_ff2 <= done_ff1;

      -- por defecto
--      start_pulse <= '0';

      -- mantener START varios ciclos mientras start_cnt > 0
--      if start_cnt /= 0 then
--        start_pulse <= '1';
--        start_cnt   <= start_cnt - 1;
--      end if;

--      if START_Reg = '0' then
--        active_run   <= '0';
--        addr_counter <= (others => '0');
--        start_cnt    <= (others => '0');
--        start_pulse  <= '0';

--      else
        -- primer arranque
--        if active_run = '0' then
--          active_run  <= '1';
--          start_cnt   <= "100";  -- 4 ciclos de clk50

--        -- siguiente muestra tras DONE
--        elsif (done_ff1 = '1' and done_ff2 = '0') then
        if (done_ff1 = '1' and done_ff2 = '0') then
          addr_counter <= addr_counter + 1;
          -- start_cnt    <= "100";  -- 4 ciclos de clk50
        end if;
--      end if;
    end if;
  end process;

  START   <= done_ff2; -- start_pulse;
  addr_rd <= std_logic_vector(addr_counter);

end Behavioral;

