require_relative "../Utility"

class ConfigDeleter
  def ConfigDeleter.options
    options = getAllConfigs()
    options << "Return (Don't Delete)"
    return options
  end

  def ConfigDeleter.start(display)
    while true

      defaultBox(display, "Ruby Web Editor - Config Deleter")

      toDelete = display.getScrollableSelectionInput("Which Config would you like to delete?", self.options)

      # Return if they select 'return'
      return unless (toDelete.downcase != "return (don't delete)")

      if display.getSelectionInput("Are you sure you want to delete \"#{toDelete}\"?", [{ text: "Yes", value: true }, { text: "No", value: false }])
        display.debug("Deleting config file: #{toDelete}")

        if deleteConfig(toDelete)
          display.popup("\"#{toDelete}\" has been deleted!", "Okay")
        else
          display.popup("There was an error while deleting \"#{toDelete}\"!", "Okay")
        end
        return
      end
    end
  end
end
