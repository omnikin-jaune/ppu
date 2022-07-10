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

package ppu_package is 

subtype color_code is std_logic_vector(5 downto 0);
subtype opcode     is std_logic_vector(4 downto 0);

type ram_colors is array (natural range <>) of std_logic_vector(23 downto 0);
type vector_pos is array (natural range <>) of std_logic_vector(8  downto 0);
type texture    is array (0 to 1023) of color_code;
type abcde      is array (0 to 63)   of color_code;


constant OP_NOP      : std_logic_vector(4 downto 0) := "00000";
constant OP_TILE_TEX : std_logic_vector(4 downto 0) := "01001";
constant OP_PIX_OFF  : std_logic_vector(4 downto 0) := "01100";
constant OP_SPRT_TEX : std_logic_vector(4 downto 0) := "00001";
constant OP_SPRT_EN  : std_logic_vector(4 downto 0) := "00010";
constant OP_SPRT_POS : std_logic_vector(4 downto 0) := "00011";


end package ppu_package;
