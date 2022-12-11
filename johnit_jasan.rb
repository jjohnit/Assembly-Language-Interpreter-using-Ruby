require_relative 'sal'
require_relative 'hardware'

puts "Enter the name of the file with the instructions"
file_name = gets.chomp
hardware = Hardware.new
#set the value of class variable @@hardware in SAL class
SAL.set_hardware(hardware)
counter = 0
IO.foreach(file_name) do |line|
  case line.split()[0]
  when "DEC"
    instruction = DEC.new line
  when "LDA"
    instruction = LDA.new line
  when "LDB"
    instruction = LDB.new line
  when "LDI"
    instruction = LDI.new line
  when "STR"
    instruction = STR.new line
  when "XCH"
    instruction = XCH.new line
  when "JMP"
    instruction = JMP.new line
  when "JZS"
    instruction = JZS.new line
  when "JVS"
    instruction = JVS.new line
  when "ADD"
    instruction = ADD.new line
  when "HLT"
    instruction = HLT.new line
  end
  hardware.instructions[counter] = instruction
  counter += 1
end

while true
  puts "\ns -> Execute a single line of code\na -> Execute all the instructions until a halt instruction\nq -> Quit"
  puts "Enter a command : "
  command = gets.chomp
  case command
  when "s" || "S"
    # Execute a single line of instruction
    hardware.instructions[hardware.program_counter].execute unless (hardware.instructions[hardware.program_counter] == nil)
    hardware.get_next_instruction
    hardware.display
  when "a" || "A"
    # Execute the instructions till the Halt instruction
    counter = 0
    while counter < 1000
      if (hardware.instructions[hardware.program_counter] == nil)
        break
      end
      puts hardware.instructions[hardware.program_counter]
      flag = hardware.instructions[hardware.program_counter].execute

      # To break on HLT instruction
      if flag == -1
        break
      end

      counter += 1
      if counter >= 1000
        puts "More than 1000 lines executed. Do you want to continue execution ? (y/n)"
        input = gets.chomp
        if input == "y" || input == "Y"
          counter = 0
        else
          hardware.display
        end
      end
    end
  when "q" || "Q"
    break
  end
end