require "rails"
require 'pry'
require './spec_helper.rb'
require './app/cli_app.rb'

RSpec.describe CliApp do

    describe 'CliApp.parse_input' do
        context "success" do
            it 'addition' do
                value = CliApp.parse_input("1 + 5")
                expect(value).to eq("6")
            end
            it 'subtraction' do
                value = CliApp.parse_input("12 - 5")
                expect(value).to eq("7")
            end
            it 'multiplication' do
                value = CliApp.parse_input("8 * 234")
                expect(value).to eq("1872")
            end
            it 'divide' do
                value = CliApp.parse_input("100 / 25")
                expect(value).to eq("4")
            end
            it 'modulo' do
                value = CliApp.parse_input("134 % 43")
                expect(value).to eq("5")
            end
            it "fractions" do
                value = CliApp.parse_input("12&1/2 + 5")
                expect(value).to eq("17&1/2")          
            end
            it "negative" do
                value = CliApp.parse_input("112 - 543")
                expect(value).to eq("-431") 
            end
            context "asked for test cases" do
                it "1/2 * 3&3/4" do
                    value = CliApp.parse_input("1/2 * 3&3/4")
                    expect(value).to eq("1&7/8")      
                end
                it "2&3/8 + 9/8" do
                    value = CliApp.parse_input("2&3/8 + 9/8")
                    expect(value).to eq("3&1/2") 
                end                
                it "1&3/4 - 2" do
                    value = CliApp.parse_input("1&3/4 - 2")
                    expect(value).to eq("-1/4") 
                end
                it "11 % 3" do
                    value = CliApp.parse_input("11 % 3")
                    expect(value).to eq("2") 
                end
            end
        end
        context "failure" do
            it "invalid input" do
                value = CliApp.parse_input("233$$!")
                expect(value).to eq("Unknown Error Occured")
            end
            it "invalid input w/space" do
                value = CliApp.parse_input("233$$! + 2333abd")
                expect(value).to eq("Unknown Error Occured")
            end
            it "adhere to space rule" do
                value = CliApp.parse_input("100+400")
                expect(value).to eq("Unknown Error Occured")         
            end
        end
    end
    describe 'CliApp.convert_fraction_to_float' do
        context "success" do
            it "whole number conversion" do 
                result = CliApp.convert_fraction_to_float("100")
                
                expect(result.success?).to eq(true)
                expect(result.converted_number).to eq(100.0)  
            end  
            it "decimal" do 
                result = CliApp.convert_fraction_to_float("494.42")
                
                expect(result.success?).to eq(true)
                expect(result.converted_number).to eq(494.42)  
            end  
            it "fraction" do 
                result = CliApp.convert_fraction_to_float("1/2")
                
                expect(result.success?).to eq(true)
                expect(result.converted_number).to eq(0.5)  
            end 
            it "whole nuber and fraction" do 
                result = CliApp.convert_fraction_to_float("4&1/2")
                
                expect(result.success?).to eq(true)
                expect(result.converted_number).to eq(4.5)  
            end
            #it "negative" do
            #    result = CliApp.convert_fraction_to_float("-5&6/8")
                
            #    expect(result.success?).to eq(true)
            #    expect(result.converted_number).to eq(-5.75)              
            #end   
        end
        context "failure" do
            it "invalid input" do
                result = CliApp.convert_fraction_to_float("43*%**%23")
                expect(result.success?).to eq(false)
            end
            it "invalid input w/space" do
                result = CliApp.convert_fraction_to_float("asdf233 + 2333abd")
                expect(result.success?).to eq(false)
            end
            it "adhere to space rule" do
                result = CliApp.convert_fraction_to_float("12+42")
                expect(result.success?).to eq(false)
            end
        end    
    end
    describe 'CliApp.convert_float_to_fraction' do
        context "success" do
            it "whole number conversion" do 
                value = CliApp.convert_float_to_fraction(0.5)
                expect(value).to eq("1/2")  
            end  
            it "whole number conversion" do 
                value = CliApp.convert_float_to_fraction(0.25)
                expect(value).to eq("1/4")  
            end  
            it "whole number conversion" do 
                value = CliApp.convert_float_to_fraction(0.423)
                expect(value).to eq("423/1000")  
            end  
            it "whole number conversion" do 
                value = CliApp.convert_float_to_fraction(0.923423)
                expect(value).to eq("923423/1000000")  
            end  
        end
    end   
    describe 'CliApp.invalid_input' do
        context "invalid characters" do
            it "whole number conversion" do 
                invalid_input = CliApp.invalid_input(nil)
                expect(invalid_input).to eq(true)  
            end  
            it "missing operator" do 
                invalid_input = CliApp.invalid_input("2342 9968")
                expect(invalid_input).to eq(true)  
            end  
            it "bad charcters" do 
                invalid_input = CliApp.invalid_input("2939392ASDFAsdff")
                expect(invalid_input).to eq(true)  
            end  
            it "missing space" do 
                invalid_input = CliApp.invalid_input("2+3")
                expect(invalid_input).to eq(true)  
            end  
        end
        context "valid characters" do
            it "addtion formula" do 
                invalid_input = CliApp.invalid_input("2 + 3")
                expect(invalid_input).to eq(false)  
            end  
            it "fraction + fraction" do 
                invalid_input = CliApp.invalid_input("1/2 + 4/5")
                expect(invalid_input).to eq(false)  
            end   
            it "fraction/number + fraction" do 
                invalid_input = CliApp.invalid_input("4&5/9 + 8/9")
                expect(invalid_input).to eq(false)  
            end   
            it "fraction/number + fraction/number" do 
                invalid_input = CliApp.invalid_input("5&5/6 + 3/5")
                expect(invalid_input).to eq(false)  
            end           
        end
    end
end



