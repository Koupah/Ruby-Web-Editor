class ConfigCreator
    
    def ConfigCreator.validateInput(input)
        toReturn = {passed: true, message: ""};
        if !input.start_with?("apple")
            toReturn[:passed] = false;
            toReturn[:message] = "Input needs to start with apple";
        end
        return toReturn;
    end

    def ConfigCreator.start(display)
        display.getStringInput("input here", self.method(:validateInput));
    end


end