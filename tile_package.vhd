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

package tile_package is 

constant TILE_COUNT     : integer := 1024;
constant TILE_TEX_COUNT : integer := 256;

constant TILE_SIZE : integer := (TILE_COUNT - 1);

type vector_tile_pos is array (0 to TILE_SIZE)            of std_logic_vector(POS_SIZE downto 0);
type vector_tile_cc  is array (0 to TILE_SIZE)            of std_logic_vector(CC_SIZE  downto 0);
type tile_textures   is array (0 to (TILE_TEX_COUNT - 1)) of texture;

constant s_tile_textures : tile_textures := (
    0 => ("000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
          "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000"),

    1 => ("011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", 
          "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111", "011111"),

    2 => ("010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", 
          "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101", "010101"),
    others => (others => (others => '0')));

    function x_coord (i : integer) return std_logic_vector;
    function y_coord (i : integer) return std_logic_vector;

end package tile_package;

package body tile_package is

    function x_coord (i : integer) return std_logic_vector is
    begin
        return coords(16 * i)(POS_SIZE downto 0);
    end function;
    
    function y_coord (i : integer) return std_logic_vector is
    begin
        return coords((i / 32) * 16)(POS_SIZE downto 0);
    end function;
    
end package body tile_package;