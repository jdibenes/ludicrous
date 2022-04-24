-- SIM OK 02/08/2019
-- SIM OK 03/20/2019 * simplify design
-- SIM OK 03/21/2019 * simplify design

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rom_transfer is
port (
    clk   : in std_logic;
    reset : in std_logic;

    rom_start : in std_logic;

    vflip : in std_logic_vector(7 downto 0);
    dgain : in std_logic_vector(7 downto 0);
    agnhi : in std_logic_vector(7 downto 0);
    agnlo : in std_logic_vector(7 downto 0);
    ctmhi : in std_logic_vector(7 downto 0);
    ctmlo : in std_logic_vector(7 downto 0);

    iic_dev_addr : out std_logic_vector(6 downto 0);
    iic_valid    : out std_logic;
    iic_ready    : in  std_logic;
    iic_data     : out std_logic_vector(7 downto 0);

    rom_sent : out std_logic
);
end rom_transfer;

architecture Behavioral of rom_transfer is
subtype imx274_cmd is std_logic_vector(23 downto 0);
type imx274_cmd_rom is array (0 to 101) of imx274_cmd;

constant rom : imx274_cmd_rom := (
    -- tp disabled
     0 => x"303C_00",
     1 => x"377F_00",
     2 => x"3781_00",
     3 => x"370B_00",
    
    -- cmd_vflip, cmd_dgain, cmd_agnhi, cmd_agnlo,
     4 => x"301A_00",
     5 => x"3012_00",
     6 => x"300B_07",
     7 => x"300A_A3",

    -- start1
     8 => x"3000_12",
     
    -- start2
     9 => x"3120_F0", --/* clock settings */
	10 => x"3121_00", --/* clock settings */
	11 => x"3122_02", --/* clock settings */
	12 => x"3129_9C", --/* clock settings */
	13 => x"312A_02", --/* clock settings */
	14 => x"312D_02", --/* clock settings */

	15 => x"310B_00",

	--/* PLSTMG */
	16 => x"304C_00", --/* PLSTMG01 */
	17 => x"304D_03",
	18 => x"331C_1A",
	19 => x"331D_00",
	20 => x"3502_02",
	21 => x"3529_0E",
	22 => x"352A_0E",
	23 => x"352B_0E",
	24 => x"3538_0E",
	25 => x"3539_0E",
	26 => x"3553_00",
	27 => x"357D_05",
	28 => x"357F_05",
	29 => x"3581_04",
	30 => x"3583_76",
	31 => x"3587_01",
	32 => x"35BB_0E",
	33 => x"35BC_0E",
	34 => x"35BD_0E",
	35 => x"35BE_0E",
	36 => x"35BF_0E",
	37 => x"366E_00",
	38 => x"366F_00",
	39 => x"3670_00",
	40 => x"3671_00",

	--/* PSMIPI */
	41 => x"3304_32", --/* PSMIPI1 */
	42 => x"3305_00",
	43 => x"3306_32",
	44 => x"3307_00",
	45 => x"3590_32",
	46 => x"3591_00",
	47 => x"3686_32",
	48 => x"3687_00",
	
	-- 4K raw 10 bit
    49 => x"3004_01",
    50 => x"3005_01",
    51 => x"3006_00",
    52 => x"3007_02",
    53 => x"3018_A2", --/* output XVS, HVS */
    54 => x"306B_05",
    55 => x"30E2_01",
    56 => x"30F6_07", --/* HMAX, 263 */
    57 => x"30F7_01", --/* HMAX */    
    58 => x"30dd_01", --/* crop to 2160 */
    59 => x"30de_06",
    60 => x"30df_00",
    61 => x"30e0_12",
    62 => x"30e1_00",
    63 => x"3037_01", --/* to crop to 3840 */
    64 => x"3038_0c",
    65 => x"3039_00",
    66 => x"303a_0c",
    67 => x"303b_0f",
    68 => x"30EE_01",
    69 => x"3130_86",
    70 => x"3131_08",
    71 => x"3132_7E",
    72 => x"3133_08",
    73 => x"3342_0A",
    74 => x"3343_00",
    75 => x"3344_16",
    76 => x"3345_00",
    77 => x"33A6_01",
    78 => x"3528_0E",
    79 => x"3554_1F",
    80 => x"3555_01",
    81 => x"3556_01",
    82 => x"3557_01",
    83 => x"3558_01",
    84 => x"3559_00",
    85 => x"355A_00",
    86 => x"35BA_0E",
    87 => x"366A_1B",
    88 => x"366B_1A",
    89 => x"366C_19",
    90 => x"366D_17",
    91 => x"3A41_08",
    
    -- frame interval
    92 => x"30FA_00",
    93 => x"30F9_11",
    94 => x"30F8_D2",
    
    -- set_ctmhi, set_ctmlo
    95 => x"300D_08",
    96 => x"300C_EE",
    
    -- start 3
    97 => x"3000_00",
    98 => x"303E_02", --/* SYS_MODE = 2 */
    
    -- start 4
    99 => x"30F4_00",
   100 => x"3018_A2", --/* XHS VHS OUTUPT */
   
    -- done
   101 => x"0000_00"
);

type cmd_states is (cmd_reset, cmd_rom,  cmd_vflip, cmd_dgain,  cmd_agnhi,  cmd_agnlo,  cmd_ctmhi, cmd_ctmlo);
type rom_states is (rom_reset, rom_idle, rom_delay, rom_hiaddr, rom_loaddr, rom_datar8, rom_check, rom_done);

signal cmd_state : cmd_states;
signal cmd_next  : cmd_states;

signal rom_state : rom_states;
signal rom_next  : rom_states;

signal rom_addr : integer range 0 to 127;

signal iic_data24 : std_logic_vector(23 downto 0);
signal tmr_load   : std_logic_vector(23 downto 0);

signal tmr_start  : std_logic;
signal tmr_enable : std_logic;
signal tmr_done   : std_logic;

signal rom_tick  : std_logic;
signal cmd_done  : std_logic;
begin
-- -----------------------------------------------------------------------------
-- cmd fsm
-- -----------------------------------------------------------------------------
cmd_next <= cmd_vflip when rom_addr =  4 else
            cmd_dgain when rom_addr =  5 else
            cmd_agnhi when rom_addr =  6 else
            cmd_agnlo when rom_addr =  7 else
            cmd_ctmhi when rom_addr = 95 else
            cmd_ctmlo when rom_addr = 96 else
            cmd_rom;
            
cmd_fsm_control : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then cmd_state <= cmd_reset; else cmd_state <= cmd_next; end if;
    end if;
end process;

cmd_fsm : process(cmd_state, rom_addr, vflip, dgain, agnhi, agnlo, ctmhi, ctmlo)
begin
    case (cmd_state) is
    when cmd_reset => iic_data24 <= (others => '0');
    when cmd_rom   => iic_data24 <= rom(rom_addr);
    when cmd_vflip => iic_data24 <= x"301A" & vflip;
    when cmd_dgain => iic_data24 <= x"3012" & dgain;
    when cmd_agnhi => iic_data24 <= x"300B" & agnhi;
    when cmd_agnlo => iic_data24 <= x"300A" & agnlo;
    when cmd_ctmhi => iic_data24 <= x"300D" & ctmhi;
    when cmd_ctmlo => iic_data24 <= x"300C" & ctmlo;
    end case;
end process;

-- -----------------------------------------------------------------------------
-- rom transfer fsm
-- -----------------------------------------------------------------------------
tmr_load <= x"086470" when (rom_addr = 97) else
            x"061A80" when (rom_addr = 99) else
            x"FFFFFF";

cmd_done <= '1' when (rom_addr = 101) else '0'; 

delay_unit : entity work.timer
generic map (
    bits => 24
)
port map (
    clk    => clk,
    reset  => reset,
    start  => tmr_start,
    load   => tmr_load,
    enable => tmr_enable,
    done   => tmr_done
);

rom_transfer_fsm_control : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then rom_state <= rom_reset; else rom_state <= rom_next; end if;
    end if;
end process;

rom_addr_control : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset    = '1') then rom_addr <= 0;
        elsif (rom_tick = '1') then rom_addr <= rom_addr + 1;
        end if;
    end if;
end process;

rom_transfer_fsm : process (rom_state, rom_start, tmr_done, iic_data24, iic_ready, cmd_done)
begin
    tmr_start  <= '0';
    tmr_enable <= '0';
    iic_data   <= x"00";
    iic_valid  <= '0';
    rom_tick   <= '0';
    
    case (rom_state) is
    when rom_reset  =>                                                                                                       rom_next <= rom_idle;
    when rom_idle   =>                                                          if (rom_start = '1') then tmr_start  <= '1'; rom_next <= rom_delay;  else rom_next <= rom_idle;   end if;
    when rom_delay  =>                                       tmr_enable <= '1'; if (tmr_done  = '1') then                    rom_next <= rom_hiaddr; else rom_next <= rom_delay;  end if;
    when rom_hiaddr => iic_data <= iic_data24(23 downto 16); iic_valid  <= '1'; if (iic_ready = '1') then                    rom_next <= rom_loaddr; else rom_next <= rom_hiaddr; end if;
    when rom_loaddr => iic_data <= iic_data24(15 downto  8); iic_valid  <= '1'; if (iic_ready = '1') then                    rom_next <= rom_datar8; else rom_next <= rom_loaddr; end if;
    when rom_datar8 => iic_data <= iic_data24( 7 downto  0); iic_valid  <= '1'; if (iic_ready = '1') then rom_tick   <= '1'; rom_next <= rom_check;  else rom_next <= rom_datar8; end if;
    when rom_check  =>                                                          if (cmd_done  = '1') then                    rom_next <= rom_done;   else rom_next <= rom_idle;   end if;
    when rom_done   =>                                                                                                                                    rom_next <= rom_done;
    end case;
end process;

rom_sent     <= cmd_done;
iic_dev_addr <= "0011010";
end Behavioral;
