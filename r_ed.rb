#! usr/bin/ruby
# An implementation of ed written in ruby
# Copyright (C) 2022 Bryce Hill
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

$buffer = []
$buffer_length = 0
$filename = ""
$dollar_sign
$current_line = 0

if ARGV.length == 1
    $filename = ARGV[0]
    File.readlines($filename).each do |line|
        $buffer.push line
        $buffer_length += line.length
    end
    # $buffer.each do |line|
        # puts line
    # end
    puts $buffer_length
    
elsif ARGV.length == 2
    filename = ARGV[1]
    command = ARGV[0]


elsif ARGV.length > 2
    puts "Too many arguments!"
end

# clears the command line arguments
until ARGV.empty? do
    ARGV.shift
end

$command_mode = false
$dollar_sign = $buffer[-1]

while true
    if $command_mode
        print "*"
    end

    command = gets.chomp

    if command == "p" && !$command_mode
        $command_mode = true
    end

    if command == "a"
        until command == ".\n"
            command = gets
            # puts command
            unless command == ".\n"
                $buffer.push command
                $buffer_length += command.length
            end
        end
    end

    # runs sys commands
    if command[0] == "!"
        # puts(command[1..command.length - 1])
        system(command[1..command.length - 1])
    end
    # writes output of a sys command to the buffer 
    if command[0] == "r"
        sys_command = command[3..command.length - 1]
        ouput = `#{sys_command}`
        ouput.each_line do |line|
            $buffer.push line
        end
        puts ouput.length
        $buffer_length += output.length
        # p $buffer
    elsif command[0..1] == ",p"
        $buffer.each do |line|
            puts line
        end
    elsif command[0] == "w"
        command_split = command.split(" ")
        if command_split.length > 1
            file_name = command_split[1]
            file = File.new(file_name, "w")
            if File.file? file
                $buffer.each do |line|
                    file.write(line)
                end
            else
                puts file + " is a directory"
            end
            file.close()
        elsif $filename != ""
            file = File.new($filename, "w")
            $buffer.each do |line|
                file.write(line)
            end
            file.close()
        else
            puts "no file!"
        end
        puts $buffer_length
    elsif command == "$"
        puts $dollar_sign
    elsif command.match(/^[0-9]*$/)
        $current_line = command.to_i - 1 
        if $current_line < $buffer_length
            puts $buffer[$current_line]
        else
            puts "Line doesn't exist in buffer!"  
        end
    elsif  command[0] == "s"
        command_split = command.split("/")
        $buffer_length -= $buffer[$current_line].length
        if command_split.length >= 3
            $buffer[$current_line].sub!(command_split[1], command_split[2])
            if command_split.length > 3
                if command_split[3] == "p"
                    puts $buffer[$current_line]
                end
            end
        else 
            puts "invalid command!"
        end
        $buffer_length += $buffer[$current_line].length
    elsif command == "p"
        puts $buffer[$current_line]
    end


    if command == "q"
        break
    end

    $dollar_sign = $buffer[-1]

end
