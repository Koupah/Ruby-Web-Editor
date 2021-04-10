require_relative "ConfigCreator"
require_relative "ConfigEditor"

class ConfigManager
  def ConfigManager.start(display)
    while true
      defaultBox(display, "Ruby Web Editor - Config Manager")

      case display.getSelectionInput("What would you like to do?", [{ text: "Create New Config", value: 1 }, { text: "Modify Existing Config", value: 2 }, { text: "Return", value: 9 }])
      when 1
        # ConfigCreator returns the name of the config we created, or false if we didnt
        result = ConfigCreator.start(display)
        display.debug("Result: #{result}")
        if result != false
          ConfigEditor.start(display, result)
        end
      when 2
        ConfigEditor.start(display)
      when 9
        break
      end
    end
  end
end
