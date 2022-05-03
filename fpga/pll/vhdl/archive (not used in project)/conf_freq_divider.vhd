----------------------------------------------------------------------------------
--! @file conf_freq_divider.vhd
--! @author Felix Tebbenjohanns
--! @date 17.10.2018
----------------------------------------------------------------------------------


--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;


library work;


--! Divides a digittal input frequency by a configurable amount.

entity conf_freq_divider is
  generic (
    N : integer := 32
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    Threshold_DI : in std_logic_vector(N-1 downto 0);

    In_DI  : in  std_logic;
    Out_DO : out std_logic

    );
end conf_freq_divider;

architecture Behavioral of conf_freq_divider is

  signal Out_DN, Out_DP         : std_logic;
  signal LastIn_DN, LastIn_DP   : std_logic;
  signal Counter_SN, Counter_SP : std_logic_vector(N-1 downto 0);

begin

  Out_DO <= Out_DP;

  process(Counter_SP, In_DI, LastIn_DP, Out_DP, Threshold_DI)
  begin
    Counter_SN <= Counter_SP;
    Out_DN     <= Out_DP;
    LastIn_DN  <= In_DI;

    if LastIn_DP = '0' and In_DI = '1' then  -- rising edge
      if unsigned(Counter_SP) = unsigned(Threshold_DI) then
        Counter_SN <= (others => '0');
        Out_DN     <= not Out_DP;
      else
        Counter_SN <= std_logic_vector(unsigned(Counter_SP) + 1);
      end if;
    end if;
  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        Counter_SP <= (others => '0');
        Out_DP     <= '0';
        LastIn_DP  <= '0';
      else
        Counter_SP <= Counter_SN;
        Out_DP     <= Out_DN;
        LastIn_DP  <= LastIn_DN;
      end if;
    end if;
  end process;

end Behavioral;
