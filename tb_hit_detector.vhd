library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ppu_package.all;
use work.sprite_package.all;

entity tb_hit_detector is end tb_hit_detector;

architecture behavioral of tb_hit_detector is

    component hit_detector is
    port (
        i_x        : in  std_logic_vector(POS_SIZE downto 0);
        i_y        : in  std_logic_vector(POS_SIZE downto 0);
        i_sprite_x : in  std_logic_vector(POS_SIZE downto 0); 
        i_sprite_y : in  std_logic_vector(POS_SIZE downto 0);
        i_en       : in  std_logic;
        o_hit      : out std_logic
    );
    end component;


    signal s_hits : std_logic_vector(63 downto 0);
    
    signal s_x      : std_logic_vector(POS_SIZE  downto 0) := (others => '0');
    signal s_y      : std_logic_vector(POS_SIZE  downto 0) := (others => '0');
    signal s_sprt_x : vector_sprt_pos := (others => (others => '0'));
    signal s_sprt_y : vector_sprt_pos := (others => (others => '0'));
    signal s_en     : std_logic_vector(SPRT_SIZE downto 0) := (others => '0');
    
begin

    -- https://stackoverflow.com/a/13194608
    hit_detector_gen:
    for i in 0 to SPRT_SIZE generate
        hit_detectors: hit_detector
        port map (
            i_x        => s_x,
            i_y        => s_y,
            i_sprite_x => s_sprt_x(i),
            i_sprite_y => s_sprt_y(i),
            i_en       => s_en(i),
            o_hit      => s_hits(i)
        );
    end generate;

tb_hit_detector : process
begin
    s_x <= std_logic_vector(to_unsigned(32, POS_SIZE + 1));
    s_y <= std_logic_vector(to_unsigned(56, POS_SIZE + 1));
    
    -- sprite 0 disabled
    s_en(0) <= '0';
    
    -- sprite 1 just outside area
    s_sprt_x(1) <= std_logic_vector(to_unsigned(35, POS_SIZE + 1));
    s_sprt_y(1) <= std_logic_vector(to_unsigned(52, POS_SIZE + 1));
    s_en    (1) <= '1';
    
    -- sprite 2 should hit
    s_sprt_x(2) <= std_logic_vector(to_unsigned(35, POS_SIZE + 1));
    s_sprt_y(2) <= std_logic_vector(to_unsigned(58, POS_SIZE + 1));
    s_en    (2) <= '1';
    
    -- sprite 3 should hit
    s_sprt_x(3) <= std_logic_vector(to_unsigned(41, POS_SIZE + 1));
    s_sprt_y(3) <= std_logic_vector(to_unsigned(66, POS_SIZE + 1));
    s_en    (3) <= '1';
    
    wait for 2us;
    
    assert s_hits(0) /= '0' report "Sprite 0 should be disabled" severity warning;
    assert s_hits(1) /= '0' report "Sprite 1 should be disabled" severity warning;
    assert s_hits(2) /= '1' report "Sprite 2 should be enabled"  severity warning;
    assert s_hits(3) /= '1' report "Sprite 3 should be enabled"  severity warning;
    
end process;

end behavioral;
