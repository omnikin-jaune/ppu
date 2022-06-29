---------------------------------------------------------------------------------------------
--
--	Pascal-Emmanuel Lachance | raesangur
--
--  github.com/omnikin-jaune/
--
---------------------------------------------------------------------------------------------

entity tile_handler is
port (
    i_clk     : in  std_logic;
    i_rst     : in  std_logic;
    i_opcode  : in  std_logic_vector(4 downto 0);
    i_reg_tex : in  std_logic_vector(5 downto 0);
    i_reg_x   : in  std_logic_vector(8 downto 0);
    i_reg_y   : in  std_logic_vector(8 downto 0);

    i_x       : in  std_logic_vector(8 downto 0);
    i_y       : in  std_logic_vector(8 downto 0);

    o_cc      : out std_logic_vector(5 downto 0);
) end tile_handler;


architecture behavioral of tile_handler is

    component tile is
    port (
        i_clk     : in  std_logic;
        i_rst     : in  std_logic;
        i_opcode  : in  std_logic_vector(4 downto 0);
        i_reg_tex : in  std_logic_vector(5 downto 0);
        i_reg_x   : in  std_logic_vector(8 downto 0);
        i_reg_y   : in  std_logic_vector(8 downto 0);

        o_x       : out std_logic_vector(8 downto 0);
        o_y       : out std_logic_vector(8 downto 0);
        o_cc      : out array(natural range <>) of std_logic_vector(23 downto 0);
    );


    type vector_pos is array (natural range <>) of std_logic_vector(8 downto 0);
    type vector_tex is array (natural range <>) of vector_cc       (0 to     255);
    
    signal s_tiles_x  : vector_pos(0 to 1023);
    signal s_tiles_y  : vector_pos(0 to 1023);
    signal s_tiles_cc : vector_tex(0 to 1023);
    signal s_tile_cc  : vector_tex;

    signal s_tile_id  : std_logic_vector(9 downto 0);
    signal s_cc_id    : std_logic_vector(7 downto 0);
    
begin

    -- https://stackoverflow.com/a/13194608
    tile_gen:
    for i in 0 to 1023 generate
        tiles: tile
        port map (
            i_clk     => i_clk,
            i_rst     => i_rst,
            i_opcode  => i_opcode,
            i_reg_tex => i_reg_tex,
            i_reg_x   => i_reg_x,
            i_reg_y   => i_reg_y,

            o_x       => s_tiles_x (i),
            o_y       => s_tiles_y (i),
            o_cc      => s_tiles_cc(i)
        );
    end generate;

    s_tile_id(9 downto 5) <= i_y(8 downto 4);
    s_tile_id(4 downto 0) <= i_x(8 downto 4);

    s_cc_id  (7 downto 4) <= i_y(3 downto 0);
    s_cc_id  (3 downto 0) <= i_x(3 downto 0);

    s_tile_cc <= s_tiles_cc(to_integer(s_tile_id));
    o_cc      <= s_tile_cc (to_integer(s_cc_id));

end behavioral;
