require_relative "display/Debug"
require_relative "features/ConfigManager"
require_relative "features/ConfigDeleter"
require_relative "features/ConfigSharer"
require_relative "features/ConfigApplier"

class Program < Display
  def initialize(screen, header, arguments)
    super(0, header.height + 1, arguments[:debug] ? screen.width / 2 : screen.width, screen.height - header.height - 1)

    @screen = screen, @header = header, @arguments = arguments

    if arguments[:debug]
      @debug = Debug.new((screen.width / 2) + 1, header.height + 1, (screen.width / 2) - 1, screen.height - header.height - 1)
      @debug.setup()

      debug "@debug created"
    end

    debug "Arguments: #{arguments}"
  end

  def start
    debug "Making Config Folder (incase it doesn't exist)"
    makeConfigFolder()

    # TODO
    # DONEish - Logic handling input
    # DONE - NEED TO DO - Navigate to and from settings
    # DONE - Color our border Cyan

    while true
      defaultBox(self, "Ruby Web Editor - Home Screen")

      case getSelectionInput("What would you like to do?", [{ text: "Create/Edit Config", value: 1 }, { text: "Import/Export Config", value: 2 }, { text: "Delete a Config", value: 3 }, { text: "Apply/Use Web Editor Config", value: 4 }, { text: "Exit Program", value: 9 }])
      when 1
        ConfigManager.start(self)
      when 2
        ConfigSharer.start(self)
      when 3
        ConfigDeleter.start(self)
      when 4
        ConfigApplier.start(self)
      when 9
        break
      end
    end
  end

  # Debug method to clean up the calling of printing debug
  def debug(output)
    if @debug != nil
      @debug.debug(output)
    end
  end
end
