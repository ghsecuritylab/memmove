library ieee;
use ieee.std_logic_1164.all;
use work.memmv_params.all;

entity fsm_cmd_tb is
end entity;

architecture tb of fsm_cmd_tb is

  -- Component Declaration for the Unit Under Test (UUT)

  component fsm_cmd is
    generic (
      DATA_WIDTH : natural                           := 32;
      ADDR_WIDTH : natural                           := 32;
      BASE_ADDR  : std_logic_vector(32 - 1 downto 0) := (others => '0')  -- TODO: Package
      );
    port (
      clk : in std_logic;
      rst : in std_logic;

      -- commblock side
      start   : in  std_logic;
      din     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
      address : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
      rd_en   : out std_logic;

      -- move side
      start_move  : out std_logic;
      dma_instr   : out dma_instr_type
      );
  end component;

  component mem_sim is
    port (
      clk     : in  std_logic;
      we      : in  std_logic;
      addr    : in  std_logic_vector;
      datain  : in  std_logic_vector;
      dataout : out std_logic_vector
      );
  end component;


  constant DATA_WIDTH : natural                                   := 32;
  constant ADDR_WIDTH : natural                                   := 32;
  constant BASE_ADDR  : std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');

  -- Commblock side
  signal clk     : std_logic                                 := '0';
  signal rst     : std_logic                                 := '0';
  signal start   : std_logic                                 := '0';
  signal din     : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal address : std_logic_vector(ADDR_WIDTH - 1 downto 0);
  signal rd_en   : std_logic;

  -- Move side
  signal start_move  : std_logic;
  signal dma_instr : dma_instr_type;

  -- Clock period definitions
  constant clk_period : time := 1 us;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : fsm_cmd
    generic map(
      DATA_WIDTH => DATA_WIDTH,
      ADDR_WIDTH => ADDR_WIDTH,
      BASE_ADDR  => BASE_ADDR)
    port map (
      clk         => clk,
      rst         => rst,
      start       => start,
      din         => din,
      address     => address,
      rd_en       => rd_en,
      start_move  => start_move,
      dma_instr   => dma_instr
      );

  -- Memory simulation
  mem : mem_sim
    port map(
      clk     => clk,
      we      => '0',
      addr    => address(15 downto 0),
      datain  => (others => '0'),
      dataout => din
      );

  -- Clock process definitions
  clk_process : process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process;

  -- Stimulus
  start_process : process
  begin
    rst   <= '1';
    start <= '0';
    wait for (clk_period * 10) + 1 ps;
    rst   <= '0';
    wait for clk_period * 10;
    start <= '1';
    wait for clk_period;
    start <= '0';
    wait;
  end process;
end;
