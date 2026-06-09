----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2026 10:25:46
-- Design Name: 
-- Module Name: signal_analizer - Behavioral
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

entity signal_analizer is
    Port (
           -- ENTRADAS
           clk_in  : in STD_LOGIC;
           rst     : in STD_LOGIC;
           DRDY    : in STD_LOGIC;
           D1_out  : in STD_LOGIC_VECTOR(11 downto 0);

           -- SALIDAS
           T          : out STD_LOGIC_VECTOR (31 downto 0);
           sum_acum   : out STD_LOGIC_VECTOR (31 downto 0);
           max_found  : out STD_LOGIC
    );
end signal_analizer;

architecture Behavioral of signal_analizer is

--------------------------------------------------------------------
-- COMPONENTES
--------------------------------------------------------------------

component Data_counter is
    Port (
           DRDY    : in STD_LOGIC;
           clk_in  : in STD_LOGIC;
           rst_cnt : in STD_LOGIC;

           cnt     : out STD_LOGIC_VECTOR (31 downto 0)
    );
end component;

component Max_finder is
    Port (
           D1_out   : in STD_LOGIC_VECTOR (11 downto 0);
           DRDY     : in STD_LOGIC;
           clk_in   : in STD_LOGIC;
           cnt      : in STD_LOGIC_VECTOR (31 downto 0);

           max_found : out STD_LOGIC
    );
end component;

component Calc_param is
    Port (
           D1_out    : in STD_LOGIC_VECTOR (11 downto 0);
           max_found : in STD_LOGIC;
           clk       : in STD_LOGIC;
           DRDY      : in STD_LOGIC;
           cnt       : in STD_LOGIC_VECTOR (31 downto 0);

           T         : out STD_LOGIC_VECTOR (31 downto 0);
           sum_acum  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end component;

component Prescaler is
    generic (
        N_BITS  : integer;
        VAL_DIV : integer
    );

    Port (
        rst     : in STD_LOGIC;
        clk_in  : in STD_LOGIC;
        clk_out : out STD_LOGIC
    );
end component;

--------------------------------------------------------------------
-- SEÑALES INTERNAS
--------------------------------------------------------------------

signal conect_max_found : STD_LOGIC;
signal clk_100          : STD_LOGIC;

signal conect_cnt : STD_LOGIC_VECTOR (31 downto 0);

begin

--------------------------------------------------------------------
-- CONTADOR DE MUESTRAS
--------------------------------------------------------------------

conta_Data: Data_counter
port map (
    DRDY    => DRDY,
    clk_in  => clk_100,
    rst_cnt => conect_max_found,
    cnt     => conect_cnt
);

--------------------------------------------------------------------
-- DETECTOR DE MÁXIMOS
--------------------------------------------------------------------

max_F: Max_finder
port map (
    D1_out    => D1_out,
    DRDY      => DRDY,
    clk_in    => clk_100,
    cnt       => conect_cnt,
    max_found => conect_max_found
);

--------------------------------------------------------------------
-- CÁLCULO DE PARÁMETROS
--------------------------------------------------------------------

vmed_frec: Calc_param
port map (
    D1_out    => D1_out,
    clk       => clk_100,
    max_found => conect_max_found,
    DRDY      => DRDY,
    cnt       => conect_cnt,
    T         => T,
    sum_acum  => sum_acum
);

--------------------------------------------------------------------
-- PRESCALER 200 MHz -> 100 MHz
--------------------------------------------------------------------

PSC_100MHz: Prescaler
generic map (
    N_BITS  => 2,
    VAL_DIV => 2
)
port map (
    rst     => rst,
    clk_in  => clk_in,
    clk_out => clk_100
);

--------------------------------------------------------------------
-- SALIDA DEBUG
--------------------------------------------------------------------

max_found <= conect_max_found;

end Behavioral;