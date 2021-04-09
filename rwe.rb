require_relative "classes/Utility"
require_relative "classes/display/Screen"
require_relative "classes/Program"

def main
  # Create our screen
  screen = Screen.new

  errorDisplay = screen.createDisplay("error", 0, 0, screen.width, screen.height)

  if (screen.height < 19)
    errorDisplay.setColors(Curses::COLOR_RED, Curses::COLOR_BLACK, 1)
    box = TTY::Box.frame(width: screen.width - 1, height: screen.height, title: { top_left: "ERROR" }) do
      "ERROR: Your terminal window is too short! Please make it taller!\nMinimum Height: 19 chars\nCurrent Height: #{screen.height} chars"
    end
    errorDisplay.addText(box)
    errorDisplay.display.getch
    exit
  end

  headerArt = generateArt("( Ruby Web Editor )", "big")
  stringWidth = getWidth(headerArt)
  header = screen.createDisplay("header", (screen.width / 2) - (stringWidth / 2) - 1, 0, stringWidth + 1, 7)
  header.setColors(Curses::COLOR_RED, Curses::COLOR_BLACK, 1)

  header.setText generateArt("( Ruby Web Editor )", "big")

  program = Program.new(screen, header);
  program.start


  errorDisplay.setColors(Curses::COLOR_RED, Curses::COLOR_BLACK, 1)
  box = TTY::Box.frame(width: [screen.width, 40].min, height: [screen.height, 7].min, title: { top_left: "EXITING" }) do
    "\nThank you for using Ruby Web Editor!\n\nPress any key to exit."
  end
  errorDisplay.setCursor(0, (screen.height / 2) - (box.split(/\n/).length / 2))
  errorDisplay.addText(box)
  errorDisplay.display.getch

end

main
