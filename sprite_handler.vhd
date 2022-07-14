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
use work.sprite_package.all;

entity sprite_handler is
port (
    i_clk      : in  std_logic;
    i_rst      : in  std_logic;
    
    i_opcode   : in  std_logic_vector(4 downto 0);
    i_reg_tex  : in  std_logic_vector(7 downto 0);
    i_reg_x    : in  std_logic_vector(POS_SIZE downto 0);
    i_reg_y    : in  std_logic_vector(POS_SIZE downto 0);
    i_reg_sprt : in  std_logic_vector(5 downto 0);
    i_reg_en   : in  std_logic;

    i_x        : in  std_logic_vector(POS_SIZE downto 0);
    i_y        : in  std_logic_vector(POS_SIZE downto 0);

    o_cc       : out std_logic_vector(5 downto 0);
    o_sprite   : out std_logic
); end sprite_handler;


architecture behavioral of sprite_handler is

    component sprite is
    port (
        i_clk      : in  std_logic;
        i_rst      : in  std_logic;
        i_opcode   : in  std_logic_vector(4 downto 0);
        i_reg_tex  : in  std_logic_vector(7 downto 0);
        i_reg_x    : in  std_logic_vector(POS_SIZE downto 0);
        i_reg_y    : in  std_logic_vector(POS_SIZE downto 0);
        i_reg_sprt : in  std_logic_vector(5 downto 0);
        i_reg_en   : in  std_logic;
        
        i_id       : in  std_logic_vector(5 downto 0);

        o_x        : out std_logic_vector(POS_SIZE downto 0);
        o_y        : out std_logic_vector(POS_SIZE downto 0);
        o_tex      : out texture;
        o_en       : out std_logic
    );
    end component;
    
    component hit_handler is
    port (
        i_x        : in std_logic_vector(POS_SIZE downto 0);
        i_y        : in std_logic_vector(POS_SIZE downto 0);
        i_sprite_x : in vector_sprt_pos;
        i_sprite_y : in vector_sprt_pos;
        i_en       : in std_logic_vector(SPRT_SIZE downto 0);
        i_cc_0     : in std_logic_vector(SPRT_SIZE downto 0);
    
        o_sprite   : out std_logic_vector(5 downto 0);
        o_en       : out std_logic
    );
    end component;
    
    signal s_sprites_x    : vector_sprt_pos;
    signal s_sprites_y    : vector_sprt_pos;
    signal s_sprites_tex  : vector_sprt_tex;
    signal s_sprite_tex   : texture;
    signal s_sprites_en   : std_logic_vector(SPRT_SIZE downto 0);
    signal s_sprites_cc_0 : std_logic_vector(SPRT_SIZE downto 0);
    signal s_sprite_cc    : std_logic_vector(CC_SIZE   downto 0);

    signal s_sprite_id    : std_logic_vector(5 downto 0);
    signal s_cc_id        : std_logic_vector(7 downto 0);
    
begin

    -- https://stackoverflow.com/a/13194608
    sprite_gen:
    for i in 0 to 63 generate
        sprites: sprite
        port map (
            i_clk      => i_clk,
            i_rst      => i_rst,
            i_opcode   => i_opcode,
            i_reg_tex  => i_reg_tex,
            i_reg_x    => i_reg_x,
            i_reg_y    => i_reg_y,
            i_reg_sprt => i_reg_sprt,
            i_reg_en   => i_reg_en,

            i_id       => std_logic_vector(to_unsigned(i, 6)),

            o_x        => s_sprites_x (i),
            o_y        => s_sprites_y (i),
            o_tex      => s_sprites_tex(i),
            o_en       => s_sprites_en(i)
        );
    end generate;

    inst_hit_handler: hit_handler
    port map (
        i_x        => i_x,
        i_y        => i_y,
        i_sprite_x => s_sprites_x,
        i_sprite_y => s_sprites_y,
        i_en       => s_sprites_en,
        i_cc_0     => s_sprites_cc_0,
        o_sprite   => s_sprite_id,
        o_en       => o_sprite
    );
    
    s_cc_id (7 downto 4) <= i_y(3 downto 0);
    s_cc_id (3 downto 0) <= i_x(3 downto 0);

    
    s_sprite_tex <= s_sprites_tex(to_integer(unsigned(s_sprite_id)));
    o_cc         <= s_sprite_tex (to_integer(unsigned(s_cc_id)));
    
    process(s_sprites_tex)
    begin
        for i in s_sprites_tex' range loop
            s_sprites_cc_0(i) <= '1' when s_sprites_tex(i) = s_sprite_textures(0) else '0';
        end loop;
    end process;

end behavioral;
