----------------------------------------------------------------------------------
--! @file negative_signed.vhd
--! @author Felix Tebbenjohanns
--! @date 30.8.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;


library work;


entity negative_signed is
  generic (
    N : integer := 16
    );
  port (
    A_DI      : in std_logic_vector(N-1 downto 0);

    NA_DO     : out std_logic_vector(N-1 downto 0)

    );
end negative_signed;

architecture Behavioral of negative_signed is
  
begin

    NA_DO <= std_logic_vector(resize((-1) * signed(A_DI), N));

end Behavioral;
