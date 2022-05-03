----------------------------------------------------------------------------------
--! @file reg_buffer.vhd
--! @author Felix Tebbenjohanns
--! @date 17.7.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;


library work;


entity reg_buffer is
  generic (
    N : integer := 16
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    A_DI : in std_logic_vector(N-1 downto 0);

    B_DO : out std_logic_vector(N-1 downto 0)

    );
end reg_buffer;

architecture Behavioral of reg_buffer is
begin
  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        B_DO <= (others => '0');
      else
        B_DO <= A_DI;
      end if;
    end if;
  end process;

end Behavioral;
