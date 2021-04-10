require_relative "../Utility"

class ConfigCreator
  def ConfigCreator.validateConfigName(input)
    toReturn = { passed: true, message: "" }

    if configExists(input)
      toReturn[:passed] = false
      toReturn[:message] = "A Config with that name already exists!"
    elsif !alphanumeric(input)
      toReturn[:passed] = false
      toReturn[:message] = "Config names can only be alphanumeric (and can't contain spaces)!"
    end
    return toReturn
  end

  def ConfigCreator.start(display)
    display.getSrollableSelectionInput("How would you like to begin?", ('a'..'z').to_a)
    configName = display.getStringInput("What would you like to name this config? (Or type 'back' to return)", self.method(:validateConfigName))
    return unless (configName.downcase != "back")

    makeConfigFile(configName)
    display.debug("Made config file with name: #{configName}")

    
  end
end
