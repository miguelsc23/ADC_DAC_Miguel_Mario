----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2026 10:43:45
-- Design Name: 
-- Module Name: signal_analizer_tb - Behavioral
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

entity signal_analizer_tb is
end signal_analizer_tb;

architecture Behavioral of signal_analizer_tb is

component signal_analizer is
    Port (
           clk_in    : in STD_LOGIC;
           rst       : in STD_LOGIC;
           DRDY      : in STD_LOGIC;
           D1_out    : in STD_LOGIC_VECTOR(11 downto 0);

           T         : out STD_LOGIC_VECTOR (31 downto 0);
           sum_acum  : out STD_LOGIC_VECTOR (31 downto 0);
           max_found : out STD_LOGIC
    );
end component;

component ramp_gen is
    Port (
           clk_200M : in  STD_LOGIC;
           rst      : in  STD_LOGIC;
           Data_out : out STD_LOGIC_VECTOR (11 downto 0)
    );
end component;

signal clk_in    : STD_LOGIC := '0';
signal rst       : STD_LOGIC := '0';
signal DRDY      : STD_LOGIC := '0';

signal Data_ramp : STD_LOGIC_VECTOR (11 downto 0);
signal T         : STD_LOGIC_VECTOR (31 downto 0);
signal sum_acum  : STD_LOGIC_VECTOR (31 downto 0);
signal max_found : STD_LOGIC;

begin

SA: signal_analizer
    port map (
        clk_in    => clk_in,
        rst       => rst,
        DRDY      => DRDY,
        D1_out    => Data_ramp,
        T         => T,
        sum_acum  => sum_acum,
        max_found => max_found
    );

RG: ramp_gen
    port map (
        clk_200M => clk_in,
        rst      => rst,
        Data_out => Data_ramp
    );

GEN_CLK: process
begin
    clk_in <= '1';
    wait for 2.5 ns;
    clk_in <= '0';
    wait for 2.5 ns;
end process;

RESET_GEN: process
begin
    rst <= '0';
    wait for 100 ns;
    rst <= '1';
    wait;
end process;

DRDY_GEN: process
begin
    wait for 120 ns;

    while true loop
        DRDY <= '1';
        wait for 10 ns;
        DRDY <= '0';
        wait for 840 ns;
    end loop;
end process;

end Behavioral;
