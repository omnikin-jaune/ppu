---------------------------------------------------------------------------------------------
--
--	Pascal-Emmanuel Lachance | raesangur
--
--  github.com/omnikin-jaune/
--
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ppu_package.all;

entity color_converter is
port (
    i_cc    : in  std_logic_vector(5  downto 0);
    o_color : out std_logic_vector(23 downto 0)
); end color_converter;


architecture behavioral of color_converter is

    signal colors : ram_colors(0 to 63) := (
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000",
    X"000000");
    
begin
    o_color <= colors(to_integer(unsigned(i_cc)));
end behavioral;
