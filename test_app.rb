require "tty-prompt"
prompt = TTY::Prompt.new

def parse_input user_input
    split_input = user_input.split(" ")
    total = 0
    current_operator = "+" #set to plus so that the first integer is added
    split_input.each do |input|
        #get current operator
        if ["*", "/", "+", "-", "%"].include?(input)
            current_operator = input
            next
        end

        #if numbers convert fractions to floats
        current_integer = convert_fraction_to_integer(input) #Rational(input).to_f
        
        #if no operator skip else execute operator
        if current_operator
            total = total.public_send(current_operator, current_integer) 
        else
            next
        end
    end
    returnvar = convert_integer_to_fraction(total)
    return returnvar
end

def convert_fraction_to_integer user_input
    total = 0
    user_input.split("&").each do |input|
        current_value = Rational(input).to_f 
        total = total + current_value
    end
    return total
end

def convert_integer_to_fraction integer
    return integer.to_i.to_s if integer%1 == 0
    return_string = ""
    remainder = integer - integer.to_i
    fraction = Rational(remainder).to_s
    whole_number = integer.to_i.to_s
    return_string = whole_number + "&" + fraction
    return return_string
end

def invalid_input user_input
    return true if !user_input
    #split_input = user_input.split(" ")
end






not_hit_exit = true

while not_hit_exit

    user_input = prompt.ask("Enter alegrabic eqution (ex: 1+5) for awnser or type 'exit' to leave:")
    
    #check for valid user input
    if invalid_input(user_input)
        puts "Invalid Input. Please enter value!"
        next
    end
    if user_input == "exit"
        return
    end

    puts parse_input(user_input)


end

