----------------------------------------------------------------------------------
--! @file mult_limit.vhd
--! @author Felix Tebbenjohanns
--! @date 16.7.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;


library work;


entity mult_limit is
  generic (
    N_IN    : integer := 16;
    N_OUT   : integer := 16;
    LOG_DIV : integer := 8
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    A_DI      : in std_logic_vector(N_IN-1 downto 0);
    B_DI      : in std_logic_vector(N_IN-1 downto 0);
    ValidA_SI : in std_logic;
    ValidB_SI : in std_logic;

    C_DO     : out std_logic_vector(N_OUT-1 downto 0);
    Valid_SO : out std_logic

    );
end mult_limit;

architecture Behavioral of mult_limit is

  signal A_DP, A_DN : std_logic_vector(N_IN-1 downto 0);
  signal B_DP, B_DN : std_logic_vector(N_IN-1 downto 0);
  signal C_DN, C_DP : std_logic_vector(N_OUT - 1 downto 0);
begin
  A_DN <= A_DI when ValidA_SI = '1' else A_DP;
  B_DN <= B_DI when ValidB_SI = '1' else B_DP;

  C_DO     <= C_DP;
  Valid_SO <= '1';

  process(A_DP, B_DP)
    variable prod_long : std_logic_vector(2*N_IN-1 downto 0);
    constant MAX       : std_logic_vector(N_OUT-1 downto 0) := (N_OUT-1 => '0', others => '1');
    constant min       : std_logic_vector(N_OUT-1 downto 0) := (N_OUT-1 => '1', others => '0');
  begin

    prod_long := std_logic_vector(signed(A_DP) * signed(B_DP) / (2**LOG_DIV));


    if (signed(prod_long) > signed(MAX)) then
      C_DN <= MAX;
    elsif (signed(prod_long) < signed(min)) then
      C_DN <= min;
    else
      C_DN <= std_logic_vector(resize(signed(prod_long), N_OUT));
    end if;

  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        A_DP <= (others => '0');
        B_DP <= (others => '0');
        C_DP <= (others => '0');
      else
        A_DP <= A_DN;
        B_DP <= B_DN;
        C_DP <= C_DN;
      end if;
    end if;
  end process;

end Behavioral;
