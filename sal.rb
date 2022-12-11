require_relative 'hardware'

#Super class for SAL instructions
class SAL
  attr_reader :op_code

  # Class variable to point to the hardware memory
  @@hardware = nil

  def initialize(instruction)
    # opCode denotes the operation (eg: ADD)
    @op_code = instruction.split()[0]
    # argument stores the argument
    @argument = (instruction.split().length > 1) ? instruction.split()[1] : nil
  end

  # Class method to set the value of class variable @@hardware
  def SAL.set_hardware(value)
    @@hardware = value
  end

  # Abstract class
  def execute
  end

  def to_s
    "#{@op_code} #{@argument}"
  end
end

# Declares a symbolic variable (e.g., X). The variable is stored at an available location in data memory
class DEC < SAL
  def execute
    @@hardware.set_program_data(@argument, nil)
    @@hardware.program_counter += 1
  end
end

# Loads word at data memory address of symbol into the accumulator.
class LDA < SAL
  def execute
    @@hardware.register_a = @@hardware.program_data[@argument].to_i
    @@hardware.program_counter += 1
  end
end

# Loads word at data memory address symbol into B.
class LDB < SAL
  def execute
    @@hardware.register_b = @@hardware.program_data[@argument].to_i
    @@hardware.program_counter += 1
  end
end

# Loads the integer value into the accumulator register. The value could be negative.
class LDI < SAL
  def execute
    @@hardware.register_a = @argument.to_i
    @@hardware.program_counter += 1
  end
end

# Stores content of accumulator into data memory at address of symbol.
class STR < SAL
  def execute
    @@hardware.set_program_data(@argument, @@hardware.register_a)
    @@hardware.program_counter += 1
  end
end

# Exchanges the content registers A and B.
class XCH < SAL
  def execute
    @@hardware.register_a, @@hardware.register_b = @@hardware.register_b, @@hardware.register_a
    @@hardware.program_counter += 1
  end
end

# Transfers control to instruction at address number in program memory.
class JMP < SAL
  def execute
    @@hardware.program_counter = @argument.to_i
  end
end

# Transfers control to instruction at address number if the zero-result bit is set.
class JZS < SAL
  def execute
    if @@hardware.zero_result == 1
      @@hardware.program_counter = @argument.to_i
    else
      @@hardware.program_counter += 1
    end
  end
end

# Transfers control to instruction at address number if the overflow bit is set.
class JVS < SAL
  def execute
    if @@hardware.overflow == 1
      @@hardware.program_counter = @argument.to_i
    else
      @@hardware.program_counter += 1
    end
  end
end

# Adds the content of registers A and B. The sum is stored in A.
# The overflow and zero-result bits are set or cleared as needed.
class ADD < SAL
  def execute
    @@hardware.register_a = @@hardware.register_a + @@hardware.register_b
    if @@hardware.register_a == 0
      @@hardware.zero_result = 1
    else
      @@hardware.zero_result = 0
    end
    if @@hardware.register_a > ((2 ** 31) - 1) || @@hardware.register_a < (-(2 ** 31))
      @@hardware.overflow = 1
      @@hardware.register_a += -((2**31) - 1)
    else
      @@hardware.overflow = 0
    end
    @@hardware.program_counter += 1
  end
end

# Terminates program execution.
class HLT < SAL
  def execute
    @@hardware.display
    @@hardware.program_counter += 1
    @@hardware.register_a = @@hardware.register_b =
      @@hardware.zero_result = @@hardware.overflow =  0
    return -1
  end
end