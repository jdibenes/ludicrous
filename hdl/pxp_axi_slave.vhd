----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2020 11:45:22 AM
-- Design Name: 
-- Module Name: pxp_axi_slave - behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pxp_axi_slave is
port (
    clk    : in std_logic;
    resetn : in std_logic;

    awvalid : in  std_logic;
    awready : out std_logic;
    awaddr  : in  std_logic_vector(7 downto 0);
    
    wvalid : in  std_logic;
    wready : out std_logic;
    wdata  : in  std_logic_vector(31 downto 0);
    wstrb  : in  std_logic_vector(3 downto 0);
    
    bvalid : out std_logic;
    bready : in  std_logic;
    bresp  : out std_logic_vector(1 downto 0);
    
    arvalid : in  std_logic;
    arready : out std_logic;
    araddr  : in  std_logic_vector(7 downto 0);
    
    rvalid : out std_logic;
    rready : in  std_logic;
    rdata  : out std_logic_vector(31 downto 0);
    rresp  : out std_logic_vector(1 downto 0);
    
    -- pxp signals -------------------------------------------------------------
    R2_11 : out std_logic_vector(31 downto 0);
    R2_12 : out std_logic_vector(31 downto 0);
    R2_13 : out std_logic_vector(31 downto 0);
    
    R2_21 : out std_logic_vector(31 downto 0);
    R2_22 : out std_logic_vector(31 downto 0);
    R2_23 : out std_logic_vector(31 downto 0);
    
    R2_31 : out std_logic_vector(31 downto 0);
    R2_32 : out std_logic_vector(31 downto 0);
    R2_33 : out std_logic_vector(31 downto 0);
    
    t2_1 : out std_logic_vector(31 downto 0);
    t2_2 : out std_logic_vector(31 downto 0);
    t2_3 : out std_logic_vector(31 downto 0);
    
    a1 : out std_logic_vector(31 downto 0);
    b1 : out std_logic_vector(31 downto 0);
    c1 : out std_logic_vector(31 downto 0);
    d1 : out std_logic_vector(31 downto 0);
    e1 : out std_logic_vector(31 downto 0);
    row1 : out std_logic_vector(31 downto 0);
    
    a2 : out std_logic_vector(31 downto 0);
    b2 : out std_logic_vector(31 downto 0);
    c2 : out std_logic_vector(31 downto 0);
    d2 : out std_logic_vector(31 downto 0);
    e2 : out std_logic_vector(31 downto 0);
    row2 : out std_logic_vector(31 downto 0);
    
    push : out std_logic;
    pop : out std_logic;
    
    R_11 : in std_logic_vector(31 downto 0);
    R_12 : in std_logic_vector(31 downto 0);
    R_13 : in std_logic_vector(31 downto 0);
    
    R_21 : in std_logic_vector(31 downto 0);
    R_22 : in std_logic_vector(31 downto 0);
    R_23 : in std_logic_vector(31 downto 0);
    
    R_31 : in std_logic_vector(31 downto 0);
    R_32 : in std_logic_vector(31 downto 0);
    R_33 : in std_logic_vector(31 downto 0);
    
    t_1 : in std_logic_vector(31 downto 0);
    t_2 : in std_logic_vector(31 downto 0);
    t_3 : in std_logic_vector(31 downto 0);
    
    fifo_empty : in std_logic
);
end pxp_axi_slave;

architecture behavioral of pxp_axi_slave is
-- reset -----------------------------------------------------------------------
signal reset : std_logic := '1';

-- write channel ---------------------------------------------------------------
type axiw_state is (axiw_reset, axiw_addr, axiw_data, axiw_resp);

signal wstate      : axiw_state := axiw_reset;
signal wstate_next : axiw_state := axiw_reset;

signal hs_waddr : std_logic := '0';
signal hs_wdata : std_logic := '0';

signal waddr : std_logic_vector(7 downto 0);

-- read channel ----------------------------------------------------------------
type axir_state is (axir_reset, axir_addr, axir_data);

signal rstate      : axir_state := axir_reset;
signal rstate_next : axir_state := axir_reset;

signal hs_raddr : std_logic := '0';

-- registers -------------------------------------------------------------------
begin
-- reset -----------------------------------------------------------------------
reset <= not resetn;

-- write channel fsm -----------------------------------------------------------
wsel : process(wstate, awvalid, wvalid, bready)
begin
    awready <= '0'; hs_waddr <= '0'; wstate_next <= wstate;
    wready  <= '0'; hs_wdata <= '0';
    bvalid  <= '0';
    
    case (wstate) is
    when axiw_addr => awready <= '1'; if (awvalid = '1') then hs_waddr <= '1'; wstate_next <= axiw_data; end if;
    when axiw_data => wready  <= '1'; if (wvalid  = '1') then hs_wdata <= '1'; wstate_next <= axiw_resp; end if;
    when axiw_resp => bvalid  <= '1'; if (bready  = '1') then                  wstate_next <= axiw_addr; end if;
    when others    =>                                                          wstate_next <= axiw_addr;
    end case;
end process;

bresp <= "00";

wfsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then wstate <= axiw_reset; else wstate <= wstate_next; end if;
    end if;
end process;

waddr_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (hs_waddr = '1') then waddr <= awaddr; end if;
    end if;
end process;

-- read channel fsm ------------------------------------------------------------
rsel : process(rstate, arvalid, rready)
begin
    arready <= '0'; hs_raddr <= '0'; rstate_next <= rstate;
    rvalid  <= '0';
    
    case (rstate) is
    when axir_addr => arready <= '1'; if (arvalid = '1') then hs_raddr <= '1'; rstate_next <= axir_data; end if;
    when axir_data => rvalid  <= '1'; if (rready  = '1') then                  rstate_next <= axir_addr; end if;
    when others    =>                                                          rstate_next <= axir_addr;
    end case;
end process;

rresp <= "00";

rfsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then rstate <= axir_reset; else rstate <= rstate_next; end if;
    end if;
end process;

-- registers -------------------------------------------------------------------
push <= '1' when waddr = x"60" and wdata(0) = '1' and hs_wdata = '1' else '0';
pop  <= '1' when waddr = x"60" and wdata(2) = '1' and hs_wdata = '1' else '0';

wdata_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (hs_wdata = '1') then
            case (waddr) is
            when x"00" => R2_11 <= wdata;
            when x"04" => R2_12 <= wdata;
            when x"08" => R2_13 <= wdata;
            when x"0C" => R2_21 <= wdata;
            when x"10" => R2_22 <= wdata;
            when x"14" => R2_23 <= wdata;
            when x"18" => R2_31 <= wdata;
            when x"1C" => R2_32 <= wdata;
            when x"20" => R2_33 <= wdata;
            
            when x"24" => t2_1 <= wdata;
            when x"28" => t2_2 <= wdata;
            when x"2C" => t2_3 <= wdata;
            
            when x"30" => a1 <= wdata;
            when x"34" => b1 <= wdata;
            when x"38" => c1 <= wdata;
            when x"3C" => d1 <= wdata;
            when x"40" => e1 <= wdata;
            when x"44" => row1 <= wdata;
            
            when x"48" => a2 <= wdata;
            when x"4C" => b2 <= wdata;
            when x"50" => c2 <= wdata;
            when x"54" => d2 <= wdata;
            when x"58" => e2 <= wdata;
            when x"5C" => row2 <= wdata;
            
            when others =>
            end case;
        end if;
    end if;
end process;

rdata_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (hs_raddr = '1') then
            case (araddr) is          
            when x"60" => rdata <= (1 => fifo_empty, others => '0');
            
            when x"64" => rdata <= R_11;
            when x"68" => rdata <= R_12;
            when x"6C" => rdata <= R_13;
            when x"70" => rdata <= R_21;
            when x"74" => rdata <= R_22;
            when x"78" => rdata <= R_23;
            when x"7C" => rdata <= R_31;
            when x"80" => rdata <= R_32;
            when x"84" => rdata <= R_33;
            
            when x"88" => rdata <= t_1;
            when x"8C" => rdata <= t_2;
            when x"90" => rdata <= t_3;

            when others => rdata <= x"FFFFFFFF";
            end case;
        end if;
    end if;
end process;
end behavioral;
