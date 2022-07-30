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

entity tb_sprite is end tb_sprite;


architecture behavioral of tb_sprite is

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
    
    signal s_clk : std_logic;
    signal s_rst : std_logic := '1';
    signal s_x   : std_logic_vector(POS_SIZE downto 0);
    signal s_y   : std_logic_vector(POS_SIZE downto 0);
    
    signal s_opcode   : std_logic_vector(4 downto 0) := OP_NOP;
    signal s_reg_tex  : std_logic_vector(7 downto 0);
    signal s_reg_x    : std_logic_vector(POS_SIZE downto 0);
    signal s_reg_y    : std_logic_vector(POS_SIZE downto 0);
    signal s_reg_sprt : std_logic_vector(5 downto 0);
    signal s_reg_en   : std_logic;
    
    signal s_sprite_x    : std_logic_vector(POS_SIZE downto 0);
    signal s_sprite_y    : std_logic_vector(POS_SIZE downto 0);
    signal s_sprite_tex  : texture;
    signal s_sprite_en   : std_logic;
    
    signal s_sprite_cc_0 : std_logic;
    signal s_sprite_cc   : std_logic_vector(CC_SIZE   downto 0);
    signal s_sprite_id   : std_logic_vector(SPRT_INDX downto 0);
    signal s_cc_id       : std_logic_vector(7 downto 0);
    
begin
    inst_sprite : sprite
    port map (
            i_clk      => s_clk,
            i_rst      => s_rst,
            i_opcode   => s_opcode,
            i_reg_tex  => s_reg_tex,
            i_reg_x    => s_reg_x,
            i_reg_y    => s_reg_y,
            i_reg_sprt => s_reg_sprt,
            i_reg_en   => s_reg_en,

            i_id       => "010101",

            o_x        => s_sprite_x,
            o_y        => s_sprite_y,
            o_tex      => s_sprite_tex,
            o_en       => s_sprite_en
        );
        
        
    s_sprite_cc_0 <= '1' when s_sprite_tex = s_sprite_textures(0) else '0';
    
    clock : process
    begin 
        s_clk <=  '1';
        wait for 500ps;
        s_clk <= '0';
        wait for 500ps;
    end process;
    
    
    tb_sprite : process
    begin
        s_rst <= '0';
        
        -- Change new texture (wrong tile id)
        wait for 5ns;
        s_opcode   <= OP_SPRT_TEX;
        s_reg_sprt <= "010100";
        s_reg_tex  <= "00000001";
        
        -- Nop
        wait for 1ns;
        s_opcode  <= OP_NOP;
        s_reg_tex <= "00000000";
        
        -- Check if new texture is loaded
        wait for 5ns;
        assert s_sprite_tex(0) /= "00000000" report "wrong texture (shouldn't have changed)" severity error;
        assert s_sprite_cc_0   /= '1'        report "didn't report 0 texture"                severity error;
        
        -- Change new texture (good tile id)
        wait for 5ns;
        s_opcode   <= OP_SPRT_TEX;
        s_reg_sprt <= "010101";
        s_reg_tex  <= "00000001";
        
        -- Nop
        wait for 1ns;
        s_opcode  <= OP_NOP;
        s_reg_tex <= "00000000";
        
        -- Check if new texture is loaded
        wait for 5ns;
        assert s_sprite_tex(0) /= "11111111" report "wrong texture (should have changed)" severity error;
        assert s_sprite_cc_0   /= '0'        report "didn't report texture"               severity error;
        
        -- Enable sprite
        wait for 5ns;
        s_opcode <= OP_SPRT_EN;
        s_reg_en <= '1';
        
        wait for 1ns;
        s_opcode <= OP_NOP;
        s_reg_en <= '0';
        assert s_sprite_en /= '1' report "sprite should be enabled" severity error;
        
        
        -- Change sprite position
        wait for 1ns;
        s_opcode <= OP_SPRT_POS;
        s_reg_x  <= std_logic_vector(to_unsigned(35, POS_SIZE + 1));
        s_reg_y  <= std_logic_vector(to_unsigned(63, POS_SIZE + 1));
        
        wait for 1ns;
        s_opcode <= OP_NOP;
        assert s_sprite_x /= "000100011" report "sprite at wrong x position" severity error;
        assert s_sprite_y /= "000111111" report "sprite at wrong y position" severity error;
        
        wait;
    end process;

end behavioral;
