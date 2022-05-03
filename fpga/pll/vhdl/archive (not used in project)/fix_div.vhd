----------------------------------------------------------------------------------
--! @file fix_div.vhd
--! @author Felix Tebbenjohanns
--! @date 9.7.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;


library work;


entity fix_div is
  generic (
    N_IN : integer := 31;
    N_OUT : integer := 12;
    DIV : integer := 256
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset
    
    Din_DI  : in  std_logic_vector(N_IN-1 downto 0);
    Valid_SI : in std_logic;
    
    Dout_DO : out std_logic_vector(N_OUT-1 downto 0);
    Valid_SO : out std_logic

    );
end fix_div;

architecture Behavioral of fix_div is
  signal Div_DP, Div_DN     : std_logic_vector(N_OUT - 1 downto 0);
  signal Valid_SP, Valid_SN : std_logic;
begin


  process(Valid_SI, Div_DP, Din_DI)
  begin
  
    Valid_SN <= Valid_SI;
    Div_DN <= Div_DP;
    
    if Valid_SI = '1' then 
        Div_DN <= std_logic_vector(resize(signed(Din_DI) / DIV, N_OUT));
    end if;
 
  end process;

  Dout_DO <= Div_DP;
  Valid_SO <= Valid_SP;

  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        Div_DP   <= (others=>'0');
        Valid_SP <= '0';
      else
        Div_DP   <= Div_DN;
        Valid_SP <= Valid_SN;
      end if;
    end if;
  end process;

end Behavioral;
