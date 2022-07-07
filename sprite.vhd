---------------------------------------------------------------------------------------------
--
--	Pascal-Emmanuel Lachance | raesangur
--
--  github.com/omnikin-jaune/
--
---------------------------------------------------------------------------------------------

entity sprite is
port (
    i_clk      : in  std_logic;
    i_rst      : in  std_logic;
    i_opcode   : in  std_logic_vector(4 downto 0);
    i_reg_tex  : in  std_logic_vector(5 downto 0);
    i_reg_x    : in  std_logic_vector(8 downto 0);
    i_reg_y    : in  std_logic_vector(8 downto 0);
    i_reg_sprt : in  std_logic_vector(5 downto 0);
    i_reg_en   : in  std_logic;

    i_id       : in  std_logic_vector(5 downto 0);

    o_x        : out std_logic_vector(8 downto 0);
    o_y        : out std_logic_vector(8 downto 0);
    o_cc       : out array(natural range <>) of std_logic_vector(23 downto 0);
    o_en       : out std_logic;
) end sprite;


architecture behavioral of sprite is
    s_texture_id : std_logic_vector(7 downto 0) => ;
    s_x          : std_logic_vector(8 downto 0) => ;
    s_y          : std_logic_vector(8 downto 0) => ;
    s_en         : std_logic;
begin

    process(i_clk, i_rst, i_opcode, i_reg_x, i_reg_y)
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '1') then
                s_texture_id <= others => '0';
            else
                if (i_reg_sprt = i_id) then
                    if (i_opcode = OP_SPRT_TEX) then
                        s_texture_id <= i_reg_tex;
                    end if;
                    if (i_opcode = OP_SPRT_POS) then
                        s_x <= i_reg_x;
                        s_y <= i_reg_y;
                    end if;
                    if (i_opcode = OP_SPRT_EN) then
                        s_en <= i_reg_en;
                    end if;
                end if;
            end if;
        end if;
    end process;


    o_cc <= s_tiles_textures(to_integer(s_texture_id));
    o_en <= s_en;
    
end behavioral;
