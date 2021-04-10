require_relative "classes/Utility"
require_relative "classes/display/Screen"
require_relative "classes/Program"

def main
  arguments = checkArguments()

  # Create our screen
  screen = Screen.new(arguments[:colors])

  errorDisplay = screen.createDisplay("error", 0, 0, screen.width, screen.height)

  Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_BLACK)

  if (screen.height < 19)
    displayError(errorDisplay, "ERROR", "ERROR: Your terminal window is too short! Please make it taller!\nMinimum Height: 19 chars\nCurrent Height: #{screen.height} chars")
    exit
  end

  # Header Art
  headerRaw = "( Ruby Web Editor )"
  headerArt = generateArt(headerRaw, "big")
  stringWidth = getWidth(headerArt)
  header = screen.createDisplay("header", (screen.width / 2) - (stringWidth / 2) - 1, 0, stringWidth + 1, 7)
  header.setColors(Curses::COLOR_RED, Curses::COLOR_BLACK, 1)

  # Header Startup Animation
  if arguments[:animation]
    (0..headerRaw.length).each { |index|
      header.setText(generateArt(headerRaw[0..index], "big"))
      sleep(0.1)
    }
  end

  header.setText generateArt("( Ruby Web Editor )", "big")

  program = Program.new(screen, header, arguments)
  program.start

  program.display.clear
  errorDisplay.display.refresh

  # Reuse Error Display for exit screen
  displayError(errorDisplay, "EXITING", "\nThank you for using Ruby Web Editor!\n\nPress any key to exit.")
end

def displayError(errorDisplay, title, error)
  errorDisplay.setKeypad(true)
  errorDisplay.display.color_set(1)
  box = TTY::Box.frame(width: errorDisplay.width - 1, height: errorDisplay.height - 1, title: { top_left: title }) do
    error
  end
  errorDisplay.setCursor(0, (errorDisplay.height / 2) - (box.split(/\n/).length / 2))
  errorDisplay.addText(box)
  errorDisplay.display.getch
end

main
