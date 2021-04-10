require "curses"

module Displayable
  include Curses

  def setCursor(x, y)
    @display.setpos(y, x)
  end

  def getCursor
    return [@display.curx(), @display.cury]
  end

  def clearDisplay
    @display.clear
  end

  def setBorder(vertical, horizontal, title = "")
    @display.box(vertical, horizontal)
    @display.refresh()

    cursor = getCursor()
    setCursor(5, 0)
    addText(title)
    setCursor(cursor[0], cursor[1])
  end

  def setText(text, quick = false)
    @display.clear
    @display.addstr(text)
    if quick
      doupdate
    else
      @display.refresh
    end
  end

  def seperator(character)
    @display.setpos(@height, 0)
    @display.addstr(character * @width)
    @display.refresh()
  end

  def addText(text, quick = false)
    @display.addstr(text)

    # doupdate is a quicker version, but doesn't work sometimes
    # Making it optional allows me to choose when it should be a quick text add
    # Main reason for wanting it is to prevent flicker
    if quick
      doupdate
    else
      @display.refresh
    end
  end

  def fillLine(text)
    @display.addstr text * @width
    @display.refresh
  end

  def clearBox(quick = false)
    color = @color
    cursor = getCursor()
    setCursor(1, 1)
    Color.set(self, :black)
    (1..(@height - 1)).each { |y| setCursor(1, y); addText(" " * (@width - 2), quick) }
    setCursor(cursor[0], cursor[1])
    Color.setByAttribute(self, @color)
  end

  def setKeypad(bool)
    @display.keypad = bool
    if (bool)
      cbreak
      noecho
    else
      nocbreak
      echo
    end
  end

  # So proud of me for making this as 'clean' as i did
  def popup(message, selection = "Okay")
    setKeypad(true)

    while true
      clearBox(true)
      Color.set(self, :yellow, :bright)
      setCursor(1, 0)

      curspos = getCursor()
      message.split(/\n/).each { |line|
        setCursor(curspos[0], getCursor()[1] + 1)
        addText(line)
      }

      Color.set(self, :white, :dim)
      setCursor(2, getCursor()[1] + 1)
      addText("- Press Enter, K or 3 to continue.", true)

      setCursor(1, getCursor()[1] + 2)
      Color.set(self, :green, :bright)
      addText("-> " + selection, false)

      character = @display.getch
      case character
      when 10, "k", "K", "3" # Confirm option
        break
      else
        debug "#{character}"
      end
      doupdate
    end
    setKeypad(false)
    @display.refresh()
    return true
  end

  def selectionOutput(message)
    clearBox(true)
    Color.set(self, :yellow, :bright)
    setCursor(1, 0)

    curspos = getCursor()
    message.split(/\n/).each { |line|
      setCursor(curspos[0], getCursor()[1] + 1)
      addText(line)
    }

    Color.set(self, :white, :dim)
    setCursor(2, getCursor()[1] + 1)
    addText("- Up Arrow, W and 1 to navigate upwards.", true)
    setCursor(2, getCursor()[1] + 1)
    addText("- Down Arrow, S and 2 to navigate downwards.", true)
    setCursor(2, getCursor()[1] + 1)
    addText("- Enter, K and 3 to confirm selection.", true)
  end

  # So proud of me for making this as 'clean' as i did
  def getScrollableSelectionInput(message, selections)
    selection = 0
    max = selections.length - 1
    setKeypad(true)

    while true
      selectionOutput(message)

      current = 0
      y = getCursor[1] + 2

      range = ([0, selection - 2].max..[selection + [4 - selection, 2].max, max].min)

      dif = range.to_a[0]

      selections[range].each { |item|
        debug(item)
        setCursor(1, y + current)
        Color.set(self, current + dif == selection ? :green : :cyan, :bright)
        addText((current + dif == selection ? "-> " : "   ") + item, false)
        current += 1
      }

      character = @display.getch
      case character
      when "w", "W", "1", KEY_UP # Up
        selection = [selection - 1 < 0 ? max : selection - 1, 0].max
      when "s", "S", "2", KEY_DOWN # Down
        selection = [selection + 1 > max ? 0 : selection + 1, max].min
      when 10, "k", "K", "3" # Confirm option
        break
      else
        debug "#{character}"
      end
      doupdate
    end
    setKeypad(false)
    @display.refresh()
    return selections[selection]
  end

  def getSelectionInput(message, selections)
    selection = 0
    max = selections.length - 1
    setKeypad(true)

    while true
      selectionOutput(message)

      current = 0
      y = getCursor[1] + 2
      selections.each { |hash|
        setCursor(1, y + current)
        Color.set(self, current == selection ? :green : :cyan, :bright)
        addText((current == selection ? "-> " : "   ") + hash[:text], true)
        current += 1
      }

      character = @display.getch

      case character
      when "w", "W", "1", KEY_UP # Up
        selection = [selection - 1 < 0 ? max : selection - 1, 0].max
      when "s", "S", "2", KEY_DOWN # Down
        selection = [selection + 1 > max ? 0 : selection + 1, max].min
      when 10, "k", "K", "3" # Confirm option
        break
      else
        debug "#{character}"
      end
      doupdate
    end
    setKeypad(false)
    @display.refresh()
    return selections[selection][:value]
  end

  # Catch any color_set's on the wrong object
  def color_set(id)
    @display.color_set(id)
  end

  def getStringInput(message, inputChecker = nil)
    setCursor(1, 1)

    input = nil

    while true
      clearBox()

      @display.color_set(2)

      setCursor(1, 0)

      curspos = getCursor()
      message.split(/\n/).each { |line|
        setCursor(curspos[0], getCursor()[1] + 1)
        addText(line)
      }

      if input != nil
        prev = @color
        Color.set(self, :red, :bright)
        if input.length < 1
          setCursor(2, getCursor()[1] + 1) # Put it the line after message
          addText("Your input needs to be atleast 1 character long!")
        elsif inputChecker != nil && !(checkerOutput = inputChecker.call(input))[:passed]
          setCursor(2, getCursor()[1] + 1) # Put it the line after message
          addText(checkerOutput[:message])
        else
          break
        end
        Color.setByAttribute(self, prev)
      end

      setCursor(3, getCursor()[1] + 2)

      Color.set(self, :green, :blink)
      addText("> ")
      Color.set(self, :green, :bright)

      # Set input, wrap back around
      input = @display.getstr
    end
    return input
  end
end
