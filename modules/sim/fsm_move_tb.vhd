library ieee;
use ieee.std_logic_1164.all;
use work.memmv_params.all;

entity fsm_move_tb is
end entity;

architecture tb of fsm_move_tb is

  -- Component Declaration for the Unit Under Test (UUT)

  component fsm_move is
    generic (
      DATA_WIDTH : natural := 32;
      ADDR_WIDTH : natural := 32
      );
    port (
      clk : in std_logic;
      rst : in std_logic;

      -- fabric side
      wr_en   : in  std_logic;
      din     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
      dv      : out std_logic;
      dout    : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      address : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
      rd_rq   : out std_logic;

      -- instruction side
      start       : in  std_logic;
      dma_instr   : in dma_instr_type;
      -- Status flags
      busy        : out std_logic;
      done        : out std_logic
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

  -- Fabric side
  signal clk   : std_logic                                 := '0';
  signal rst   : std_logic                                 := '0';
  signal start : std_logic                                 := '0';
  signal din   : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal dout  : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal dv    : std_logic;

  signal address : std_logic_vector(ADDR_WIDTH - 1 downto 0);
  signal rd_rq   : std_logic;
  signal wr_en   : std_logic;


  -- Instruction side
  signal dma_instr : dma_instr_type :=
    (
      source_addr    => x"00001000",
      dest_addr      => x"00002000",
      source_incr    => x"0002",
      dest_incr      => x"0004",
      move_size      => x"00000008"
     );
  signal busy        : std_logic;
  signal done        : std_logic;

  -- Clock period definitions
  constant clk_period : time := 1 us;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : fsm_move
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      ADDR_WIDTH => ADDR_WIDTH)
    port map (
      clk => clk,
      rst => rst,

      -- fabric side
      wr_en   => wr_en,
      din     => din,
      dv      => dv,
      dout    => dout,
      address => address,
      rd_rq   => rd_rq,

      -- instruction side
      start       => start,
      dma_instr   => dma_instr,
      busy        => busy,
      done        => done
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

  -- Data valid emulation for devices with no 'data valid'
  process(clk)
  begin
    if(clk = '1' and clk'event) then
      if(rst = '1') then
        wr_en <= '0';
      else
        wr_en <= rd_rq;
      end if;
    end if;
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

end architecture;
