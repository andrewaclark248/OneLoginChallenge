require "tty-prompt"
require 'ostruct'
prompt = TTY::Prompt.new

#parse user input by looping through each integer/fraction and operator and add to running total
#use metaprogramming via ruby public_send method to cacluate result
#convert integer/fractions to floats
#easier to calculate total via float addition than traditional mathematical methods
def parse_input user_input
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

        #use metaprogramming to multiply/divide/add/subtract/minus/modulo
        loop_total = loop_total.public_send(current_operator, result.converted_number) 
    end
    #convert from float to fraction
    total = convert_float_to_fraction(loop_total)
    return total
end

#convert numbers from from fraction (1&3/4) to integer/floats 
def convert_fraction_to_float user_input
    converted_number = 0
    user_input.split("&").each do |input|
        current_value = Rational(input).to_f 
        converted_number = converted_number + current_value
    end
    result = OpenStruct.new(success?: true, converted_number: converted_number)
    return result
rescue
    return OpenStruct.new(success?: false)
end

#convert float to fraction
def convert_float_to_fraction integer
    return integer.to_i.to_s if integer%1 == 0
    return_string = ""
    remainder = integer - integer.to_i
    fraction = Rational(remainder).to_s
    whole_number = integer.to_i.to_s
    return_string = return_string + fraction
    if whole_number != "0"
        return_string.prepend(whole_number + "&")
    end
    return return_string
end

#check for valid input
def invalid_input user_input
    return true if !user_input
    valid = false
    check_for_operator = false
    split_input = user_input.split(" ")
    split_input.each do |input|
        if check_for_operator #check for existence of operator
            if !["*", "/", "+", "-", "%"].include?(input)
                valid = true
                break
            end
        else #check for existence of integer/fraction
            result = convert_fraction_to_float(input)

            if !result.success?
                valid = true
                break
            end
        end
        check_for_operator = !check_for_operator
    end
    return valid
end


#constantly ask for user input unless exited
start_loop = true
while start_loop
    #ask user for input
    user_input = prompt.ask("Enter alegrabic eqution (ex: 1+5) for awnser or type 'exit' to leave:")

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

