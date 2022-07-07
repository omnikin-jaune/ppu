---------------------------------------------------------------------------------------------
--
--	Pascal-Emmanuel Lachance | raesangur
--
--  github.com/omnikin-jaune/
--
---------------------------------------------------------------------------------------------

entity sprite_handler is
port (
    i_clk      : in  std_logic;
    i_rst      : in  std_logic;
    i_opcode   : in  std_logic_vector(4 downto 0);
    i_reg_tex  : in  std_logic_vector(5 downto 0);
    i_reg_x    : in  std_logic_vector(8 downto 0);
    i_reg_y    : in  std_logic_vector(8 downto 0);
    i_reg_sprt : in  std_logic_vector(5 downto 0);
    i_reg_en   : in  std_logic;

    i_x        : in  std_logic_vector(8 downto 0);
    i_y        : in  std_logic_vector(8 downto 0);

    o_cc       : out std_logic_vector(5 downto 0);
) end sprite_handler;


architecture behavioral of sprite_handler is

    component sprite is
    port (
        i_clk      : in  std_logic;
        i_rst      : in  std_logic;
        i_opcode   : in  std_logic_vector(4 downto 0);
        i_reg_tex  : in  std_logic_vector(5 downto 0);
        i_reg_x    : in  std_logic_vector(8 downto 0);
        i_reg_y    : in  std_logic_vector(8 downto 0);
        i_reg_sprt : in  std_logic_vector(5 downto 0);
        i_reg_en   : in  std_logic;

        o_x        : out std_logic_vector(8 downto 0);
        o_y        : out std_logic_vector(8 downto 0);
        o_cc       : out array(natural range <>) of std_logic_vector(23 downto 0);
    );


    type vector_pos is array (natural range <>) of std_logic_vector(8 downto 0);
    type vector_tex is array (natural range <>) of vector_cc       (0 to     255);
    
    signal s_sprites_x  : vector_pos(0 to 63);
    signal s_sprites_y  : vector_pos(0 to 63);
    signal s_sprites_cc : vector_tex(0 to 63);
    signal s_sprite_cc  : vector_tex;

    signal s_sprite_id  : std_logic_vector(5 downto 0);
    signal s_cc_id      : std_logic_vector(7 downto 0);
    
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

            i_id       => i,

            o_x        => s_sprites_x (i),
            o_y        => s_sprites_y (i),
            o_cc       => s_sprites_cc(i)
        );
    end generate;

    s_sprite_id(9 downto 5) <= i_y(8 downto 4);
    s_sprite_id(4 downto 0) <= i_x(8 downto 4);

    s_cc_id    (7 downto 4) <= i_y(3 downto 0);
    s_cc_id    (3 downto 0) <= i_x(3 downto 0);

    s_sprite_cc <= s_sprites_cc(to_integer(s_sprite_id));
    o_cc        <= s_sprite_cc (to_integer(s_cc_id));

end behavioral;
