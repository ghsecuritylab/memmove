library IEEE;
use IEEE.STD_LOGIC_1164.all;

--* @brief Produce un pulso en pulse_out cuando hay una transición positiva
--* en pulse_activate

entity pulse_generator is
  port (
    clk            : in  std_logic;
    rst            : in  std_logic;
    pulse_activate : in  std_logic;
    pulse_out      : out std_logic);
end entity;

architecture rtl of pulse_generator is

  type estado is (ZERO, PULSE, UNO);

  signal estado_reg, estado_next : estado;

begin

  state_register:
  process(clk)
  begin
    if clk = '1' and clk'event then
      if rst = '1' then
        estado_reg <= ZERO;
      else
        estado_reg <= estado_next;
      end if;
    end if;
  end process;

  next_state:
  process(estado_reg, pulse_activate)
  begin
    case estado_reg is
      when ZERO =>
        
        if pulse_activate = '1' then
          estado_next <= PULSE;
        else
          estado_next <= ZERO;
        end if;
        
      when PULSE =>
        estado_next <= UNO;
        
      when UNO =>
        if pulse_activate = '0' then
          estado_next <= ZERO;
        else
          estado_next <= UNO;
        end if;
        
    end case;
  end process;

  output_logic:
  process(clk, estado_reg)
  begin
    pulse_out <= '0';
    case estado_reg is
      when ZERO =>
      when PULSE =>
        pulse_out <= '1';
      when UNO =>
    end case;
  end process;
  
end architecture;
