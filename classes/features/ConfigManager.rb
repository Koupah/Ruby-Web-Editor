class ConfigManager
  def ConfigManager.start(program)
    while true
      case program.getSelectionInput("How would you like to begin?", [{ text: "Create New Config", value: 1 }, { text: "Modify Existing Config", value: 2 }, { text: "Go Back", value: 9 }])
      when 1
      when 9
        break
      end
    end
  end
end
