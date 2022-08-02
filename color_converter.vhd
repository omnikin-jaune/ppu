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
    X"000001",
    X"000002",
    X"000003",
    X"000004",
    X"000005",
    X"000006",
    X"000007",
    X"000008",
    X"000009",
    X"00000A",
    X"00000B",
    X"00000C",
    X"00000D",
    X"00000E",
    X"00000F",
    X"000010",
    X"000011",
    X"000012",
    X"000013",
    X"000014",
    X"000015",
    X"000016",
    X"000017",
    X"000018",
    X"000019",
    X"00001A",
    X"00001B",
    X"00001C",
    X"00001D",
    X"00001E",
    X"00001F",
    X"000020",
    X"000021",
    X"000022",
    X"000023",
    X"000024",
    X"000025",
    X"000026",
    X"000027",
    X"000028",
    X"000029",
    X"00002A",
    X"00002B",
    X"00002C",
    X"00002D",
    X"00002E",
    X"00002F",
    X"000030",
    X"000031",
    X"000032",
    X"000033",
    X"000034",
    X"000035",
    X"000036",
    X"000037",
    X"000038",
    X"000039",
    X"00003A",
    X"00003B",
    X"00003C",
    X"00003D",
    X"00003E",
    X"00003F");
    
begin
    o_color <= colors(to_integer(unsigned(i_cc)));
end behavioral;
