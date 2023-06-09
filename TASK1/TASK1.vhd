library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity TASK1 is
    port (
        clk : in std_logic;
        rst : in std_logic;
        mode : in std_logic;
        a : in std_logic_vector(5 downto 0);
        disp : out std_logic;
        err : out std_logic;
        ptr : out std_logic_vector(2 downto 0)
    );
    subtype pointer is integer range 0 to 5;

end TASK1;

architecture behav of TASK1 is
    signal buf : std_logic_vector(5 downto 0); -- buffer for a
    signal cnt : pointer; -- counter for time of clk
    signal cnt_logic : std_logic_vector(2 downto 0);
    signal cnt2 : std_logic_vector(1 downto 0); -- counter for time of continuous 1
    begin
        process (clk, rst) begin
            if (rst = '1') then
                buf <= "111111";
                cnt <= 0;
                cnt_logic <= "000";
                cnt2 <= "01";
                ptr <= "000";
                err <= '0';
                disp <= '1';
            elsif (clk'event and clk = '1') then
                if (mode = '0') then
                    if (cnt2<3) then
                        buf <= buf;
                        if(cnt<5) then
                            if(buf(cnt+1)='1') then 
                                disp <= '1';
                                if (cnt2 = "10") then
                                    cnt <= cnt + 1;
                                    ptr <= cnt_logic + 1;
                                    cnt_logic <= cnt_logic + 1;
                                    cnt2 <= "11";
                                    err <= '1';
                                else
                                    cnt2 <= cnt2 + 1;
                                    cnt <= cnt + 1;
                                    cnt_logic <= cnt_logic + 1;
                                    err <= '0';
                                    ptr <= "000";
                                end if;
                            else
                                disp <= '0';
                                cnt2 <= "00";
                                cnt <= cnt + 1;
                                cnt_logic <= cnt_logic + 1;
                                err <= '0';
                                ptr <= "000";
                            end if;
                        end if;
                    end if;
                else
                    buf <= a;
                    cnt <= 0;
                    cnt_logic <= "000";
                    if(a(0)='0') then
                        cnt2 <= "00";
                    else
                        cnt2 <= "01";
                    end if;
                    ptr <= "000";
                    err <= '0';
                    disp <= a(0);
                end if; 
            end if;
    end process;
end behav;
