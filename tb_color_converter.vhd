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



entity tb_color_converter is end tb_color_converter;

architecture behavioral of tb_color_converter is
  
    component color_converter is
    port (
        i_cc    : in  std_logic_vector(CC_SIZE downto 0);
        o_color : out std_logic_vector(23 downto 0)
    );
    end component;
    
    signal s_cc    : std_logic_vector(CC_SIZE downto 0) := (others => '0');
    signal s_color : std_logic_vector(23 downto 0);
    
begin

    inst_color_converter: color_converter
    port map (
        i_cc    => s_cc,
        o_color => s_color
    );
    
    tb_color_converter : process
    begin
        s_cc <= "000000";
        wait for 100ns;
        s_cc <= "000001";
        wait for 100ns;
        s_cc <= "000011";
        wait for 100ns;
        s_cc <= "100000";
        wait for 100ns;
    end process;

end behavioral;
