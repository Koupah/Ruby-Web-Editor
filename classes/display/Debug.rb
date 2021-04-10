require "strings"

class Debug < Display
  def initialize(x, y, w, h)
    super x, y, w, h
    @messages = []
  end

  def setup
    title = "DEBUG"
    Color.set(self, :yellow, :bright)
    setBorder("|", "-")
    setCursor((@width / 2) - (title.length / 2), 0)
    addText(title)
  end

  def debug(text)
    
    clearBox()

    Color.set(self, :green);
    
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
