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

constant  CC_SIZE : integer := 5;
constant  OP_SIZE : integer := 4;
constant COL_SIZE : integer := 23;
constant POS_SIZE : integer := 8;

constant CC_IN_ROW    : integer := 16;
constant CC_IN_COL    : integer := 16;
constant TILE_IN_ROW  : integer := 32;
constant TILE_IN_COL  : integer := 32;
constant TEX_INDEX_SZ : integer := 7;

type ram_colors is array (natural range <>) of std_logic_vector(COL_SIZE downto 0);
type texture    is array (0 to (CC_IN_ROW * CC_IN_COL) - 1) of std_logic_vector(CC_SIZE downto 0);

constant OP_NOP      : std_logic_vector(OP_SIZE downto 0) := "00000";
constant OP_TILE_TEX : std_logic_vector(OP_SIZE downto 0) := "01001";
constant OP_PIX_OFF  : std_logic_vector(OP_SIZE downto 0) := "01100";
constant OP_PIX_EN   : std_logic_vector(OP_SIZE downto 0) := "01101";
constant OP_SPRT_TEX : std_logic_vector(OP_SIZE downto 0) := "00001";
constant OP_SPRT_EN  : std_logic_vector(OP_SIZE downto 0) := "00010";
constant OP_SPRT_POS : std_logic_vector(OP_SIZE downto 0) := "00011";

function coords     (a : integer) return std_logic_vector;
function tile_coords(a : integer) return std_logic_vector;

end package ppu_package;


package body ppu_package is

function coords(a : integer) return std_logic_vector is
begin
    return std_logic_vector(to_unsigned(a, POS_SIZE + 1));
end function;

function tile_coords(a : integer) return std_logic_vector is 
begin
    return coords(16 * a);
end function;

end package body ppu_package;
