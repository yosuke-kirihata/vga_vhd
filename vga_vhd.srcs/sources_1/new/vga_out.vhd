----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/11/09 21:21:36
-- Design Name: 
-- Module Name: vga_out - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_out is
    port(
        CLK    : in std_logic;
        RST    : in std_logic;
        VSYNCX : out std_logic;
        HSYNCX : out std_logic;
        RED    : out std_logic_vector(3 downto 0);
        GREEN  : out std_logic_vector(3 downto 0);
        BLUE   : out std_logic_vector(3 downto 0)
    );
end vga_out;


architecture RTL of vga_out is
    constant V_SYNC_PULSE : integer := 4;--2;
    constant V_BACK_PORCH : integer := 23;--33;
    constant V_FRONT_PORCH : integer := 1;--10;
    constant V_ACTIVE_VIDEO : integer := 600;--480;
    constant V_SUM  : integer := (V_SYNC_PULSE + V_BACK_PORCH + V_FRONT_PORCH + V_ACTIVE_VIDEO);

    constant H_SYNC_PULSE : integer := 128;--96;
    constant H_BACK_PORCH : integer := 88;--48;
    constant H_FRONT_PORCH : integer := 40;--16;
    constant H_ACTIVE_VIDEO : integer := 800;--640;
    constant H_SUM  : integer := (H_SYNC_PULSE + H_BACK_PORCH + H_FRONT_PORCH + H_ACTIVE_VIDEO);
    
--    reg [11:0] hcount, vcount;
    signal hcount, vcount : std_logic_vector(11 downto 0);
--    wire pclk;
    signal pclk : std_logic;
--    assign pclk = clk;--??
--    pclk <= CLK;
begin

--    assign hsyncx = (hcount <= H_SYNC_PULSE) ? 1 : 0;
HSYNCX <= '1' when (hcount <= H_SYNC_PULSE) else '0';
--    always @ (posedge pclk or posedge rst) begin
--        if (rst)
--            hcount <= 10'd0;
--        else if (hcount == H_SUM)
--            hcount <= 10'd0;
--        else
--            hcount <= hcount + 1;
--    end
    process (CLK) begin
        if(rising_edge(CLK)) then
            if (RST = '1') then
                hcount <= (others => '0');
            else
                if conv_integer(hcount) = H_SUM then
                    hcount <= (others => '0');--??
                else
                    hcount <= hcount + 1;
                end if;
            end if;
        end if;
    end process;

--    assign vsyncx =  (vcount < V_SYNC_PULSE) ? 1 : 0;
VSYNCX <= '1' when (vcount <= V_SYNC_PULSE) else '0';
--    always @ (posedge pclk or posedge rst) begin
--        if (rst)
--            vcount <= 10'd0;
--        else if (hcount == H_SUM) begin
--            if (vcount == V_SUM)
--                 vcount <= 10'd0;
--            else
--                 vcount <= vcount + 1;
--            end
--        else
--            vcount <= vcount;
--    end
    process (CLK) begin
        if(rising_edge(CLK)) then
            if (RST = '1') then
                vcount <= (others => '0');
            else
                if (conv_integer(hcount) = H_SUM) then
                    if (conv_integer(vcount) = V_SUM) then
                        vcount <= (others => '0');--??
                    else
                        vcount <= vcount + 1;
                    end if;
                --else
                    --vcount <= vcount;
                end if;
            end if;
        end if;
    end process;


--    always @ (posedge pclk or posedge rst) begin
--        if (rst) begin
--            red <= 4'b0000;
--            green <= 4'b0000;
--            blue <= 4'b0000;
--        end
--        else if ( ( ((V_SYNC_PULSE+ V_BACK_PORCH) <= vcount) && (vcount <= (V_SYNC_PULSE+ V_BACK_PORCH+V_ACTIVE_VIDEO)) )
--        && ( ((H_SYNC_PULSE + H_BACK_PORCH) <= hcount) && (hcount <= (H_SYNC_PULSE+ H_BACK_PORCH+H_ACTIVE_VIDEO)) ) ) begin
--                if (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+200)) begin
--                    red <= 4'b1111;
--                    green <= 4'b0000;
--                    blue <= 4'b0000;
--                end
--                else if (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+400)) begin
--                    red <= 4'b0000;
--                    green <= 4'b1111;
--                    blue <= 4'b0000;
--                end
--                else if (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+600)) begin
--                    red <= 4'b0000;
--                    green <= 4'b0000;
--                    blue <= 4'b1111;
--                end
--                else begin
--                    red <= 4'b0000;
--                    green <= 4'b0000;
--                    blue <= 4'b0000;
--                end
--          end
--        else begin
--            red <= 4'b0000;
--            green <= 4'b0000;
--            blue <= 4'b0000;
--        end
--    end
    process (CLK) begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                red <= B"0000"; --(others => '0')
                green <= B"0000";
                blue <= B"0000";
            else
                if ( ( ((V_SYNC_PULSE+ V_BACK_PORCH) <= vcount) and (vcount <= (V_SYNC_PULSE+ V_BACK_PORCH+V_ACTIVE_VIDEO)) )
                and ( ((H_SYNC_PULSE + H_BACK_PORCH) <= hcount) and (hcount <= (H_SYNC_PULSE+ H_BACK_PORCH+H_ACTIVE_VIDEO)) ) ) then
--                    red <= B"0000";
--                    green <= B"1111"; --(others => '1')
--                    blue <= B"0000";
                    if (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+100)) then--black
					    red <= B"0000";
                        green <= B"0000";
                        blue <= B"0000";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+200)) then--red
                        red <= B"1111";
                        green <= B"0000";
                        blue <= B"0000";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+300)) then--blue
					    red <= B"0000";
                        green <= B"1111";
                        blue <= B"0000";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+400)) then--green
					    red <= B"0000";
                        green <= B"0000";
                        blue <= B"1111";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+500)) then--yellow
                        red <= B"1111";
                        green <= B"1111";
                        blue <= B"0000";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+600)) then--cyan
                        red <= B"0000";
                        green <= B"1111";
                        blue <= B"1111";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+700)) then--magenta
                        red <= B"1111";
                        green <= B"0000";
                        blue <= B"1111";
                    else--while
                        red <= B"1111";
                        green <= B"1111";
                        blue <= B"1111";                   
                    end if;
                else
                    red <= B"0000";
                    green <= B"0000";
                    blue <= B"0000";
                end if;
            end if;
        end if;
    end process;
    
end RTL;