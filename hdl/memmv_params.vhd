------------------------------------------------------------------------------------
-- memmv_params
--
--
--
-- Autor: E. Marchi - M. Cervetto
-- Revisión: 0.1 -- inicial
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package memmv_params is

  constant DATA_WIDTH : natural                           := 32;
  constant ADDR_WIDTH : natural                           := 32;
  constant BASE_ADDR  : std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');

  type dma_instr_type is record
    source_addr : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    dest_addr   : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    source_incr : std_logic_vector(ADDR_WIDTH/2 - 1 downto 0);
    dest_incr   : std_logic_vector(ADDR_WIDTH/2 - 1 downto 0);
    move_size   : std_logic_vector(ADDR_WIDTH - 1 downto 0);-- set if the msg received is a broadcast
  end record;


end package;
