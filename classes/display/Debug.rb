require "strings"

class Debug < Display
  def initialize(x, y, w, h)
    super x, y, w, h
    @messages = []
  end

  def setup
    title = "DEBUG"
    setColors(Curses::COLOR_YELLOW, Curses::COLOR_BLACK, 4)
    setBorder("|", "-")
    setCursor((@width / 2) - (title.length / 2), 0)
    addText(title)
  end

  def debug(text)
    
    clearBox()

    setColors(Curses::COLOR_GREEN, Curses::COLOR_BLACK, 5)

    setCursor(1, 1)
    
    @messages << "---"
    @messages.push(*Strings.wrap(text, @width - 3).split(/\n/).reverse)

    line = 1
    @messages.reverse.each { |message|
      setCursor(1, line)
      addText(message)
      line += 1

      if line >= @height
        break
      end
    }
  end
end
