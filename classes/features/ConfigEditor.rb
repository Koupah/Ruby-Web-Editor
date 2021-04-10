require_relative "../Utility"
require_relative "css/Config"
require_relative "css/RootVariable"
require_relative "css/ClassVariable"

class ConfigEditor
  def ConfigEditor.options
    options = getAllConfigs()
    options << "Return (None)"
    return options
  end

  def ConfigEditor.start(display, name = nil)
    if name.nil?
      name = display.getScrollableSelectionInput("Which config would you like to edit?", self.options)
      return unless name.downcase != "return (none)"
    end

    config = Config.new(name)

    if config.load() == false
      display.popup("There was an error editing this config! (Possibly corrupt)", "Okay")
      return
    end

    while true
      case display.getSelectionInput("What do you wish to edit?", [{ text: "Root Variables", value: 1 }, { text: "Class Values", value: 2 }, { text: "Save & Return", value: 8 }, { text: "Return without Saving", value: 9 }])

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
      case display.getSelectionInput("What do you want to do with Root Variables?", [{ text: "Set Value of Root Variable", value: 1 }, { text: "Remove Root Variable from Config", value: 2 }, { text: "Return", value: 9 }])

      when 1
        rootVariable = RootVariable.set(display)
        config.addRootValue(rootVariable)
        display.popup("Added Root Variable \"#{rootVariable[:name]}\" to the config!")
        return
      when 2
        rootVariables = config.getRootNames
        rootVariables << "Return (None)"
        selection = display.getScrollableSelectionInput("What Root Variable do you wish to delete?", rootVariables)

        return if selection == "Return (None)"
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
      case display.getSelectionInput("What do you want to do with the Class Values?", [{ text: "Set values of a Class Variable", value: 1 }, { text: "Remove values from a Class Variable", value: 2 }, { text: "Delete a Class Variable from Config", value: 3 }, { text: "Return", value: 9 }])

      when 1
        classValues = ClassVariable.set(display, config)
        config.addClassValues(classValues)
        display.popup("Added Values for class \"#{classValues[:name]}\" to the config!")
        return
      when 2
        ConfigEditor.removeClassValues(display, config)
      when 3
        classVariables = config.getClassNames
        classVariables << "Return (None)"
        selection = display.getScrollableSelectionInput("What Class Variable do you wish to delete?", classVariables)

        return if selection == "Return (None)"
        config.removeClassVariable(selection)
        display.popup("Successfully removed \"#{selection}\" from the config!")
        return
      when 9
        return
      end
    end
  end

  def ConfigEditor.removeClassValues(display, config)
    while true
      classVariables = config.getClassNames()
      classVariables << "Return (None)"
      chosenClass = display.getScrollableSelectionInput("Which Class Variable do you want to remove values from?", classVariables)
      return if chosenClass == "Return (None)"

      while true
        trueValues = config.getClassVariable(chosenClass)[:values] # Remove last item

        choices = trueValues.dup
        choices << "Return (Finished)"

        
        selection = display.getScrollableSelectionInput("Which values do you want to remove from \"#{chosenClass}\"?", choices)
        break if selection == "Return (Finished)"

        trueValues.delete_at(trueValues.index(trueValues.find { |item| item.downcase == selection.downcase }))

        config.getClassVariable(chosenClass)[:values] = trueValues; # Set the new values

        display.popup("Successfully removed that value from \"#{chosenClass}\"!");
      end
    end
  end
end
