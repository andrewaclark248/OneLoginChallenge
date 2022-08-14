require "tty-prompt"
require 'ostruct'
require 'bigdecimal/util'

class CliApp

    def self.start_app
        #constantly ask for user input unless exited
        prompt = TTY::Prompt.new
        start_loop = true

        puts "Enter alegrabic eqution (ex: 1 + 5) for awnser or type 'exit' to leave!!!"
        puts "Enter alegrabic eqution (ex: 1 + 5) for awnser or type 'exit' to leave!!!"
        puts "Enter alegrabic eqution (ex: 1 + 5) for awnser or type 'exit' to leave!!!"
        while start_loop
            #ask user for input
            user_input = prompt.ask("Enter equation:")

            #exit cli if prompted
            return if user_input == "exit"

            #check for valid user input
            if invalid_input(user_input)
                puts "Invalid Input. Please enter correct value!"
                next
            else
                #if valid calculate result
                puts parse_input(user_input)
            end
        end
    end

    #parse user input by looping through each integer/fraction and operator and add to running total
    #use metaprogramming via ruby public_send method to cacluate result
    #convert integer/fractions to floats
    #easier to calculate total via float addition than traditional mathematical methods
    def self.parse_input user_input
        loop_total = 0                  #create running total variable
        current_operator = "+"          #set to plus so that the first integer is added (x + 0)
        user_input.split(" ").each do |input|
            #get current operator and next if present
            if ["*", "/", "+", "-", "%"].include?(input)
                current_operator = input
                next
            end

            #if numbers convert fractions to floats
            result = convert_fraction_to_float(input)
            return "Unknown Error Occured" if !result.success?

            #use metaprogramming to multiply/divide/add/subtract/minus/modulo
            loop_total = loop_total.public_send(current_operator, result.converted_number) 
        end
        #convert from float to fraction
        total = convert_float_to_fraction(loop_total)
        return total
    end

    #convert numbers from from fraction (1&3/4) to integer/floats 
    def self.convert_fraction_to_float user_input
        converted_number = 0
        #split number from fraction
        user_input.split("&").each do |input|
            current_value = Rational(input).to_f #convert to float
            converted_number = converted_number + current_value #add converted value to running total
        end
        return OpenStruct.new(success?: true, converted_number: converted_number)
    rescue
        return OpenStruct.new(success?: false)
    end

    #convert float to fraction
    def self.convert_float_to_fraction integer
        return integer.to_i.to_s if integer%1 == 0 #if no decimal/remainder, convert to integer then string
        converted_float = ""

        remainder = integer - integer.to_i #get whole number without decimal/remainder
        fraction = Rational(BigDecimal(remainder.to_s)).to_s #get deciimal/remainder and convert to fraction & BigDecimal for simple fractions
        whole_number = integer.to_i.to_s
        converted_float = converted_float + fraction

        if whole_number != "0" #if whole_number present add to converted_float
            converted_float.prepend(whole_number + "&")
        end
        return converted_float
    end

    #check for valid input
    def self.invalid_input user_input
        return true if !user_input #return true if input nil/blank
        valid = false
        check_for_operator = false  #validate for operator in every other loop

        user_input.split(" ").each do |input|
            #check for existence of operator
            if check_for_operator 
                if !["*", "/", "+", "-", "%"].include?(input) #if operator not present invalid_input is true and break
                    valid = true
                    break
                end
            else #check for existence of integer/fraction
                result = convert_fraction_to_float(input) #check for valid integer/fracton
                if !result.success?
                    valid = true
                    break
                end
            end
            check_for_operator = !check_for_operator
        end
        return valid
    end

end


