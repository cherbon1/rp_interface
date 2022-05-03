----------------------------------------------------------------------------------
--! @file freq_div.vhd
--! @author Felix Tebbenjohanns
--! @date 2.7.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;


library work;

--! @brief Divides the frequency of a digtial oscillator by 1 or 2.

entity freq_div is
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    SgnSinIn_SI  : in  std_logic;
    SgnCosIn_SI  : in  std_logic;
    
    SgnSinOut_SO : out std_logic;
    SgnCosOut_SO : out std_logic;
    
    Div_SI : in std_logic_vector(0 downto 0)

    );
end freq_div;

architecture Behavioral of freq_div is

  signal SgnSinOld_SP          : std_logic;
  signal SgnSinOut_SN, SgnSinOut_SP : std_logic;
  signal SgnCosOut_SN, SgnCosOut_SP : std_logic;

begin

    SgnSinOut_SO <= SgnSinOut_SP;
    SgnCosOut_SO <= SgnCosOut_SP;
    
      process(SgnCosIn_SI, SgnSinIn_SI, SgnSinOut_SP, SgnCosOut_SP, SgnSinOld_SP, Div_SI)
      begin
        if Div_SI = "0" then  -- don't devide
            SgnSinOut_SN <= SgnSinIn_SI;
            SgnCosOut_SN <= SgnCosIn_SI;
        else -- divide by 2
            SgnSinOut_SN <= SgnSinOut_SP;
            SgnCosOut_SN <= SgnCosOut_SP;
            if SgnSinIn_SI = '1' and SgnSinOld_SP = '0' then  -- rising edge
              SgnSinOut_SN <= not SgnSinOut_SP;
            end if;
            if SgnSinIn_SI = '0' and SgnSinOld_SP = '1' then  -- falling edge
              SgnCosOut_SN <= not SgnSinOut_SP;
            end if;
        end if;
      end process;

  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        SgnSinOut_SP   <= '0';
        SgnCosOut_SP <= '0';
        SgnSinOld_SP <= '0';
      else
        SgnSinOut_SP   <= SgnSinOut_SN;
        SgnCosOut_SP   <= SgnCosOut_SN;
        SgnSinOld_SP <= SgnSinIn_SI;
      end if;
    end if;
  end process;
end Behavioral;
