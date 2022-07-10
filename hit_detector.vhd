---------------------------------------------------------------------------------------------
--
--	Pascal-Emmanuel Lachance | raesangur
--
--  github.com/omnikin-jaune/
--
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.ppu_package.all;

entity hit_detector is
port (
    i_x        : in  std_logic_vector(POS_SIZE downto 0);
    i_y        : in  std_logic_vector(POS_SIZE downto 0);
    i_sprite_x : in  std_logic_vector(POS_SIZE downto 0); 
    i_sprite_y : in  std_logic_vector(POS_SIZE downto 0);
    i_en       : in  std_logic;
    i_tex      : in  texture;

    o_hit      : out std_logic;
    o_cc       : out std_logic_vector(CC_SIZE downto 0)
); end hit_detector;


architecture behavioral of hit_detector is
    signal s_cc   : std_logic_vector(CC_SIZE downto 0);
    signal s_cc_x : std_logic_vector(3 downto 0);
    signal s_cc_y : std_logic_vector(3 downto 0);
begin

    o_hit <= '1' when ((i_x < (i_sprite_x + 16) and i_x > (i_sprite_x - 1)) and
                       (i_y < (i_sprite_y + 16) and i_y > (i_sprite_y - 1)) and
                        i_en = '1' and
                        s_cc /= "000000")
                        else '0';
              
end behavioral;
