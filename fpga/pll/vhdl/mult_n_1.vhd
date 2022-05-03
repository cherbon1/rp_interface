----------------------------------------------------------------------------------
--! @file mult_n_1.vhd
--! @author Felix Tebbenjohanns
--! @date 2.7.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library work;

--! @brief Multiplies a signed value of N bits with a 1-bit value

entity mult_n_1 is
  generic(
    N : integer
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset
    
    A_DI : in std_logic_vector(N-1 downto 0);
    B_DI : in std_logic;

    C_DO : out std_logic_vector(N-1 downto 0)

    );
end mult_n_1;

architecture Behavioral of mult_n_1 is

signal C_DN : std_logic_vector(N-1 downto 0);
begin

  process(B_DI, A_DI)
  begin
    if B_DI = '1' then                  -- '+1'
      C_DN <= A_DI;
    else                                -- '-1'
      C_DN <= std_logic_vector(to_signed((-1)*to_integer(signed(A_DI)), N));
    end if;
  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        C_DO   <= (others=>'0');
      else
        C_DO   <= C_DN;
      end if;
    end if;
  end process;
end Behavioral;
