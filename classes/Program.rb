require_relative "display/Debug"

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

    # Color our border Cyan
    setColors(Curses::COLOR_CYAN, Curses::COLOR_BLACK, 2)
    setBorder("|", "-")

    # We want content to be green
    setColors(Curses::COLOR_GREEN, Curses::COLOR_BLACK, 3)

    # Set our cursor inside of the box for writing content
    setCursor(1, 1)

    debug("#{makeSelection("Choose an option!", [{text: "option 1", value: 1}, {text: "option 2", value: 2}, {text: "third option", value: 3}])}");

  end

  def start

    # TODO
    # Logic handling input
    # Navigate to and from settings

    @display.getch
  end

  # Debug method to clean up the calling of printing debug
  def debug(output)
    if @debug != nil
      @debug.debug(output)
    end
  end
end
