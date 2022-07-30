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


entity tb_pixelator is end tb_pixelator;

  
architecture behavioral of tb_pixelator is
    component pixelator is
    port (
        i_clk    : in  std_logic;
        i_rst    : in  std_logic;
        i_opcode : in  std_logic_vector(OP_SIZE downto 0);
        i_reg_x  : in  std_logic_vector(8 downto 0);
        i_reg_y  : in  std_logic_vector(8 downto 0);

        o_x      : out std_logic_vector(7 downto 0);
        o_y      : out std_logic_vector(7 downto 0);
        o_x_off  : out std_logic_vector(8 downto 0);    -- x value with added offset
        o_y_off  : out std_logic_vector(8 downto 0)     -- y value with added offset
    );
    end component;

    component frame_printer is
    port (
        i_clk : in  std_logic;
        i_rst : in  std_logic;
        i_x   : in  std_logic_vector(7 downto 0);
        i_y   : in  std_logic_vector(7 downto 0);

        o_sof : out std_logic;
        o_eof : out std_logic;
        o_sol : out std_logic;
        o_eol : out std_logic
    );
    end component;


    signal s_clk : std_logic:= '0';
    signal s_rst : std_logic:= '1';
    
    signal s_opcode : std_logic_vector(OP_SIZE  downto 0) := (others => '0');
    signal s_reg_x  : std_logic_vector(POS_SIZE downto 0) := (others => '0');
    signal s_reg_y  : std_logic_vector(POS_SIZE downto 0) := (others => '0');

    signal s_x_offset   : std_logic_vector(8 downto 0)  := (others => '0');
    signal s_y_offset   : std_logic_vector(8 downto 0)  := (others => '0');
    signal s_x          : std_logic_vector(7 downto 0)  := (others => '0');
    signal s_y          : std_logic_vector(7 downto 0)  := (others => '0');

    signal s_sol : std_logic;
    signal s_eol : std_logic;
    signal s_sof : std_logic;
    signal s_eof : std_logic;


    
begin

    inst_pixelator: pixelator
    port map (
        i_clk    => s_clk,
        i_rst    => s_rst,
        i_opcode => s_opcode,
        i_reg_x  => s_reg_x,
        i_reg_y  => s_reg_y,

        o_x      => s_x,
        o_y      => s_y,
        o_x_off  => s_x_offset,
        o_y_off  => s_y_offset
    );

    inst_frame_printer: frame_printer
    port map (
        i_clk => s_clk,
        i_rst => s_rst,
        i_x   => s_x,
        i_y   => s_y,

        o_sof => s_sof,
        o_eof => s_eof,
        o_sol => s_sol,
        o_eol => s_eol
    );
    
    clock : process
    begin 
        s_clk <=  '1';
        wait for 1ns;
        s_clk <= '0';
        wait for 1ns;
    end process;
    
    tb_pixelator : process
    begin
        s_rst <= '0';
        
        -- Change pixel offset
        wait for 600ns;
        s_opcode <= OP_PIX_OFF;
        s_reg_x <= "100000000";
        s_reg_y <= "100000000";
        
        wait for 1ns;
        s_opcode <= OP_NOP;
        
        wait for 20us;
    end process;
end behavioral;
