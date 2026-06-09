----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2025 11:51:56
-- Design Name: 
-- Module Name: Direcciones - Behavioral
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

entity Direcciones is
    Port ( wr_en : out STD_LOGIC;
           data_in : out STD_LOGIC_VECTOR (11 downto 0);
           addr_wr : out STD_LOGIC_VECTOR (13 downto 0);
           START_Reg : out STD_LOGIC;
            val_reg0 : in std_logic_vector (31 downto 0);
            val_reg1: in std_logic_vector(31 downto 0);
            val_reg2: in std_logic_vector (31 downto 0);
            val_reg3 : in std_logic_vector(31 downto 0));
end Direcciones;

architecture Behavioral of Direcciones is

begin
  
  wr_en <= val_reg0(0);
  data_in <= val_reg1( 11 downto 0);
  addr_wr <= val_reg2( 13 downto 0);
  START_Reg <= val_reg3(0);

end Behavioral;