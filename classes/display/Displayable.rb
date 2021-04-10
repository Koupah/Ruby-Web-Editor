require "curses"

module Displayable
  include Curses

  def update
    @display.refresh
  end

  def setColors(col1, col2, id)
    Curses.init_pair(id, col1, col2)
    @display.color_set(id)
    @display.refresh()
  end

  def setCursor(x, y)
    @display.setpos(y, x)
  end

  def getCursor
    return [@display.curx(), @display.cury]
  end

  def clearDisplay
    @display.clear
  end

  def setBorder(vertical, horizontal)
    @display.box(vertical, horizontal)
    @display.refresh()
  end

  def setText(text)
    @display.clear
    @display.addstr(text)
    @display.refresh()
  end

  def seperator(character)
    @display.setpos(@height, 0)
    @display.addstr(character * @width)
    update()
  end

  def addText(text)
    @display.addstr(text)
    @display.refresh
  end

  def fillLine(text)
    @display.addstr text * @width
    @display.refresh
  end

  def clearBox()
    cursor = getCursor()
    setCursor(1, 1)
    setColors(Curses::COLOR_BLACK, Curses::COLOR_BLACK, 100)
    (1..(@height - 1)).each { |y| setCursor(1, y); addText(" " * (@width - 2)) }
    setCursor(cursor[0], cursor[1])
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

  def getSelectionInput(message, selections)
    selection = 0
    max = selections.length - 1
    setKeypad(true)

    while true
      clearBox()
      @display.color_set(2)
      setCursor(1, 1)

      addText(message)

      setCursor(3, 2)
      addText("Up Arrow, W and 1 to navigate upwards.")
      setCursor(3, 3)
      addText("Down Arrow, S and 2 to navigate downwards.")

      current = 0
      selections.each { |hash|
        setCursor(1, 5 + current)
        @display.color_set(current == selection ? 4 : 3)
        addText((current == selection ? "-> " : "   ") + hash[:text])
        current += 1
      }

      character = @display.getch

      case character
      when KEY_UP
        selection = [selection - 1 < 0 ? max : selection - 1, 0].max
      when "s", "S", KEY_DOWN
        selection = [selection + 1 > max ? 0 : selection + 1, max].min
      when 10
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

  def getStringInput(message)
    setCursor(1, 1)

    hasErrored = false

    displayMessage = message

    while true
      clearBox()
      @display.color_set(2)
      setCursor(1, 1)

      addText(displayMessage)

      setCursor(3, 3)

      addText("> ")

      input = @display.getstr

      if input.length < 1
        displayMessage = message + "\nYour input needs to be atleast 1 character long!"
      else
        break
      end
    end
    return input
  end
end
