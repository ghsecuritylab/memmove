------------------------------------------------------------------------------------
--* memmv.vhd
--* @brief A module that executes a UDMA instruction for data moving within a system.
--
--
--* @autor E. Marchi, M. Cervetto
--* @version 0.1 -- Initial
-------------------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.memmv_params.all;


entity memmv is
      port (
        clk : in std_logic;
        rst : in std_logic;

        -- Slave side
        --* Start parsing command when setted
        start     : in  std_logic;
        --* Command data input
        cmd_in    : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        --* Address from where the command is read
        cmd_addr  : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
        --* Outs '1' in order to read command
        cmd_fetch : out std_logic;

        -- Master side
        --* Write enable input for peripheral
        wr_en   : in  std_logic;
        --* Data input for peripheral
        din     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        --* Data valid for peripheral
        dv      : out std_logic;
        --* Data output for peipheral
        dout    : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        --* Address output for reading/writing data from/to peripheral
        address : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
        --* Read request output
        rd_rq   : out std_logic;

        --+ Status flags
        busy        : out std_logic;
        done        : out std_logic

);
end entity;

architecture structural of memmv is

    component fsm_cmd is
        generic (
          DATA_WIDTH : natural                           := 32;
          ADDR_WIDTH : natural                           := 32;
          BASE_ADDR  : std_logic_vector(32 - 1 downto 0) := (others => '0')
          );                                  -- TODO: package
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


    signal start_move  : std_logic;
    signal dma_instr   : dma_instr_type;

begin

  fsm_cmd_01: fsm_cmd
      generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH,
        BASE_ADDR  => BASE_ADDR
        )                                  -- TODO: package
      port map(
        clk => clk,
        rst => rst,

        -- commblock side
        start   => start,
        din     => cmd_in,
        address => cmd_addr,
        rd_en   => cmd_fetch,

        -- move side
        start_move  => start_move,
        dma_instr   => dma_instr
        );

    fsm_move_01: fsm_move
      generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
        )
      port map(
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
        start       => start_move,
        dma_instr   => dma_instr,
        -- Status flags
        busy        => busy,
        done        => done
        );

end architecture;