---------------------------------------------------------------------------------------------
--
--	Pascal-Emmanuel Lachance | raesangur
--
--  github.com/omnikin-jaune/
--
------------------------------------------------------------------------------------

entity hit_detector is
port (
    i_x        : std_logic_vector(8 downto 0);
    i_y        : std_logic_vector(8 downto 0);
    i_sprite_x : std_logic_vector(8 downto 0); 
    i_sprite_y : std_logic_vector(8 downto 0);
    i_en       : std_logic;
    i_cc       : std_logic_vector(5 downto 0);

    o_hit      : std_logic;
) end hit_detector;


architecture behavioral of hit_detector is
begin

    o_hit <= (i_x < i_sprite_x + 16 and i_x > i_sprite_x - 1) and
             (i_y < i_sprite_y + 16 and i_y > i_sprite_y - 1) and
              i_en = '1' and
              i_cc /= "000000";
              
end behavioral;
