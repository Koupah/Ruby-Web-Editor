require_relative "../Utility"
class ConfigCreator
  def ConfigCreator.validateInput(input)
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
    display.getStringInput("What would you like to name this config?", self.method(:validateInput))
  end
end
