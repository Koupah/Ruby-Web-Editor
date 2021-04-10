require_relative "display/Debug"
require_relative "features/ConfigManager"
require_relative "display/Color"

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
    # NEED TO DO - Navigate to and from settings
    # DONE - Color our border Cyan
    Color.set(self, :cyan)
    setBorder("|", "-")

    setCursor(5, 0)
    addText("OPTIONS")

    # We want content to be green
    Color.set(self, :green, :bright)

    # Set our cursor inside of the box for writing content
    setCursor(1, 1)

    while true
      case getSelectionInput("What would you like to do?", [{ text: "Create/Edit Web Editor Config", value: 1 }, { text: "Export/Import Web Editor Config", value: 2 }, { text: "Delete Web Editor Config", value: 3 }, { text: "Apply/Use Web Editor Config", value: 4 }, { text: "Exit Program", value: 9 }])
      when 1
        ConfigManager.start(self)
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
