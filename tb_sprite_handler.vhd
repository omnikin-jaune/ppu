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

entity tb_sprite_handler is end tb_sprite_handler;
  
architecture behavioral of tb_sprite_handler is

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


    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '1';

    signal s_opcode   : std_logic_vector(OP_SIZE downto 0)  := (others => '0');
    signal s_reg_tex  : std_logic_vector(7 downto 0)        := (others => '0');
    signal s_reg_x    : std_logic_vector(POS_SIZE downto 0) := (others => '0');
    signal s_reg_y    : std_logic_vector(POS_SIZE downto 0) := (others => '0');
    signal s_reg_sprt : std_logic_vector(5 downto 0)        := (others => '0');
    signal s_reg_en   : std_logic := '0';
    
    signal s_x : std_logic_vector(POS_SIZE downto 0) := (others => '0');
    signal s_y : std_logic_vector(POS_SIZE downto 0) := (others => '0');

    signal s_has_sprite : std_logic;
    signal s_cc         : std_logic_vector(CC_SIZE downto 0);

begin

    inst_sprite_handler: sprite_handler
    port map (
        i_clk      => s_clk,
        i_rst      => s_rst,
        i_opcode   => s_opcode,
        i_reg_tex  => s_reg_tex,
        i_reg_x    => s_reg_x,
        i_reg_y    => s_reg_y,
        i_reg_en   => s_reg_en,
        i_reg_sprt => s_reg_sprt,

        i_x        => s_x,
        i_y        => s_y,

        o_cc       => s_cc,
        o_sprite   => s_has_sprite
    );
    
    clock : process
    begin 
        s_clk <=  '1';
        wait for 500ps;
        s_clk <= '0';
        wait for 500ps;
    end process;
    
    tb_sprite_handler : process
    begin
    
        wait for 10ns;
        s_rst <= '0';
        
        -- Set texture 1 for sprite #1, but don't enable sprite #1
        wait for 1ns;
        s_opcode   <= OP_SPRT_TEX;
        s_reg_tex  <= "00000001";
        s_reg_sprt <= "000001";
        
        wait for 1ns;
        s_opcode <= OP_NOP;
        assert s_has_sprite /= '0' report "No sprite should be detected - none enabled" severity error;
        
        -- Enable sprite #0
        wait for 1ns;
        s_opcode   <= OP_SPRT_EN;
        s_reg_en   <= '1';
        s_reg_sprt <= "000000";
        
        wait for 1ns;
        s_opcode <= OP_NOP;
        assert s_has_sprite /= '0' report "No sprite should be detected - sprite 0 with cc 0" severity error;
        
        -- Enable sprite #1
        wait for 1ns;
        s_opcode   <= OP_SPRT_EN;
        s_reg_sprt <= "000001";
        s_reg_en   <= '1';
        assert s_has_sprite /= '1' report "Sprite 1 should be detected" severity error;
        
        -- Move current pixel
        wait for 1ns;
        s_opcode   <= OP_NOP;
        s_reg_sprt <= "000001";
        s_x        <= std_logic_vector(to_unsigned(35, POS_SIZE + 1));
        s_y        <= std_logic_vector(to_unsigned(52, POS_SIZE + 1));
        
        -- Move sprite 0 (with tex 0)
        wait for 1ns;
        s_opcode   <= OP_SPRT_POS;
        s_reg_sprt <= "000000";
        s_reg_x    <= std_logic_vector(to_unsigned(35, POS_SIZE + 1));
        s_reg_y    <= std_logic_vector(to_unsigned(52, POS_SIZE + 1));
        
        -- Change sprite 1 texture
        wait for 1ns;
        s_opcode   <= OP_SPRT_TEX;
        s_reg_sprt <= "000000";
        s_reg_tex  <= "00000001";
        assert s_has_sprite /= '1' report "Sprite 0 should be detected" severity error;
        
        -- Move sprite 0 just before the range
        wait for 1ns;
        s_opcode   <= OP_SPRT_POS;
        s_reg_sprt <= "000000";
        s_reg_x    <= std_logic_vector(to_unsigned(34, POS_SIZE + 1));
        s_reg_y    <= std_logic_vector(to_unsigned(52, POS_SIZE + 1));
        assert s_has_sprite /= '0' report "Sprite 0 should no longer be detected (before range)" severity error;
        
        -- Move sprite 0 just after the range
        wait for 1ns;
        s_opcode   <= OP_SPRT_POS;
        s_reg_sprt <= "000000";
        s_reg_x    <= std_logic_vector(to_unsigned(51, POS_SIZE + 1));
        s_reg_y    <= std_logic_vector(to_unsigned(52, POS_SIZE + 1));
        assert s_has_sprite /= '0' report "Sprite 0 should no longer be detected (after range)" severity error;
        
        -- Move sprite 0 just inside of range
        wait for 1ns;
        s_opcode   <= OP_SPRT_POS;
        s_reg_sprt <= "000000";
        s_reg_x    <= std_logic_vector(to_unsigned(50, POS_SIZE + 1));
        s_reg_y    <= std_logic_vector(to_unsigned(52, POS_SIZE + 1));
        assert s_has_sprite /= '1' report "Sprite 0 should be detected again" severity error;
        
        -- Move sprite 1 inside range
        wait for 1ns;
        s_opcode   <= OP_SPRT_POS;
        s_reg_sprt <= "000001";
        s_reg_x    <= std_logic_vector(to_unsigned(35, POS_SIZE + 1));
        s_reg_y    <= std_logic_vector(to_unsigned(52, POS_SIZE + 1));
        
        -- Change sprite 1 texture to texture 2
        wait for 1ns;
        s_opcode   <= OP_SPRT_TEX;
        s_reg_sprt <= "000001";
        s_reg_tex  <= "00000010";
        
        -- Move sprite 0 outside of range
        wait for 1ns;
        s_opcode   <= OP_SPRT_POS;
        s_reg_sprt <= "000000";
        s_reg_x    <= std_logic_vector(to_unsigned(0, POS_SIZE + 1));
        s_reg_y    <= std_logic_vector(to_unsigned(0, POS_SIZE + 1));
        assert s_cc /= s_sprite_textures(2)(0) report "Wrong color code detected" severity error;
        
        
    
        wait;
    end process;
end behavioral;
