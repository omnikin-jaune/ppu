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

entity frame_printer is
port (
    i_clk : in  std_logic;
    i_rst : in  std_logic;
    i_x   : in  std_logic_vector(7 downto 0);
    i_y   : in  std_logic_vector(7 downto 0);

    o_sof : out std_logic;
    o_eof : out std_logic;
    o_sol : out std_logic;
    o_eol : out std_logic
); end frame_printer;


architecture behavioral of frame_printer is

    signal s_old_x   : std_logic_vector(7 downto 0) := (others => '0');
    signal s_old_y   : std_logic_vector(7 downto 0) := (others => '0');
    signal s_old_rst : std_logic := '1';
begin

    process(i_clk, i_rst, i_x, i_y, s_old_x, s_old_y)
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '1') then
                s_old_x   <= (others => '0');
                s_old_y   <= (others => '0');
                s_old_rst <= '1';
            else
                o_sol <= '1' when (i_x = x"00" and (s_old_x = x"FF" or s_old_rst = '1')) else '0';
                o_sof <= '1' when (i_y = x"00" and (s_old_y = x"EF" or s_old_rst = '1')) else '0';
                o_eol <= '1' when (i_x = x"FF" and s_old_x = x"FE") else '0';
                o_eof <= '1' when (i_y = x"FF" and s_old_x = x"EE") else '0';
            end if;
        end if;

        -- Update old values of x and y on falling edge
        if (falling_edge(i_clk)) then
            if (i_rst = '1') then
                s_old_x   <= (others => '0');
                s_old_y   <= (others => '0');
                s_old_rst <= '1';
            else
                s_old_x   <= i_x;
                s_old_y   <= i_y;
                s_old_rst <= '0';
            end if;
        end if;
    end process;

end behavioral;
