----------------------------------------------------------------------------------
--! @file delay_line.vhd
--! @author Felix Tebbenjohanns
--! @date 31.8.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;


library work;


entity delay_line is
  generic (
    N             : integer := 16;
    LOG_MAX_DELAY : integer := 4
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    Delay_SI : in std_logic_vector(LOG_MAX_DELAY -1 downto 0);

    A_DI     : in std_logic_vector(N-1 downto 0);
    Valid_SI : in std_logic;

    C_DO     : out std_logic_vector(N-1 downto 0);
    Valid_SO : out std_logic

    );
end delay_line;

architecture Behavioral of delay_line is

  type DELAY_TYPE is array (0 to 2**LOG_MAX_DELAY-1) of std_logic_vector(N-1 downto 0);
  signal DelayLine_DP, DelayLine_DN : DELAY_TYPE;

--signal Valid_SP, Valid_SN : std_logic;
begin

  C_DO     <= DelayLine_DP(to_integer(unsigned(Delay_SI)));
  --Valid_SO <= Valid_SP;

  process(A_DI, DelayLine_DP, Valid_SI)
  begin
    DelayLine_DN <= DelayLine_DP;
    Valid_SO     <= '0';

    if Valid_SI = '1' then
      DelayLine_DN(0)                       <= A_DI;
      DelayLine_DN(1 to 2**LOG_MAX_DELAY-1) <= DelayLine_DP(0 to 2**LOG_MAX_DELAY-2);
      Valid_SO                              <= '1';
    end if;
  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        DelayLine_DP <= (others => (others => '0'));
      --Valid_SP     <= '0';
      else
        DelayLine_DP <= DelayLine_DN;
      --Valid_SP     <= Valid_SN;
      end if;
    end if;
  end process;

end Behavioral;
