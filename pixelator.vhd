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


entity pixelator is
port (
    i_clk    : in  std_logic;
    i_rst    : in  std_logic;
    i_opcode : in  std_logic_vector(4 downto 0);
    i_reg_x  : in  std_logic_vector(8 downto 0);
    i_reg_y  : in  std_logic_vector(8 downto 0);

    o_x      : out std_logic_vector(7 downto 0);
    o_y      : out std_logic_vector(7 downto 0);
    o_x_off  : out std_logic_vector(8 downto 0);    -- x value with added offset
    o_y_off  : out std_logic_vector(8 downto 0);    -- y value with added offset
) end pixelator;



architecture behavioral of pixelator is

    signal r_x     : std_logic_vector(7 downto 0) := others => '0';
    signal r_y     : std_logic_vector(7 downto 0) := others => '0';

    signal r_x_off : std_logic_vector(8 downto 0) := others => '0';
    signal r_y_off : std_logic_vector(8 downto 0) := others => '0';

begin

    o_x     <= r_x;
    o_y     <= r_y;
    o_x_off <= r_x + r_x_off;
    o_y_off <= r_y + r_y_off;

    process(i_clk, i_rst, r_x, r_y, i_opcode, i_reg_x, i_reg_y)
        if (i_rst = '1') then
            r_x     <= '0';
            r_y     <= '0';
            r_x_off <= '0';
            r_y_off <= '0';
        else
            if (rising_edge(i_clk)) then
                r_x <= r_x + 1;                                                     -- will wrap around automatically with overflow
                r_y <= r_y + 1 when to_unsigned(r_y) < 239 else (others => '0');    -- might want to be 240 instead of 239 (#TODO)

                if (i_opcode = OP_PIX_OFF) then
                    r_x_off <= i_reg_x;
                    r_y_off <= i_reg_y;
                end if;
            end if;
        end if;
    end process;
end behavioral;
