------------------------------------------------------------------------------------
-- fsm_cmd
--
-- 
--
-- Autor: E. Marchi - M. Cervetto
-- Revisión: 0.1 -- inicial
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.memmv_params.all;

entity fsm_cmd is
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
end entity;

architecture fsm of fsm_cmd is

  type state is (IDLE, FETCH_SRC, FETCH_DST, FETCH_INCR, FETCH_SIZE, FETCH_DONE);
  signal state_next, state_reg : state;

  signal wr_register : std_logic_vector(3 downto 0);

begin

-- FSM register
  process(clk)
  begin

    if clk = '1' and clk'event then
      if rst = '1' then
        state_reg <= IDLE;
      else
        state_reg <= state_next;
      end if;
    end if;
  end process;

-- transition logic

  process(state_reg, start)

  begin

    state_next <= state_reg;

    case state_reg is

      when IDLE =>
        if (start = '1') then
          state_next <= FETCH_SRC;
        end if;

      when FETCH_SRC =>
        state_next <= FETCH_DST;

      when FETCH_DST =>
        state_next <= FETCH_INCR;

      when FETCH_INCR =>
        state_next <= FETCH_SIZE;

      when FETCH_SIZE =>
        state_next <= FETCH_DONE;

      when FETCH_DONE =>
        state_next <= IDLE;

    end case;
  end process;


-- Mealy output logic
  process(state_reg, start)

  begin
    start_move  <= '0';
    wr_register <= "0000";
    address     <= (others => '0');
    rd_en       <= '0';

    case state_reg is

      when IDLE =>
        if (start = '1') then
          address <= BASE_ADDR;
          rd_en   <= '1';
        end if;

      when FETCH_SRC =>
        address        <= std_logic_vector(unsigned(BASE_ADDR) + to_unsigned(1, ADDR_WIDTH));
        rd_en          <= '1';
        wr_register(0) <= '1';

      when FETCH_DST =>
        address        <= std_logic_vector(unsigned(BASE_ADDR) + to_unsigned(2, ADDR_WIDTH));
        rd_en          <= '1';
        wr_register(1) <= '1';

      when FETCH_INCR =>
        address        <= std_logic_vector(unsigned(BASE_ADDR) + to_unsigned(3, ADDR_WIDTH));
        rd_en          <= '1';
        wr_register(2) <= '1';

      when FETCH_SIZE =>
        wr_register(3) <= '1';

      when FETCH_DONE =>
        start_move <= '1';

    end case;
  end process;

-- register command parameters
  process(clk)
  begin

    if clk = '1' and clk'event then
      if rst = '1' then
        dma_instr.source_addr <= (others => '0');
        dma_instr.dest_addr   <= (others => '0');
        dma_instr.source_incr <= (others => '0');
        dma_instr.dest_incr   <= (others => '0');
        dma_instr.move_size   <= (others => '0');
      else
        case wr_register is
          when "0001" =>
            dma_instr.source_addr <= din;

          when "0010" =>
            dma_instr.dest_addr <= din;

          when "0100" =>
            dma_instr.source_incr <= din(DATA_WIDTH - 1 downto DATA_WIDTH/2);
            dma_instr.dest_incr   <= din(DATA_WIDTH/2 -1 downto 0);

          when "1000" =>
            dma_instr.move_size <= din;

          when others =>

        end case;
      end if;
    end if;
  end process;

end architecture;
