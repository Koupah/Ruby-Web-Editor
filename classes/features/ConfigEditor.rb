require_relative "../Utility"
require_relative "css/Config"
require_relative "css/RootVariable"
require_relative "css/ClassVariable"

class ConfigEditor
  def ConfigEditor.options
    options = getAllConfigs()
    options << "Back (None)"
    return options
  end

  def ConfigEditor.start(display, name = nil)
    if name.nil?
      name = display.getScrollableSelectionInput("Which config would you like to edit?", self.options)
      return unless name.downcase != "back (none)"
    end

    config = Config.new(name)

    if config.load() == false
      display.popup("There was an error editing this config! (Possibly corrupt)", "Okay")
      return
    end

    while true
      case display.getSelectionInput("What do you wish to edit?", [{ text: "Root Variables", value: 1 }, { text: "Class Values", value: 2 }, { text: "Save & Go Back", value: 8 }, { text: "Go Back without Saving", value: 9 }])

      when 1
        ConfigEditor.rootVariablesEditor(display, config)
      when 2
        ConfigEditor.classValuesEditor(display, config)
      when 8
        config.save()
        return
      when 9
        return
      end
    end
  end

  def ConfigEditor.rootVariablesEditor(display, config)
    while true
      case display.getSelectionInput("What do you want to do with Root Variables?", [{ text: "Set Value of Root Variable", value: 1 }, { text: "Remove Root Variable from Config", value: 2 }, { text: "Go Back", value: 9 }])

      when 1
        rootVariable = RootVariable.set(display)
        config.addRootValue(rootVariable)
        display.popup("Added Root Variable \"#{rootVariable[:name]}\" to the config!")
        return
      when 2
        rootVariables = config.getRootNames
        rootVariables << "Back (None)"
        selection = display.getScrollableSelectionInput("What Root Variable do you wish to delete?", rootVariables)

        return if selection == "Back (None)"
        config.removeRootVariable(selection)
        display.popup("Successfully removed \"#{selection}\" from the config!")
        return
      when 9
        return
      end
    end
  end

  def ConfigEditor.classValuesEditor(display, config)
    while true
      case display.getSelectionInput("What do you want to do with the Class Values?", [{ text: "Set Values of a CSS Class", value: 1 }, { text: "Remove values from a Class Variable in the Config", value: 2 }, { text: "Remove CSS Class from Config", value: 3 }, { text: "Go Back", value: 9 }])

      when 1
        classValues = ClassVariable.set(display, config)
        config.addClassValues(classValues)
        display.popup("Added Values for class \"#{classValues[:name]}\" to the config!")
        return
      when 2
        
      when 3
        rootVariables = config.getRootNames
        rootVariables << "Back (None)"
        selection = display.getScrollableSelectionInput("What Class's Values do you wish to delete?", rootVariables)

        return if selection == "Back (None)"
        config.removeClassVariable(selection)
        display.popup("Successfully removed \"#{selection}\" from the config!")
        return
      when 9
        return
      end
    end
  end
end
