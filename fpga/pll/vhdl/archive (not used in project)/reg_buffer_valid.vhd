----------------------------------------------------------------------------------
--! @file reg_buffer_valid.vhd
--! @author Felix Tebbenjohanns
--! @date 30.8.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;


library work;


entity reg_buffer_valid is 
  generic (
    N : integer := 16
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    A_DI : in std_logic_vector(N-1 downto 0);
    Valid_SI: in std_logic;

    B_DO : out std_logic_vector(N-1 downto 0)

    );
end reg_buffer_valid;

architecture Behavioral of reg_buffer_valid is
signal B_DP, B_DN : std_logic_vector(N-1 downto 0);
begin
   B_DN <= A_DI when Valid_SI = '1' else B_DP;
   B_DO <= B_DP;

  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        B_DP <= (others => '0');
      else
        B_DP <= B_DN;
      end if;
    end if;
  end process;

end Behavioral;
