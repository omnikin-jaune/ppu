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

entity tb_ppu is end tb_ppu;

architecture Behavioral of tb_ppu is
    component ppu is
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
    );
    end component;
    
    signal s_clk      : std_logic := '0';
    signal s_rst      : std_logic := '1';
    signal s_opcode   : std_logic_vector(OP_SIZE downto 0) := OP_NOP;
    signal s_reg_x    : std_logic_vector(8 downto 0) := (others => '0');
    signal s_reg_y    : std_logic_vector(8 downto 0) := (others => '0');
    signal s_reg_tex  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_reg_sprt : std_logic_vector(5 downto 0) := (others => '0');
    signal s_reg_en   : std_logic := '0';
    
    signal s_color    : std_logic_vector(23 downto 0);
    signal s_sof      : std_logic;
    signal s_eof      : std_logic;
    signal s_sol      : std_logic;
    signal s_eol      : std_logic;
begin

    inst_ppu: ppu
    port map(
        i_clk      => s_clk,
        i_rst      => s_rst,
        i_opcode   => s_opcode,
        i_reg_x    => s_reg_x,
        i_reg_y    => s_reg_y,
        i_reg_tex  => s_reg_tex,
        i_reg_sprt => s_reg_sprt,
        i_reg_en   => s_reg_en,
        o_color    => s_color,
        o_sof      => s_sof,
        o_eof      => s_eof,
        o_sol      => s_sol,
        o_eol      => s_eol
    );

    clock : process
    begin 
        s_clk <=  '1';
        wait for 500ps;
        s_clk <= '0';
        wait for 500ps;
    end process;

    tb_ppu : process
    begin
        s_rst <= '0';
        wait for 1 ns;
        
        -- Change tile 0, 0 texture
        s_opcode  <= OP_TILE_TEX;
        s_reg_x   <= tile_coords(0);
        s_reg_y   <= tile_coords(0);
        s_reg_tex <= "00000001"; 
        assert s_color /= X"00001F" report "0: Wrong texture" severity error;
        wait for 1ns;
        
        -- Change tile 1, 0 texture
        s_opcode  <= OP_TILE_TEX;
        s_reg_x   <= tile_coords(1);
        s_reg_y   <= tile_coords(0);
        s_reg_tex <= "00000010"; 
        wait for 1ns;
        
        -- Change tile 2, 0 texture
        s_opcode  <= OP_TILE_TEX;
        s_reg_x   <= tile_coords(2);
        s_reg_y   <= tile_coords(0);
        s_reg_tex <= "00000010"; 
        wait for 1ns;
        
        -- Change tile 4, 0 texture
        s_opcode  <= OP_TILE_TEX;
        s_reg_x   <= tile_coords(4);
        s_reg_y   <= tile_coords(0);
        s_reg_tex <= "00000001"; 
        wait for 1ns;
        
        -- Move sprite 2 in the middle of tile 2,0 and 3,0
        s_opcode   <= OP_SPRT_POS;
        s_reg_x    <= coords(24);
        s_reg_y    <= coords(0);
        s_reg_sprt <= "000010";
        wait for 1ns;
        
        -- Move sprite 1 right after sprite 2
        s_opcode   <= OP_SPRT_POS;
        s_reg_x    <= coords(27);
        s_reg_y    <= coords(0);
        s_reg_sprt <= "000001";
        wait for 1ns;
        
        -- Move sprite 0 on top of sprite 1
        s_opcode   <= OP_SPRT_POS;
        s_reg_x    <= coords(27);
        s_reg_y    <= coords(0);
        s_reg_sprt <= "000000";
        wait for 1ns;
        
        -- Enable sprite 1
        s_opcode   <= OP_SPRT_EN;
        s_reg_en   <= '1';
        s_reg_x    <= coords(0);
        s_reg_y    <= coords(0);
        s_reg_sprt <= "000001";
        wait for 1ns;
        
        -- Enable sprite 2
        s_opcode   <= OP_SPRT_EN;
        s_reg_en   <= '1';
        s_reg_x    <= coords(0);
        s_reg_y    <= coords(0);
        s_reg_sprt <= "000010";
        wait for 1ns;
        
        -- Change sprite 1 texture
        s_opcode   <= OP_SPRT_TEX;
        s_reg_en   <= '0';
        s_reg_sprt <= "000001";
        s_reg_tex  <= "00000001";
        wait for 1ns;
        
        -- Change sprite 2 texture
        s_opcode   <= OP_SPRT_TEX;
        s_reg_en   <= '0';
        s_reg_sprt <= "000010";
        s_reg_tex  <= "00000010";
        wait for 1ns;
        
        -- Tile 0,0 has texture #1
        -- Tile 0,1 has texture #2
        -- Tile 0,2 has texture #2
        -- Tile 0,3 has texture #0
        -- Tile 0,4 has texture #1
        -- Sprite 2 is on top of tile 2 & 3, and has texture #2
        -- Sprite 1 is on top of sprite 2 and tile 3, and has texture #1
        -- Sprite 0 is on top of sprite 1, but is not enabled
        
        -- Enable pixalator
        s_opcode  <= OP_PIX_EN;
        s_reg_en   <= '1';
        s_reg_sprt <= "000000";
        wait for 1ns;
        
        -- Reset instructions
        s_opcode   <= OP_NOP;
        s_reg_en   <= '0';
        s_reg_sprt <= "000000";
        s_reg_tex  <= "00000000";
        s_reg_x    <= coords(0);
        s_reg_y    <= coords(0);
        wait for 14ns;
        
        -- We should still be in tile 0
        assert s_color /= X"00001F" report "1: Wrong texture" severity error;
        wait for 1ns;
        
        -- We should now be in tile 1
        assert s_color /= X"000015" report "2: Wrong texture" severity error;
        wait for 7ns;
        
        -- We should now be in tile 2
        assert s_color /= X"000015" report "3: Wrong texture" severity error;
        wait for 1ns;
        
        -- We should now be in sprite 2
        assert s_color /= X"00002A" report "4: Wrong texture" severity error;
        wait for 1ns;
        
        -- We should still be in sprite 2
        assert s_color /= X"00002A" report "5: Wrong texture" severity error;
        wait for 2ns;
        
        -- We should now be in sprite 1 (not sprite 0);
        assert s_color /= X"00003F" report "6: Wrong texture" severity error;
        wait for 1ns;
        
        -- Enable sprite 0
        -- We should still be in sprite 1 because sprite 0's texture is #0
        s_opcode   <= OP_SPRT_EN;
        s_reg_en   <= '1';
        s_reg_sprt <= "000000";
        assert s_color /= X"00003F" report "7: Wrong texture" severity error;
        wait for 1ns;
        
        -- Change sprite 0's texture
        s_opcode   <= OP_SPRT_TEX;
        s_reg_en   <= '0';
        s_reg_sprt <= "000000";
        s_reg_tex  <= "00000011";
        assert s_color /= X"000036" report "8: Wrong texture" severity error;
        wait for 1ns;
        
        s_opcode  <= OP_NOP;
        s_reg_tex <= "00000000";
        wait for 1ns;
        
        wait;
    end process;

end Behavioral;
