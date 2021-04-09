class Program < Display
  def initialize(screen, header)
    @screen = screen, @header = header;

    super(0, 8, screen.width, screen.height - header.height - 1);
    setColors(Curses::COLOR_CYAN, Curses::COLOR_BLACK, 2)

    setBorder("|", "-")
    setColors(Curses::COLOR_GREEN, Curses::COLOR_BLACK, 3)
    setCursor(1, 1)
    addText("#{@display.curx()} + #{@display.cury()} #{screen.height}")
  end

  def start

    # TODO
    # Logic handling input
    # Navigate to and from settings

    @display.getch
  end
end
