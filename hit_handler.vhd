library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ppu_package.all;
use work.sprite_package.all;


entity hit_handler is
port (
    i_x        : in std_logic_vector(POS_SIZE downto 0);
    i_y        : in std_logic_vector(POS_SIZE downto 0);
    i_sprite_x : in vector_sprt_pos;
    i_sprite_y : in vector_sprt_pos;
    i_en       : in std_logic_vector(SPRT_SIZE downto 0);
    i_cc_0     : in std_logic_vector(SPRT_SIZE downto 0);

    o_sprite   : out std_logic_vector(SPRT_INDX downto 0);
    o_en       : out std_logic
); end hit_handler;


architecture behavioral of hit_handler is

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
    
begin

    -- https://stackoverflow.com/a/13194608
    hit_detector_gen:
    for i in 0 to SPRT_SIZE generate
        hit_detectors: hit_detector
        port map (
            i_x        => i_x,
            i_y        => i_y,
            i_sprite_x => i_sprite_x(i),
            i_sprite_y => i_sprite_y(i),
            i_en       => i_en(i),
            o_hit      => s_hits(i)
        );
    end generate;

    o_en     <= '1'      when s_hits /= X"0000000000000000" and
                              i_cc_0 /= X"0000000000000000";

    o_sprite <= "000000" when s_hits(0)  = '1' and i_cc_0(0)  = '0' else
                "000001" when s_hits(1)  = '1' and i_cc_0(1)  = '0' else
                "000010" when s_hits(2)  = '1' and i_cc_0(2)  = '0' else
                "000011" when s_hits(3)  = '1' and i_cc_0(3)  = '0' else
                "000100" when s_hits(4)  = '1' and i_cc_0(4)  = '0' else
                "000101" when s_hits(5)  = '1' and i_cc_0(5)  = '0' else
                "000110" when s_hits(6)  = '1' and i_cc_0(6)  = '0' else
                "000111" when s_hits(7)  = '1' and i_cc_0(7)  = '0' else
                "001000" when s_hits(8)  = '1' and i_cc_0(8)  = '0' else
                "001001" when s_hits(9)  = '1' and i_cc_0(9)  = '0' else
                "001010" when s_hits(10) = '1' and i_cc_0(10) = '0' else
                "001011" when s_hits(11) = '1' and i_cc_0(11) = '0' else
                "001100" when s_hits(12) = '1' and i_cc_0(12) = '0' else
                "001101" when s_hits(13) = '1' and i_cc_0(13) = '0' else
                "001110" when s_hits(14) = '1' and i_cc_0(14) = '0' else
                "001111" when s_hits(15) = '1' and i_cc_0(15) = '0' else
                "010000" when s_hits(16) = '1' and i_cc_0(16) = '0' else
                "010001" when s_hits(17) = '1' and i_cc_0(17) = '0' else
                "010010" when s_hits(18) = '1' and i_cc_0(18) = '0' else
                "010011" when s_hits(19) = '1' and i_cc_0(19) = '0' else
                "010100" when s_hits(20) = '1' and i_cc_0(20) = '0' else
                "010101" when s_hits(21) = '1' and i_cc_0(21) = '0' else
                "010110" when s_hits(22) = '1' and i_cc_0(22) = '0' else
                "010111" when s_hits(23) = '1' and i_cc_0(23) = '0' else
                "011000" when s_hits(24) = '1' and i_cc_0(24) = '0' else
                "011001" when s_hits(25) = '1' and i_cc_0(25) = '0' else
                "011010" when s_hits(26) = '1' and i_cc_0(26) = '0' else
                "011011" when s_hits(27) = '1' and i_cc_0(27) = '0' else
                "011100" when s_hits(28) = '1' and i_cc_0(28) = '0' else
                "011101" when s_hits(29) = '1' and i_cc_0(29) = '0' else
                "011110" when s_hits(30) = '1' and i_cc_0(30) = '0' else
                "011111" when s_hits(31) = '1' and i_cc_0(31) = '0' else
                "100000" when s_hits(32) = '1' and i_cc_0(32) = '0' else
                "100001" when s_hits(33) = '1' and i_cc_0(33) = '0' else
                "100010" when s_hits(34) = '1' and i_cc_0(34) = '0' else
                "100011" when s_hits(35) = '1' and i_cc_0(35) = '0' else
                "100100" when s_hits(36) = '1' and i_cc_0(36) = '0' else
                "100101" when s_hits(37) = '1' and i_cc_0(37) = '0' else
                "100110" when s_hits(38) = '1' and i_cc_0(38) = '0' else
                "100111" when s_hits(39) = '1' and i_cc_0(39) = '0' else
                "101000" when s_hits(40) = '1' and i_cc_0(40) = '0' else
                "101001" when s_hits(41) = '1' and i_cc_0(41) = '0' else
                "101010" when s_hits(42) = '1' and i_cc_0(42) = '0' else
                "101011" when s_hits(43) = '1' and i_cc_0(43) = '0' else
                "101100" when s_hits(44) = '1' and i_cc_0(44) = '0' else
                "101101" when s_hits(45) = '1' and i_cc_0(45) = '0' else
                "101110" when s_hits(46) = '1' and i_cc_0(46) = '0' else
                "101111" when s_hits(47) = '1' and i_cc_0(47) = '0' else
                "110000" when s_hits(48) = '1' and i_cc_0(48) = '0' else
                "110001" when s_hits(49) = '1' and i_cc_0(49) = '0' else
                "110010" when s_hits(50) = '1' and i_cc_0(50) = '0' else
                "110011" when s_hits(51) = '1' and i_cc_0(51) = '0' else
                "110100" when s_hits(52) = '1' and i_cc_0(52) = '0' else
                "110101" when s_hits(53) = '1' and i_cc_0(53) = '0' else
                "110110" when s_hits(54) = '1' and i_cc_0(54) = '0' else
                "110111" when s_hits(55) = '1' and i_cc_0(55) = '0' else
                "111000" when s_hits(56) = '1' and i_cc_0(56) = '0' else
                "111001" when s_hits(57) = '1' and i_cc_0(57) = '0' else
                "111010" when s_hits(58) = '1' and i_cc_0(58) = '0' else
                "111011" when s_hits(59) = '1' and i_cc_0(59) = '0' else
                "111100" when s_hits(60) = '1' and i_cc_0(60) = '0' else
                "111101" when s_hits(61) = '1' and i_cc_0(61) = '0' else
                "111110" when s_hits(62) = '1' and i_cc_0(62) = '0' else
                "111111" when s_hits(63) = '1' and i_cc_0(63) = '0' else
                "000000";

end behavioral;
