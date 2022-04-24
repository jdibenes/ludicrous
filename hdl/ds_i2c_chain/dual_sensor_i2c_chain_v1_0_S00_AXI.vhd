-- SIM OK 03/21/2019

-- I/O map ---------------------------------------------------------------------
--0x00 CAM_CNTL0 (R/W)
--0:    tmr0_start  : out std_logic; -- pulse (W)
--1:    tmr0_enable : out std_logic; -- hold
--2:    tmr0_done   : in  std_logic; 
--3:    tmr1_start  : out std_logic; -- pulse (W)
--4:    tmr1_enable : out std_logic; -- hold
--5:    tmr1_done   : in  std_logic;
--6:    rom0_done   : in  std_logic;
--7:    rom1_done   : in  std_logic;
--15: 8 cam_vflip   : out std_logic_vector( 7 downto 0) -- hold;
--23:16 cam_dgain   : out std_logic_vector( 7 downto 0) -- hold;

--0x04 CAM_CNTL1 (R/W)
--15: 0 cam_again : out std_logic_vector(15 downto 0) -- hold;
--31:16 cam_ctime : out std_logic_vector(15 downto 0) -- hold;

--0x08 TMR0_LOAD (R/W)
--31: 0 tmr0_load : out std_logic_vector(31 downto 0) -- hold;

--0x0C TMR1_LOAD (R/W)
--31: 0 tmr1_load : out std_logic_vector(31 downto 0) -- hold;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s_axi_interface is
generic (
    tmr_length : integer := 32;
    addr_width : integer :=  4;
    data_width : integer := 32
);
port (
    clk	  : in std_logic;
    reset : in std_logic;
    
    tmr0_start  : out std_logic;
    tmr0_load   : out std_logic_vector(tmr_length - 1 downto 0);
    tmr0_enable : out std_logic;
    tmr0_done   : in  std_logic;
    
    tmr1_start  : out std_logic;
    tmr1_load   : out std_logic_vector(tmr_length - 1 downto 0);
    tmr1_enable : out std_logic;
    tmr1_done   : in  std_logic;
    
    rom0_done : in std_logic;
    rom1_done : in std_logic;
    
    cam_vflip : out std_logic_vector( 7 downto 0);
    cam_dgain : out std_logic_vector( 7 downto 0);
    cam_again : out std_logic_vector(15 downto 0);
    cam_ctime : out std_logic_vector(15 downto 0);
    
    S_AXI_AWADDR  : in  std_logic_vector(addr_width     - 1 downto 0);
    S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);
    S_AXI_AWVALID : in  std_logic;
    S_AXI_AWREADY : out std_logic;
    S_AXI_WDATA	  : in  std_logic_vector(data_width     - 1 downto 0);
    S_AXI_WSTRB	  : in  std_logic_vector(data_width / 8 - 1 downto 0);
    S_AXI_WVALID  : in  std_logic;
    S_AXI_WREADY  : out std_logic;
    S_AXI_BRESP	  : out std_logic_vector(1 downto 0);
    S_AXI_BVALID  : out std_logic;
    S_AXI_BREADY  : in  std_logic;
    S_AXI_ARADDR  : in  std_logic_vector(addr_width     - 1 downto 0);
    S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);
    S_AXI_ARVALID : in  std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA	  : out std_logic_vector(data_width     - 1 downto 0);
    S_AXI_RRESP	  : out std_logic_vector(1 downto 0);
    S_AXI_RVALID  : out std_logic;
    S_AXI_RREADY  : in  std_logic
);
end s_axi_interface;

architecture arch_imp of s_axi_interface is
type wrstates is (wrreset, wridle, wrdata, wrresp);
type rdstates is (rdreset, rdidle, rddata, rdresp);

constant ADDR_CAM_CNTL0 : integer := 16#00#;
constant ADDR_CAM_CNTL1 : integer := 16#04#;
constant ADDR_TMR0_LOAD : integer := 16#08#;
constant ADDR_TMR1_LOAD : integer := 16#0C#;

signal wrstate : wrstates;
signal wrnext  : wrstates;

signal rdstate : rdstates;
signal rdnext  : rdstates;

signal aw_hs  : std_logic;
signal w_hs   : std_logic;
signal ar_hs  : std_logic;
signal awaddr : unsigned(addr_width - 1 downto 0);

signal r_tmr0_load   : std_logic_vector(32 downto 0);
signal r_tmr0_enable : std_logic;
signal r_tmr1_load   : std_logic_vector(32 downto 0);
signal r_tmr1_enable : std_logic;
signal r_cam_vflip   : std_logic_vector( 7 downto 0);
signal r_cam_dgain   : std_logic_vector( 7 downto 0);
signal r_cam_again   : std_logic_vector(15 downto 0);
signal r_cam_ctime   : std_logic_vector(15 downto 0);
begin
-- -----------------------------------------------------------------------------
-- write fsm
-- -----------------------------------------------------------------------------
write_fsm_control : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then wrstate <= wrreset; else wrstate <= wrnext; end if;
    end if;
end process;

write_fsm : process (wrstate, S_AXI_AWVALID, S_AXI_WVALID, S_AXI_BREADY)
begin
    S_AXI_AWREADY <= '0';
    S_AXI_WREADY  <= '0';
    S_AXI_BVALID  <= '0';
    aw_hs         <= '0';
    w_hs          <= '0';

    case (wrstate) is
    when wrreset =>                                                                   wrnext <= wridle;
    when wridle  => S_AXI_AWREADY <= '1'; if (S_AXI_AWVALID = '1') then aw_hs <= '1'; wrnext <= wrdata; else wrnext <= wridle; end if;
    when wrdata  => S_AXI_WREADY  <= '1'; if (S_AXI_WVALID  = '1') then w_hs  <= '1'; wrnext <= wrresp; else wrnext <= wrdata; end if;
    when wrresp  => S_AXI_BVALID  <= '1'; if (S_AXI_BREADY  = '1') then               wrnext <= wridle; else wrnext <= wrresp; end if;
    when others  =>                                                                   wrnext <= wridle;
    end case;
end process;

write_addr : process (clk)
begin
    if (rising_edge(clk)) then
        if (aw_hs = '1') then awaddr <= unsigned(S_AXI_AWADDR); end if;
    end if;
end process;

write_reg_cntl : process (clk)
begin
    if (rising_edge(clk)) then
        if (w_hs = '1') then
            case (to_integer(awaddr)) is
            when ADDR_CAM_CNTL0 =>
                if (S_AXI_WSTRB(0) = '1') then r_tmr0_enable <= S_AXI_WDATA(1);
                                               r_tmr1_enable <= S_AXI_WDATA(4);            end if;
                if (S_AXI_WSTRB(1) = '1') then r_cam_vflip   <= S_AXI_WDATA(15 downto  8); end if;
                if (S_AXI_WSTRB(2) = '1') then r_cam_dgain   <= S_AXI_WDATA(23 downto 16); end if;
            when ADDR_CAM_CNTL1 =>
                if (S_AXI_WSTRB(0) = '1') then r_cam_again( 7 downto  0) <= S_AXI_WDATA( 7 downto  0); end if;
                if (S_AXI_WSTRB(1) = '1') then r_cam_again(15 downto  8) <= S_AXI_WDATA(15 downto  8); end if;
                if (S_AXI_WSTRB(2) = '1') then r_cam_ctime( 7 downto  0) <= S_AXI_WDATA(23 downto 16); end if;
                if (S_AXI_WSTRB(3) = '1') then r_cam_ctime(15 downto  8) <= S_AXI_WDATA(31 downto 24); end if;
            when ADDR_TMR0_LOAD =>
                if (S_AXI_WSTRB(0) = '1') then r_tmr0_load( 7 downto  0) <= S_AXI_WDATA( 7 downto  0); end if;
                if (S_AXI_WSTRB(1) = '1') then r_tmr0_load(15 downto  8) <= S_AXI_WDATA(15 downto  8); end if;
                if (S_AXI_WSTRB(2) = '1') then r_tmr0_load(23 downto 16) <= S_AXI_WDATA(23 downto 16); end if;
                if (S_AXI_WSTRB(3) = '1') then r_tmr0_load(31 downto 24) <= S_AXI_WDATA(31 downto 24); end if;
            when ADDR_TMR1_LOAD =>
                if (S_AXI_WSTRB(0) = '1') then r_tmr1_load( 7 downto  0) <= S_AXI_WDATA( 7 downto  0); end if;
                if (S_AXI_WSTRB(1) = '1') then r_tmr1_load(15 downto  8) <= S_AXI_WDATA(15 downto  8); end if;
                if (S_AXI_WSTRB(2) = '1') then r_tmr1_load(23 downto 16) <= S_AXI_WDATA(23 downto 16); end if;
                if (S_AXI_WSTRB(3) = '1') then r_tmr1_load(31 downto 24) <= S_AXI_WDATA(31 downto 24); end if;
            when others =>
            end case;
        end if;
    end if;
end process;

tmr0_start  <= '1' when w_hs = '1' and awaddr = ADDR_CAM_CNTL0 and S_AXI_WSTRB(0) = '1' and S_AXI_WDATA(0) = '1' else '0';
tmr1_start  <= '1' when w_hs = '1' and awaddr = ADDR_CAM_CNTL0 and S_AXI_WSTRB(0) = '1' and S_AXI_WDATA(3) = '1' else '0';
tmr0_enable <= r_tmr0_enable;
tmr0_load   <= r_tmr0_load(tmr_length - 1 downto 0);
tmr1_enable <= r_tmr1_enable;
tmr1_load   <= r_tmr1_load(tmr_length - 1 downto 0);
cam_vflip   <= r_cam_vflip;
cam_dgain   <= r_cam_dgain;
cam_again   <= r_cam_again;
cam_ctime   <= r_cam_ctime;

S_AXI_BRESP <= "00";

-- -----------------------------------------------------------------------------
-- read fsm
-- -----------------------------------------------------------------------------
read_fsm_control : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then rdstate <= rdreset; else rdstate <= rdnext; end if;
    end if;
end process;

read_fsm : process (rdstate, S_AXI_ARVALID, S_AXI_RREADY)
begin
    S_AXI_ARREADY <= '0';
    S_AXI_RVALID  <= '0';
    ar_hs         <= '0';

    case (rdstate) is
    when rdreset =>                                                                   rdnext <= rdidle;
    when rdidle  => S_AXI_ARREADY <= '1'; if (S_AXI_ARVALID = '1') then ar_hs <= '1'; rdnext <= rddata; else rdnext <= rdidle; end if;
    when rddata  => S_AXI_RVALID  <= '1'; if (S_AXI_RREADY  = '1') then               rdnext <= rdidle; else rdnext <= rddata; end if;
    when others  =>                                                                   rdnext <= rdidle;
    end case;
end process;

S_AXI_RRESP <= (others => '0');

read_data : process (clk)
begin
    if (rising_edge(clk)) then
        if (ar_hs = '1') then
            case (to_integer(unsigned(S_AXI_ARADDR))) is 
            when ADDR_CAM_CNTL0 => S_AXI_RDATA <= x"00" & r_cam_dgain & r_cam_vflip & rom1_done & rom0_done & tmr1_done & r_tmr1_enable & '0' & tmr0_done & r_tmr0_enable & '0';
            when ADDR_CAM_CNTL1 => S_AXI_RDATA <= r_cam_again & r_cam_ctime;
            when ADDR_TMR0_LOAD => S_AXI_RDATA <= r_tmr0_load(31 downto 0);
            when ADDR_TMR1_LOAD => S_AXI_RDATA <= r_tmr1_load(31 downto 0);
            when others         => S_AXI_RDATA <= (others => '0');
            end case;
        end if;
    end if;
end process;
end arch_imp;
