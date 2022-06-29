---------------------------------------------------------------------------------------------
--
--	Pascal-Emmanuel Lachance | raesangur
--
--  github.com/omnikin-jaune/
--
---------------------------------------------------------------------------------------------

entity color_converter is
port (
    i_cc    : in  std_logic_vector(5  downto 0);
    o_color : out std_logic_vector(23 downto 0);
) end color_converter;


architecture behavioral of color_converter is

    signal colors : ram_colors(0 to 63) := 
    0  => X"000000",
    1  => X"000000",
    2  => X"000000",
    3  => X"000000",
    4  => X"000000",
    5  => X"000000",
    6  => X"000000",
    7  => X"000000",
    8  => X"000000",
    9  => X"000000",
    10 => X"000000",
    11 => X"000000",
    12 => X"000000",
    13 => X"000000",
    14 => X"000000",
    15 => X"000000",
    16 => X"000000",
    17 => X"000000",
    18 => X"000000",
    19 => X"000000",
    20 => X"000000",
    21 => X"000000",
    22 => X"000000",
    23 => X"000000",
    24 => X"000000",
    25 => X"000000",
    26 => X"000000",
    27 => X"000000",
    28 => X"000000",
    29 => X"000000",
    30 => X"000000",
    31 => X"000000",
    32 => X"000000",
    33 => X"000000",
    34 => X"000000",
    35 => X"000000",
    36 => X"000000",
    37 => X"000000",
    38 => X"000000",
    39 => X"000000",
    40 => X"000000",
    41 => X"000000",
    42 => X"000000",
    43 => X"000000",
    44 => X"000000",
    45 => X"000000",
    46 => X"000000",
    47 => X"000000",
    48 => X"000000",
    49 => X"000000",
    50 => X"000000",
    51 => X"000000",
    52 => X"000000",
    53 => X"000000",
    54 => X"000000",
    55 => X"000000",
    56 => X"000000",
    57 => X"000000",
    58 => X"000000",
    59 => X"000000",
    60 => X"000000",
    61 => X"000000",
    62 => X"000000",
    63 => X"000000";
    
begin
    o_color <= colors(to_integer(i_cc));
end behavioral;
