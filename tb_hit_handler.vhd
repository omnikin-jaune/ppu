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

entity tb_hit_handler is end tb_hit_handler;


architecture behavioral of tb_hit_handler is

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
    
    signal s_x   : std_logic_vector(POS_SIZE  downto 0);
    signal s_y   : std_logic_vector(POS_SIZE  downto 0);
    signal s_hit : std_logic;
    
    
    signal s_sprites_x    : vector_sprt_pos := (others => (others => '0'));
    signal s_sprites_y    : vector_sprt_pos := (others => (others => '0'));
    signal s_sprites_en   : std_logic_vector(SPRT_SIZE downto 0) := (others => '0');
    signal s_sprites_cc_0 : std_logic_vector(SPRT_SIZE downto 0) := (others => '0');
    signal s_sprite_cc    : std_logic_vector(CC_SIZE   downto 0) := (others => '0');
    signal s_sprite_id    : std_logic_vector(SPRT_INDX downto 0) := (others => '0');
    
begin

    inst_hit_handler: hit_handler
    port map (
        i_x        => s_x,
        i_y        => s_y,
        i_sprite_x => s_sprites_x,
        i_sprite_y => s_sprites_y,
        i_en       => s_sprites_en,
        i_cc_0     => s_sprites_cc_0,
        o_sprite   => s_sprite_id,
        o_en       => s_hit
    );

    tb_hit_handler : process
    begin
        -- position
        s_x <= std_logic_vector(to_unsigned(32, POS_SIZE + 1));
        s_y <= std_logic_vector(to_unsigned(56, POS_SIZE + 1));
        
        -- sprite 0 is disabled
        s_sprites_en(0) <= '0';
        
        -- sprite 1 just outside area
        s_sprites_x (1) <= std_logic_vector(to_unsigned(35, POS_SIZE + 1));
        s_sprites_y (1) <= std_logic_vector(to_unsigned(52, POS_SIZE + 1));
        s_sprites_en(1) <= '1';
        
        -- sprite 2 with cc 0 (no hit)
        s_sprites_x   (2) <= std_logic_vector(to_unsigned(35, POS_SIZE + 1));
        s_sprites_y   (2) <= std_logic_vector(to_unsigned(58, POS_SIZE + 1));
        s_sprites_en  (2) <= '1';
        s_sprites_cc_0(2) <= '1';
        
        -- sprite 3 should hit
        s_sprites_x   (3) <= std_logic_vector(to_unsigned(41, POS_SIZE + 1));
        s_sprites_y   (3) <= std_logic_vector(to_unsigned(66, POS_SIZE + 1));
        s_sprites_en  (3) <= '1';
        s_sprites_cc_0(3) <= '0';
        
        -- sprite 4 should hit
        s_sprites_x   (4) <= std_logic_vector(to_unsigned(42, POS_SIZE + 1));
        s_sprites_y   (4) <= std_logic_vector(to_unsigned(64, POS_SIZE + 1));
        s_sprites_en  (4) <= '1';
        s_sprites_cc_0(4) <= '0';
        
        wait for 2us;
        
        assert s_sprite_id /= "000011" report "Didn't hit sprite 3" severity error;
        
    end process;

end behavioral;
