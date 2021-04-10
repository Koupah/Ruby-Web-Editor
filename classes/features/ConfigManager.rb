require_relative "ConfigCreator"
class ConfigManager
  def ConfigManager.start(display)
    while true
      case display.getSelectionInput("How would you like to begin?", [{ text: "Create New Config", value: 1 }, { text: "Modify Existing Config", value: 2 }, { text: "Go Back", value: 9 }])
      when 1
        ConfigCreator.start(display);
      when 9
        break
      end
    end
  end
end
