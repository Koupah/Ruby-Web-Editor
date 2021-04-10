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
    
    configName = display.getStringInput("What would you like to name this config? (Or type 'complete' to return)", self.method(:validateConfigName))
    return false unless (configName.downcase != "complete")

    makeConfigFile(configName)
    display.debug("Made config file with name: #{configName}")
    return configName;
  end
end
