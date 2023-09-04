----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2023 09:43:41 AM
-- Design Name: 
-- Module Name: vga_driver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_driver is
    Port ( clk : in STD_LOGIC;
           res : in std_logic;
           r_in : in STD_LOGIC_VECTOR (3 downto 0);
           g_in : in STD_LOGIC_VECTOR (3 downto 0);
           b_in : in STD_LOGIC_VECTOR (3 downto 0);
           r_out : out STD_LOGIC_VECTOR (3 downto 0);
           g_out : out STD_LOGIC_VECTOR (3 downto 0);
           b_out : out STD_LOGIC_VECTOR (3 downto 0);
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           active : out STD_LOGIC;
           h_count_out : out STD_LOGIC_VECTOR(9 downto 0);
           v_count_out : out STD_LOGIC_VECTOR(9 downto 0)
     );
end vga_driver;

architecture Behavioral of vga_driver is
    constant h_active : unsigned(9 downto 0) := to_unsigned(640,10);
    constant h_front_porch : unsigned(9 downto 0) := to_unsigned(656,10);
    constant h_sync_pulse : unsigned(9 downto 0) := to_unsigned(752,10);
    constant h_back_porch : unsigned(9 downto 0) := to_unsigned(799,10);

    constant v_active : unsigned(9 downto 0) := to_unsigned(480,10);
    constant v_front_porch : unsigned(9 downto 0) := to_unsigned(490,10);
    constant v_sync_pulse : unsigned(9 downto 0) := to_unsigned(492,10);
    constant v_back_porch : unsigned(9 downto 0) := to_unsigned(524,10);  

    signal vga_clk : std_logic;
    signal v_count, h_count : unsigned(9 downto 0);
    signal clk_divider : unsigned (1 downto 0);
begin
    vga_clk_gen : process( clk, res) begin
        if res = '0' then
            vga_clk <= '0';   
            clk_divider <= (others => '0'); 
        elsif rising_edge(clk) then
            vga_clk <= '0';
            clk_divider <= clk_divider + 1;
            if clk_divider = 3 then
                vga_clk <= '1';
            end if ;
        end if ;
    end process ; -- vga_clk_gen


    vga_process : process( vga_clk, res)  begin
        if res = '0' then
            r_out <= (others => '0');
            g_out <= (others => '0');
            b_out <= (others => '0');
            v_count <= (others => '0');
            h_count <= (others => '0');
            active <= '0';
        elsif rising_edge(vga_clk) then
            --Attivazione dei segnali
            if v_count > v_active - 1 or h_count > h_active - 1  then
                r_out <= (others => '0');
                g_out <= (others => '0');
                b_out <= (others => '0');
            else
                r_out <= r_in;
                g_out <= g_in;
                b_out <= b_in;
            end if ;

            --Conteggio dei pixel
            h_count <= h_count + 1;
            if h_count = h_back_porch - 1  then
                h_count <= (others => '0');
                v_count <= v_count + 1;
                if v_count = v_back_porch - 1 then
                    v_count <= (others => '0');
                end if ;
            end if ;
        end if ;

        --Active sign.
        if v_count < v_active and h_count < h_active then
            active <= '1';
        else
            active <= '0';
        end if ;
    end process ; -- vga_process

    --Sync sign.
    vs <= '0' when v_count >= v_front_porch and v_count < v_sync_pulse else '1';
    hs <= '0' when h_count >= h_front_porch and h_count < h_sync_pulse else '1';
    h_count_out <= std_logic_vector(h_count);
    v_count_out <= std_logic_vector(v_count);
    
end Behavioral;
