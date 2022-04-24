-- SIM OK 03/21/2019

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity iic_camera is
generic (
    tmr_length : integer := 32;
    addr_width : integer := 32;
    data_width : integer := 32;
    prot_pull  : std_logic_vector(2 downto 0) := "000";
    strb_pull  : std_logic := '1'
);
port (
    clk   : in std_logic;
    reset : in std_logic;
    
    tmr_start  : in  std_logic;
    tmr_load   : in  std_logic_vector(tmr_length - 1 downto 0);
    tmr_enable : in  std_logic;
    tmr_done   : out std_logic;
    
    vflip : in std_logic_vector(7 downto 0);
    dgain : in std_logic_vector(7 downto 0);
    agnhi : in std_logic_vector(7 downto 0);
    agnlo : in std_logic_vector(7 downto 0);
    ctmhi : in std_logic_vector(7 downto 0);
    ctmlo : in std_logic_vector(7 downto 0);

    iic_ack_error : buffer std_logic;
    
    iic_sda_i : in  std_logic;
    iic_sda_o : out std_logic;
    iic_sda_t : out std_logic;
    
    iic_scl_i : in  std_logic;
    iic_scl_o : out std_logic;
    iic_scl_t : out std_logic;
    
    rom_sent : out std_logic
);
end iic_camera;

architecture Behavioral of iic_camera is
constant SOFTR_ADDR   : std_logic_vector(addr_width - 1 downto 0) := std_logic_vector(to_unsigned(16#040#, addr_width));
constant TX_FIFO_ADDR : std_logic_vector(addr_width - 1 downto 0) := std_logic_vector(to_unsigned(16#108#, addr_width));
constant CR_ADDR      : std_logic_vector(addr_width - 1 downto 0) := std_logic_vector(to_unsigned(16#100#, addr_width));
constant SR_ADDR      : std_logic_vector(addr_width - 1 downto 0) := std_logic_vector(to_unsigned(16#104#, addr_width));

type iic_states is (iic_reset, iic_wait_start, iic_latch_data2, iic_data2, iic_latch_data1, iic_data1, iic_wait_data1, iic_latch_data0, iic_data0, iic_wait_data0, iic_sr_s0);

signal iic_state : iic_states;
signal iic_next  : iic_states;
           
signal awr_valid : std_logic;
signal awr_ready : std_logic;
signal awr_addr  : std_logic_vector(addr_width - 1 downto 0);
signal awr_data  : std_logic_vector(data_width - 1 downto 0);
signal awr_resp  : std_logic_vector(1 downto 0);

signal ard_valid : std_logic;
signal ard_ready : std_logic;
signal ard_addr  : std_logic_vector(addr_width - 1 downto 0);
signal ard_data  : std_logic_vector(data_width - 1 downto 0);
signal ard_resp  : std_logic_vector(1 downto 0);

signal rom_start : std_logic;

signal iic_dev_addr : std_logic_vector(6 downto 0);
signal iic_valid    : std_logic;
signal iic_ready    : std_logic; 
signal iic_data     : std_logic_vector(7 downto 0);
signal iic_byte     : std_logic_vector(7 downto 0);

signal d_hs : std_logic;

signal iic_reset_n : std_logic;
signal iic_ena     : std_logic;
signal iic_busy    : std_logic;
begin
-- -----------------------------------------------------------------------------
-- main timer
-- -----------------------------------------------------------------------------
main_timer : entity work.timer
generic map(
    bits => tmr_length
)
port map (
    clk    => clk,
    reset  => reset,
    start  => tmr_start,
    load   => tmr_load,
    enable => tmr_enable,
    done   => rom_start
);

tmr_done <= rom_start;

-- -----------------------------------------------------------------------------
-- rom transfer
-- -----------------------------------------------------------------------------
rom_to_iic : entity work.rom_transfer
port map (
    clk   => clk,
    reset => reset,
    
    rom_start => rom_start,

    vflip => vflip,
    dgain => dgain,
    agnhi => agnhi,
    agnlo => agnlo,
    ctmhi => ctmhi,
    ctmlo => ctmlo,
    
    iic_dev_addr => iic_dev_addr,
    iic_valid    => iic_valid,
    iic_ready    => iic_ready,
    iic_data     => iic_data,
    
    rom_sent => rom_sent
);

-- -----------------------------------------------------------------------------
-- i2c master
-- -----------------------------------------------------------------------------
iic_reset_n <= not reset;

i2c_master_unit : entity work.i2c_master
generic map(
    input_clk => 50_000_000,
    bus_clk   => 400_000
)
port map(
    clk       => clk,
    reset_n   => iic_reset_n,
    ena       => iic_ena,
    addr      => iic_dev_addr,
    rw        => '0',
    data_wr   => iic_byte,
    busy      => iic_busy,
    data_rd   => open,
    ack_error => iic_ack_error,

    sda_i => iic_sda_i,
    sda_o => iic_sda_o,
    sda_t => iic_sda_t,
    
    scl_i => iic_scl_i,
    scl_o => iic_scl_o,
    scl_t => iic_scl_t
);

-- -----------------------------------------------------------------------------
-- i2c fsm
-- -----------------------------------------------------------------------------
iic_fsm_control : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then iic_state <= iic_reset; else iic_state <= iic_next; end if;
    end if;
end process;

iic_latch : process (clk)
begin
    if (rising_edge(clk)) then
        if (d_hs = '1') then iic_byte <= iic_data; end if;
    end if;
end process;

iic_fsm : process (iic_state, rom_start, iic_valid, iic_busy)
begin
    iic_ready <= '0';
    iic_ena   <= '0';
    d_hs      <= '0';

    case (iic_state) is
    when iic_reset       =>                                                                          iic_next <= iic_wait_start;
    when iic_wait_start  =>                                   if (rom_start = '1') then              iic_next <= iic_sr_s0;       else iic_next <= iic_wait_start;  end if;
    when iic_sr_s0       =>                                   if (iic_busy  = '0') then              iic_next <= iic_latch_data2; else iic_next <= iic_sr_s0;       end if;
    when iic_latch_data2 =>                 iic_ready <= '1'; if (iic_valid = '1') then d_hs <= '1'; iic_next <= iic_data2;       else iic_next <= iic_latch_data2; end if;
    when iic_data2       => iic_ena <= '1';                   if (iic_busy  = '1') then              iic_next <= iic_latch_data1; else iic_next <= iic_data2;       end if;
    when iic_latch_data1 => iic_ena <= '1'; iic_ready <= '1'; if (iic_valid = '1') then d_hs <= '1'; iic_next <= iic_data1;       else iic_next <= iic_latch_data1; end if;
    when iic_data1       => iic_ena <= '1';                   if (iic_busy  = '0') then              iic_next <= iic_wait_data1;  else iic_next <= iic_data1;       end if;
    when iic_wait_data1  => iic_ena <= '1';                   if (iic_busy  = '1') then              iic_next <= iic_latch_data0; else iic_next <= iic_wait_data1;  end if;
    when iic_latch_data0 => iic_ena <= '1'; iic_ready <= '1'; if (iic_valid = '1') then d_hs <= '1'; iic_next <= iic_data0;       else iic_next <= iic_latch_data0; end if;
    when iic_data0       => iic_ena <= '1';                   if (iic_busy  = '0') then              iic_next <= iic_wait_data0;  else iic_next <= iic_data0;       end if;
    when iic_wait_data0  => iic_ena <= '1';                   if (iic_busy  = '1') then              iic_next <= iic_sr_s0;       else iic_next <= iic_wait_data0;  end if;
    end case;
end process;
end Behavioral;
