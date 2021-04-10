require_relative "classes/Utility"
require_relative "classes/display/Screen"
require_relative "classes/display/Color"
require_relative "classes/Program"
require "color_math"

def endProgram
  Curses.close_screen
  exit
end

def main
  arguments = checkArguments()

  # Create our screen
  screen = Screen.new(arguments[:colors])

  # Setup our colors
  Color.setup()
  # Note added later on: Would've been cool if I presaved the colors values and set them back on program end
  # However I am lazy, so screw that

  # The display we will use for errors
  errorDisplay = screen.createDisplay("error", 0, 0, screen.width, screen.height)

  # I wrote this program to suit this height, just have a decently sized terminal window. Really, it's small (Unless you have like 480p monitor??)
  if (screen.height < 19)
    displayError(errorDisplay, "ERROR", "ERROR: Your terminal window is too short! Please make it taller!\nMinimum Height: 19 chars\nCurrent Height: #{screen.height} chars")
  elsif arguments[:help] # Display help message, unintentionally indented the arguments but I'm leaving it like that :shrug:
    displayError(errorDisplay, "HELP", "Command Line Arguments:\n
      -help: Show this message\n
      -rainbow: Rainbow header\n
      -debug: Show debug menu\n
      -nocolor: Run application without color\n
      -noanimation: Skip the animation on application startup\n\nPress any key to exit.")
  end

  # Header Art
  headerRaw = "( Ruby Web Editor )" # Raw header (not art), used for iterating over
  headerArt = generateArt(headerRaw, "big") # Final header art, for use after animation
  stringWidth = getWidth(headerArt)
  header = screen.createDisplay("header", (screen.width / 2) - (stringWidth / 2) - 1, 0, stringWidth + 1, 7)

  Color.set(header, :red, :bright)

  # Header Startup Animation
  # Tried removing the flicker, but it just causes too many issues ):
  if arguments[:animation]
    (0..headerRaw.length).each { |index|
      header.setText(generateArt(headerRaw[0..index], "big"))
      sleep(0.1)
    }
  end

  # Set the final version of the header, not to be touched from here on
  header.setText generateArt("( Ruby Web Editor )", "big")

  if arguments[:rgb]
    Thread.new {
      # The ideal solution would be to set the ID so out of this world it can't be accidentally used, but cpu's have limitations
      # And I want this to work on as many platforms as possible...
      # Why do people still have 32 bit systems )':
      # Also, there seems to be a max ID ~ 10??. I guess 9 will work for now

      # Update: this is like a secret feature anyways, why do i care ??
      # Updated Update: Not secret, but not really known unless you pass --help
      id = 9
      Curses.init_color(id, 255, 0, 0)
      header.display.attron(id)
      value = 1
      while true
        rgb = ColorMath.from_hsl(value, 100, 60).to_rgb
        Curses.init_color(id, rgb[0] * 3, rgb[1] * 3, rgb[2] * 3)
        sleep(0.2)
        header.display.refresh
        value = (value + 20) % 360
      end
    }
  end

  # Create our main program
  program = Program.new(screen, header, arguments)

  # Program.start is blocking, once it's complete the app is over
  program.start

  # Clear the displays
  program.display.clear
  errorDisplay.display.clear
  header.display.clear

  # Reuse Error Display for exit screen
  displayError(errorDisplay, "EXITING", "\nThank you for using Ruby Web Editor!\n\nPress any key to exit.")
end

def displayError(errorDisplay, title, error)
  errorDisplay.setKeypad(true)
  Color.set(errorDisplay, :red, :bright)
  box = TTY::Box.frame(width: errorDisplay.width - 1, height: errorDisplay.height - 1, title: { top_left: title }) do
    error
  end
  errorDisplay.setCursor(0, (errorDisplay.height / 2) - (box.split(/\n/).length / 2))
  errorDisplay.addText(box)
  errorDisplay.display.getch
  endProgram
end

main
