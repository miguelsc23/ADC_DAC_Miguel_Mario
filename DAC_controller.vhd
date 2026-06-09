----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 07:53:22
-- Design Name: 
-- Module Name: DAC_controller - Behavioral
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
    
    entity DAC_controller is
        generic (
     SHIFT_ANCHO : integer := 4;   -- contador de bits 
        N_BITS_D    : integer := 12;  -- dato DAC
        N_BITS_SPI  : integer := 16;  -- trama SPI
        N_BITS_DIV  : integer := 16;  -- bits prescaler
        VAL_DIV     : integer := 4    -- divisor reloj 
      );
      port (
        clk50   : in  std_logic;
        nRST    : in  std_logic;  
    
        START   : in  std_logic;
        START2  : in  std_logic;
    
        DATA1   : in  std_logic_vector(N_BITS_D-1 downto 0);
    
        -- salidas a DAC
        D1      : out std_logic;
        CLK_OUT : out std_logic;
        nSYNC   : out std_logic;
        DONE    : out std_logic
      );
    end DAC_controller;
    
    architecture Behavioral of DAC_controller is
    
     --------------------------------------------------------------------
      -- PRESCALER
      --------------------------------------------------------------------
      signal div_count : unsigned(N_BITS_DIV-1 downto 0) := (others => '0');
      signal clkDiv    : std_logic := '1';
      signal fin_div   : std_logic;
    
      constant C_HALF_DIV : integer := VAL_DIV / 2;
    
      --------------------------------------------------------------------
      -- FSM 
      --------------------------------------------------------------------
      type state_type is (IDLE, SIFTOUT, SYNCDATA);
      signal state, next_state : state_type;
    
      signal shift_en   : std_logic;
      signal load_data  : std_logic;
    
      signal shift_cnt  : std_logic_vector(SHIFT_ANCHO-1 downto 0);
    
      constant C_FIN : std_logic_vector(SHIFT_ANCHO-1 downto 0) := (others => '1'); 
    
      --------------------------------------------------------------------
      -- SHIFT REGISTER
      --------------------------------------------------------------------
      signal spi_word : std_logic_vector(N_BITS_SPI-1 downto 0) := (others => '0');
      signal cnt_u    : unsigned(SHIFT_ANCHO-1 downto 0) := (others => '0');
    
    begin
    
     --------------------------------------------------------------------
      -- PRESCALER: clk50 -> clkDiv
      --------------------------------------------------------------------
      presc_p : process(clk50, nRST)
      begin
        if nRST = '0' then
          div_count <= (others => '0');
          clkDiv    <= '1';
        elsif rising_edge(clk50) then
          if fin_div = '1' then
            div_count <= (others => '0');
            clkDiv    <= not clkDiv;
          else
            div_count <= div_count + 1;
          end if;
        end if;
      end process;
    
     fin_div <= '1' when div_count = to_unsigned(C_HALF_DIV - 1, N_BITS_DIV) else '0';
    
    CLK_OUT <= clkDiv;
      --------------------------------------------------------------------
      -- FSM: secuencial
      --------------------------------------------------------------------
      proc_state : process(nRST, clkDiv)
      begin
        if nRST = '0' then
          state <= IDLE;
        elsif rising_edge(clkDiv) then
          state <= next_state;
        end if;
      end process proc_state;
    
      --------------------------------------------------------------------
      -- FSM: LOGICA DE TRANSICION
      --------------------------------------------------------------------
      proc_nextstate : process(state, START, START2, shift_cnt)
      begin
        next_state <= state;
    
        case state is
          when IDLE =>
            if START = '1' or START2 = '1' then
              next_state <= SIFTOUT;
            else
              next_state <= IDLE;
            end if;
    
          when SIFTOUT =>
            if shift_cnt = C_FIN then
              next_state <= SYNCDATA;
            else
              next_state <= SIFTOUT;
            end if;
    
          when SYNCDATA =>
            if START = '0' then
              next_state <= IDLE;
            end if;
    
          when others =>
            next_state <= IDLE;
        end case;
      end process proc_nextstate;
    
      --------------------------------------------------------------------
      -- FSM: combinacional
      --------------------------------------------------------------------
      proc_salidas : process(state)
      begin
        case state is
          when IDLE =>
            shift_en   <= '0';
            DONE       <= '1';
            nSYNC      <= '1';
            load_data  <= '1';
    
          when SIFTOUT =>
            shift_en   <= '1';
            DONE       <= '0';
            nSYNC      <= '0';
            load_data  <= '0';
    
          when SYNCDATA =>
            shift_en   <= '0';
            DONE       <= '0';
            nSYNC      <= '1';
            load_data  <= '0';
    
          when others =>
            shift_en   <= '0';
            DONE       <= '0';
            nSYNC      <= '1';
            load_data  <= '1';
        end case;
      end process proc_salidas;
     --------------------------------------------------------------------
      -- SHIFT REGISTER + CONTADOR 
      --------------------------------------------------------------------
      shreg_p : process(clkDiv, nRST)
      begin
        if nRST = '0' then
          spi_word <= (others => '0');
          cnt_u    <= (others => '0');
        elsif rising_edge(clkDiv) then
          if load_data = '1' then
            -- [15:12]=0 + [11:0]=DATA1
            spi_word(N_BITS_SPI-1 downto N_BITS_D) <= (others => '0');
            spi_word(N_BITS_D-1 downto 0)          <= DATA1;
            cnt_u <= (others => '0');
    
          elsif shift_en = '1' then
            -- shift MSB -> salida, metemos 0 por LSB
            spi_word(N_BITS_SPI-1 downto 1) <= spi_word(N_BITS_SPI-2 downto 0);
            spi_word(0) <= '0';
            cnt_u <= cnt_u + 1;
          end if;
        end if;
      end process;
    
      D1 <= spi_word(N_BITS_SPI-1);               -- MSB primero
      shift_cnt <= std_logic_vector(cnt_u);       -- hacia FSM
    
    
    end Behavioral;
