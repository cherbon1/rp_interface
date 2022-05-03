----------------------------------------------------------------------------------
--! @file exp_avg_filter.vhd
--! @author Felix Tebbenjohanns
--! @date 13.7.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


library work;


entity exp_avg_filter is
  generic(
    N       : integer;
    N_ALPHA : integer
    );
  port (
    Xn_DI   : in std_logic_vector(N-1 downto 0);
    Ynm1_DI : in std_logic_vector(N-1 downto 0);

    Yn_DO : out std_logic_vector(N-1 downto 0);

    Alpha_DI : in std_logic_vector(N_ALPHA-1 downto 0)

    );
end exp_avg_filter;

architecture Behavioral of exp_avg_filter is

begin

  process(Alpha_DI, Xn_DI, Ynm1_DI)
    variable xn_long, ynm1_long, prod, yn_long : signed(N downto 0);
  begin

    xn_long   := resize(signed(Xn_DI), xn_long'length);
    ynm1_long := resize(signed(Ynm1_DI), ynm1_long'length);

    prod := resize(signed("0" & Alpha_DI) * (ynm1_long - xn_long) / (2**N_ALPHA), prod'length);

    yn_long := xn_long + prod;

    Yn_DO <= std_logic_vector(resize(yn_long, N));  -- this resize should always work, because the result should fit into N bits.
  end process;


end Behavioral;
