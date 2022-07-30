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

entity sprite is
port (
    i_clk      : in  std_logic;
    i_rst      : in  std_logic;
    i_opcode   : in  std_logic_vector(4 downto 0);
    i_reg_tex  : in  std_logic_vector(7 downto 0);
    i_reg_x    : in  std_logic_vector(8 downto 0);
    i_reg_y    : in  std_logic_vector(8 downto 0);
    i_reg_sprt : in  std_logic_vector(5 downto 0);
    i_reg_en   : in  std_logic;

    i_id       : in  std_logic_vector(5 downto 0);

    o_x        : out std_logic_vector(8 downto 0);
    o_y        : out std_logic_vector(8 downto 0);
    o_tex      : out texture;
    o_en       : out std_logic
); end sprite;


architecture behavioral of sprite is
    

    signal s_texture_id     : std_logic_vector(7 downto 0) := (others => '0');
    signal s_x              : std_logic_vector(8 downto 0) := (others => '0');
    signal s_y              : std_logic_vector(8 downto 0) := (others => '0');
    signal s_en             : std_logic := '0';
begin

    process(i_clk, i_rst, i_opcode, i_reg_x, i_reg_y)
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '1') then
                s_texture_id <= (others => '0');
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

    o_tex <= s_sprite_textures(to_integer(unsigned(s_texture_id)));
    o_en  <= s_en;
    o_x   <= s_x;
    o_y   <= s_y;
    
    
end behavioral;
