
entity hit_handler is
port (
    i_x        : in vector_pos      (63 downto 0);
    i_y        : in vector_pos      (63 downto 0);
    i_sprite_x : in vector_pos      (63 downto 0);
    i_sprite_y : in vector_pos      (63 downto 0);
    i_en       : in std_logic_vector(63 downto 0);
    i_cc       : in vector_cc       (63 downto 0);

    o_sprite   : out std_logic_vector(5 downto 0);
    o_en       : out std_logic;
) end hit_handler;


architecture behavioral of hit_handler is

    component hit_detector is
    port (
        i_x        : std_logic_vector(8 downto 0);
        i_y        : std_logic_vector(8 downto 0);
        i_sprite_x : std_logic_vector(8 downto 0); 
        i_sprite_y : std_logic_vector(8 downto 0);
        i_en       : std_logic;
        i_cc       : std_logic_vector(5 downto 0);

        o_hit      : std_logic;
    );


    signal s_hits : std_logic_vector(63 downto 0);
    
begin


    -- https://stackoverflow.com/a/13194608
    hit_detector_gen:
    for i in 0 to 63 generate
        hit_detectors: hit_detector
        port map (
            i_x        <= i_x(i),
            i_y        <= i_y(i),
            i_sprite_x <= i_sprite_x(i),
            i_sprite_y <= i_sprite_y(i),
            i_en       <= i_en(i),
            i_cc       <= i_cc(i),
    
            o_hit      <= s_hits(i)
        );
    end generate;

    o_en     <= '1'      when s_hits /= X"0000000000000000";

    o_sprite <= "000000" when s_hits(0)  = '1' else
                "000001" when s_hits(1)  = '1' else
                "000010" when s_hits(2)  = '1' else
                "000011" when s_hits(3)  = '1' else
                "000100" when s_hits(4)  = '1' else
                "000101" when s_hits(5)  = '1' else
                "000110" when s_hits(6)  = '1' else
                "000111" when s_hits(7)  = '1' else
                "001000" when s_hits(8)  = '1' else
                "001001" when s_hits(9)  = '1' else
                "001010" when s_hits(10) = '1' else
                "001011" when s_hits(11) = '1' else
                "001100" when s_hits(12) = '1' else
                "001101" when s_hits(13) = '1' else
                "001110" when s_hits(14) = '1' else
                "001111" when s_hits(15) = '1' else
                "010000" when s_hits(16) = '1' else
                "010001" when s_hits(17) = '1' else
                "010010" when s_hits(18) = '1' else
                "010011" when s_hits(19) = '1' else
                "010100" when s_hits(20) = '1' else
                "010101" when s_hits(21) = '1' else
                "010110" when s_hits(22) = '1' else
                "010111" when s_hits(23) = '1' else
                "011000" when s_hits(24) = '1' else
                "011001" when s_hits(25) = '1' else
                "011010" when s_hits(26) = '1' else
                "011011" when s_hits(27) = '1' else
                "011100" when s_hits(28) = '1' else
                "011101" when s_hits(29) = '1' else
                "011110" when s_hits(30) = '1' else
                "011111" when s_hits(31) = '1' else
                "100000" when s_hits(32) = '1' else
                "100001" when s_hits(33) = '1' else
                "100010" when s_hits(34) = '1' else
                "100011" when s_hits(35) = '1' else
                "100100" when s_hits(36) = '1' else
                "100101" when s_hits(37) = '1' else
                "100110" when s_hits(38) = '1' else
                "100111" when s_hits(39) = '1' else
                "101000" when s_hits(40) = '1' else
                "101001" when s_hits(41) = '1' else
                "101010" when s_hits(42) = '1' else
                "101011" when s_hits(43) = '1' else
                "101100" when s_hits(44) = '1' else
                "101101" when s_hits(45) = '1' else
                "101110" when s_hits(46) = '1' else
                "101111" when s_hits(47) = '1' else
                "110000" when s_hits(48) = '1' else
                "110001" when s_hits(49) = '1' else
                "110010" when s_hits(50) = '1' else
                "110011" when s_hits(51) = '1' else
                "110100" when s_hits(52) = '1' else
                "110101" when s_hits(53) = '1' else
                "110110" when s_hits(54) = '1' else
                "110111" when s_hits(55) = '1' else
                "111000" when s_hits(56) = '1' else
                "111001" when s_hits(57) = '1' else
                "111010" when s_hits(58) = '1' else
                "111011" when s_hits(59) = '1' else
                "111100" when s_hits(60) = '1' else
                "111101" when s_hits(61) = '1' else
                "111110" when s_hits(62) = '1' else
                "111111" when s_hits(63) = '1' else
                "000000"

end behavioral;
