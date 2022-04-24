-- SIM OK 03/21/2019

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_sensor_i2c_chain is
generic (    
    tmr_length     : integer := 32;
    mst_addr_width : integer := 32;
    mst_data_width : integer := 32;
    slv_addr_width : integer := 32;
    slv_data_width : integer := 32;
    prot_pull      : std_logic_vector(2 downto 0) := "000";
    strb_pull      : std_logic := '1'
);
port (
    axi_aclk	: in  std_logic;
    axi_aresetn	: in  std_logic;
    
    s00_axi_awaddr	: in  std_logic_vector(slv_addr_width     - 1 downto 0);
    s00_axi_awprot	: in  std_logic_vector(2 downto 0);
    s00_axi_awvalid	: in  std_logic;
    s00_axi_awready	: out std_logic;
    s00_axi_wdata	: in  std_logic_vector(slv_data_width     - 1 downto 0);
    s00_axi_wstrb	: in  std_logic_vector(slv_data_width / 8 - 1 downto 0);
    s00_axi_wvalid	: in  std_logic;
    s00_axi_wready	: out std_logic;
    s00_axi_bresp	: out std_logic_vector(1 downto 0);
    s00_axi_bvalid	: out std_logic;
    s00_axi_bready	: in  std_logic;
    s00_axi_araddr	: in  std_logic_vector(slv_addr_width     - 1 downto 0);
    s00_axi_arprot	: in  std_logic_vector(2 downto 0);
    s00_axi_arvalid	: in  std_logic;
    s00_axi_arready	: out std_logic;
    s00_axi_rdata	: out std_logic_vector(slv_data_width     - 1 downto 0);
    s00_axi_rresp	: out std_logic_vector(1 downto 0);
    s00_axi_rvalid	: out std_logic;
    s00_axi_rready	: in  std_logic;
    
    iic0_sda_i : in  std_logic;
    iic0_sda_o : out std_logic;
    iic0_sda_t : out std_logic;
    
    iic0_scl_i : in  std_logic;
    iic0_scl_o : out std_logic;
    iic0_scl_t : out std_logic;
    
    iic1_sda_i : in  std_logic;
    iic1_sda_o : out std_logic;
    iic1_sda_t : out std_logic;
    
    iic1_scl_i : in  std_logic;
    iic1_scl_o : out std_logic;
    iic1_scl_t : out std_logic
);
end dual_sensor_i2c_chain;

architecture arch_imp of dual_sensor_i2c_chain is
signal axi_aresetn_inv : std_logic;

signal tmr0_start  : std_logic;
signal tmr0_load   : std_logic_vector(tmr_length - 1 downto 0);
signal tmr0_enable : std_logic;
signal tmr0_done   : std_logic;

signal tmr1_start  : std_logic;
signal tmr1_load   : std_logic_vector(tmr_length - 1 downto 0);
signal tmr1_enable : std_logic;
signal tmr1_done   : std_logic;

signal rom0_done : std_logic;
signal rom1_done : std_logic;

signal cam_vflip : std_logic_vector( 7 downto 0);
signal cam_dgain : std_logic_vector( 7 downto 0);
signal cam_again : std_logic_vector(15 downto 0);
signal cam_ctime : std_logic_vector(15 downto 0);
begin
-- -----------------------------------------------------------------------------
-- axi slave 0
-- -----------------------------------------------------------------------------
axi_aresetn_inv_proc : process(axi_aresetn)
begin
    axi_aresetn_inv <= not axi_aresetn;
end process;

s_axi_0 : entity work.s_axi_interface
generic map (
    tmr_length => tmr_length,
    data_width => slv_data_width,
    addr_width => slv_addr_width
)
port map (
    clk	  => axi_aclk,
    reset => axi_aresetn_inv,
    
    tmr0_start  => tmr0_start,
    tmr0_load   => tmr0_load,
    tmr0_enable => tmr0_enable,
    tmr0_done   => tmr0_done,
    
    tmr1_start  => tmr1_start,
    tmr1_load   => tmr1_load,
    tmr1_enable => tmr1_enable,
    tmr1_done   => tmr1_done,
    
    rom0_done => rom0_done,
    rom1_done => rom1_done,
    
    cam_vflip => cam_vflip,
    cam_dgain => cam_dgain,
    cam_again => cam_again,
    cam_ctime => cam_ctime,
    
    S_AXI_AWADDR  => s00_axi_awaddr,
    S_AXI_AWPROT  => s00_axi_awprot,
    S_AXI_AWVALID => s00_axi_awvalid,
    S_AXI_AWREADY => s00_axi_awready,
    S_AXI_WDATA	  => s00_axi_wdata,
    S_AXI_WSTRB	  => s00_axi_wstrb,
    S_AXI_WVALID  => s00_axi_wvalid,
    S_AXI_WREADY  => s00_axi_wready,
    S_AXI_BRESP	  => s00_axi_bresp,
    S_AXI_BVALID  => s00_axi_bvalid,
    S_AXI_BREADY  => s00_axi_bready,
    S_AXI_ARADDR  => s00_axi_araddr,
    S_AXI_ARPROT  => s00_axi_arprot,
    S_AXI_ARVALID => s00_axi_arvalid,
    S_AXI_ARREADY => s00_axi_arready,
    S_AXI_RDATA	  => s00_axi_rdata,
    S_AXI_RRESP	  => s00_axi_rresp,
    S_AXI_RVALID  => s00_axi_rvalid,
    S_AXI_RREADY  => s00_axi_rready
);
	
-- -----------------------------------------------------------------------------
-- axi master 0
-- -----------------------------------------------------------------------------
m_axi_iic0 : entity work.iic_camera
generic map (
    tmr_length => tmr_length,
    addr_width => mst_addr_width,
    data_width => mst_data_width,
    prot_pull  => prot_pull,
    strb_pull  => strb_pull
)
port map(
    clk   => axi_aclk,
    reset => axi_aresetn_inv,
    
    tmr_start  => tmr0_start,
    tmr_load   => tmr0_load,
    tmr_enable => tmr0_enable,
    tmr_done   => tmr0_done,
    
    vflip => cam_vflip,
    dgain => cam_dgain,
    agnhi => cam_again(15 downto 8),
    agnlo => cam_again( 7 downto 0),
    ctmhi => cam_ctime(15 downto 8),
    ctmlo => cam_ctime( 7 downto 0),
    
    iic_ack_error => open,
    
    iic_sda_i => iic0_sda_i,
    iic_sda_o => iic0_sda_o,
    iic_sda_t => iic0_sda_t,
    
    iic_scl_i => iic0_scl_i,
    iic_scl_o => iic0_scl_o,
    iic_scl_t => iic0_scl_t,
    
    rom_sent => rom0_done
);

-- -----------------------------------------------------------------------------
-- axi master 1
-- -----------------------------------------------------------------------------
m_axi_iic1 : entity work.iic_camera
generic map (
    tmr_length => tmr_length,
    addr_width => mst_addr_width,
    data_width => mst_data_width,
    prot_pull  => prot_pull,
    strb_pull  => strb_pull
)
port map(
    clk   => axi_aclk,
    reset => axi_aresetn_inv,
    
    tmr_start  => tmr1_start,
    tmr_load   => tmr1_load,
    tmr_enable => tmr1_enable,
    tmr_done   => tmr1_done,
    
    vflip => cam_vflip,
    dgain => cam_dgain,
    agnhi => cam_again(15 downto 8),
    agnlo => cam_again( 7 downto 0),
    ctmhi => cam_ctime(15 downto 8),
    ctmlo => cam_ctime( 7 downto 0),
    
    iic_ack_error => open,
    
    iic_sda_i => iic1_sda_i,
    iic_sda_o => iic1_sda_o,
    iic_sda_t => iic1_sda_t,
    
    iic_scl_i => iic1_scl_i,
    iic_scl_o => iic1_scl_o,
    iic_scl_t => iic1_scl_t,
    
    rom_sent => rom1_done
);
end arch_imp;
