class Hardware
  attr_accessor :instructions, :register_a, :register_b,
                :program_counter, :zero_result, :overflow
  attr_reader :program_data

  def initialize
    # Instructions is stored in a 128 bit array
    @instructions = Array.new(128)
    @program_data = Hash.new
    @register_a = @register_b = @program_counter = 0
    @zero_result = @overflow = 0
  end

  # Setter for program data. The maximum capacity is 128.
  def set_program_data(key, value)
    if(@program_data.length < 128)
      @program_data[key] = value
    else
      puts "The program data memory is full"
    end
  end

  # To display the remaining instructions
  def get_remaining_instructions
    puts "Remaining Instructions in the memory are :"
    (@program_counter...@instructions.length).each { |i|
      if (@instructions[i] == nil)
        break
      end
      puts @instructions[i]
    }
  end

  # To display the next instruction to execute
  def get_next_instruction
    puts "The next Instruction in the memory is :"
    puts @instructions[@program_counter]
  end

  # To display the available program data
  def get_program_data
    puts "Program data contains :"
    program_data.each do |key, value|
      puts "#{key} = #{value}"
    end
  end

  # Display the values of all data members
  def display
    get_program_data
    puts "Register A = #{register_a}\nRegister B = #{register_b}"
    puts "Zero bit = #{zero_result}\nOverflow bit = #{overflow}"
  end
end
