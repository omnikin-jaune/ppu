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

-- || <opcode : 5> - <x : 9> - <y : 9> - <tex : 8> - <sprite : 6> - <en : 1> - <0> ||


entity ppu is
port (
    i_clk      : in  std_logic;
    i_rst      : in  std_logic;
    
    i_opcode   : in  std_logic_vector(OP_SIZE downto 0);
    i_reg_x    : in  std_logic_vector(8 downto 0);
    i_reg_y    : in  std_logic_vector(8 downto 0);
    i_reg_tex  : in  std_logic_vector(7 downto 0);
    i_reg_sprt : in  std_logic_vector(5 downto 0);
    i_reg_en   : in  std_logic;
    
    o_color    : out std_logic_vector(23 downto 0);
    o_sof      : out std_logic;
    o_eof      : out std_logic;
    o_sol      : out std_logic;
    o_eol      : out std_logic
); end ppu;

  
architecture behavioral of ppu is
    component pixelator is
    port (
        i_clk    : in  std_logic;
        i_rst    : in  std_logic;
        i_opcode : in  std_logic_vector(OP_SIZE downto 0);
        i_reg_x  : in  std_logic_vector(8 downto 0);
        i_reg_y  : in  std_logic_vector(8 downto 0);
        i_reg_en : in  std_logic;

        o_x      : out std_logic_vector(7 downto 0);
        o_y      : out std_logic_vector(7 downto 0);
        o_x_off  : out std_logic_vector(8 downto 0);    -- x value with added offset
        o_y_off  : out std_logic_vector(8 downto 0)     -- y value with added offset
    );
    end component;

    component frame_printer is
    port (
        i_clk : in  std_logic;
        i_rst : in  std_logic;
        i_x   : in  std_logic_vector(7 downto 0);
        i_y   : in  std_logic_vector(7 downto 0);

        o_sof : out std_logic;
        o_eof : out std_logic;
        o_sol : out std_logic;
        o_eol : out std_logic
    );
    end component;

    component tile_handler is
    port (
        i_clk     : in  std_logic;
        i_rst     : in  std_logic;
        i_opcode  : in  std_logic_vector(OP_SIZE downto 0);
        i_reg_tex : in  std_logic_vector(7 downto 0);
        i_reg_x   : in  std_logic_vector(8 downto 0);
        i_reg_y   : in  std_logic_vector(8 downto 0);

        i_x       : in  std_logic_vector(8 downto 0);
        i_y       : in  std_logic_vector(8 downto 0);

        o_cc      : out std_logic_vector(CC_SIZE downto 0)
    );
    end component;

    component sprite_handler is
    port (
        i_clk      : in  std_logic;
        i_rst      : in  std_logic;
        i_opcode   : in  std_logic_vector(OP_SIZE downto 0);
        i_reg_tex  : in  std_logic_vector(7 downto 0);
        i_reg_x    : in  std_logic_vector(8 downto 0);
        i_reg_y    : in  std_logic_vector(8 downto 0);
        i_reg_sprt : in  std_logic_vector(5 downto 0);
        i_reg_en   : in  std_logic;

        i_x        : in  std_logic_vector(8 downto 0);
        i_y        : in  std_logic_vector(8 downto 0);

        o_cc       : out std_logic_vector(CC_SIZE downto 0);
        o_sprite   : out std_logic
    );
    end component;

    component color_converter is
    port (
        i_cc    : in  std_logic_vector(CC_SIZE downto 0);
        o_color : out std_logic_vector(23 downto 0)
    );
    end component;


    signal s_x_offset   : std_logic_vector(8 downto 0)  := (others => '0');
    signal s_y_offset   : std_logic_vector(8 downto 0)  := (others => '0');
    signal s_x          : std_logic_vector(7 downto 0)  := (others => '0');
    signal s_y          : std_logic_vector(7 downto 0)  := (others => '0');

    signal s_has_sprite : std_logic := '0';

    signal s_cc         : std_logic_vector(CC_SIZE downto 0) := (others => '0');
    signal s_tile_cc    : std_logic_vector(5 downto 0)       := (others => '0');
    signal s_sprite_cc  : std_logic_vector(5 downto 0)       := (others => '0');


    
begin

    inst_pixelator: pixelator
    port map (
        i_clk    => i_clk,
        i_rst    => i_rst,
        i_opcode => i_opcode,
        i_reg_x  => i_reg_x,
        i_reg_y  => i_reg_y,
        i_reg_en => i_reg_en,

        o_x      => s_x,
        o_y      => s_y,
        o_x_off  => s_x_offset,
        o_y_off  => s_y_offset
    );

    inst_frame_printer: frame_printer
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_x   => s_x,
        i_y   => s_y,

        o_sof => o_sof,
        o_eof => o_eof,
        o_sol => o_sol,
        o_eol => o_eol
    );

    inst_tile_handler: tile_handler
    port map (
        i_clk     => i_clk,
        i_rst     => i_rst,
        i_opcode  => i_opcode,
        i_reg_tex => i_reg_tex,
        i_reg_x   => i_reg_x,
        i_reg_y   => i_reg_y,

        i_x       => s_x_offset,
        i_y       => s_y_offset,

        o_cc      => s_tile_cc
    );

    inst_sprite_handler: sprite_handler
    port map (
        i_clk      => i_clk,
        i_rst      => i_rst,
        i_opcode   => i_opcode,
        i_reg_tex  => i_reg_tex,
        i_reg_x    => i_reg_x,
        i_reg_y    => i_reg_y,
        i_reg_en   => i_reg_en,
        i_reg_sprt => i_reg_sprt,

        i_x        => s_x_offset,
        i_y        => s_y_offset,

        o_cc       => s_sprite_cc,
        o_sprite   => s_has_sprite
    );

    inst_color_converter: color_converter
    port map (
        i_cc    => s_cc,
        o_color => o_color
    );
    
    s_cc <= s_sprite_cc when s_has_sprite = '1' else s_tile_cc;

end behavioral;
