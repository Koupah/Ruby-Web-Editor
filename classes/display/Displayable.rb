require "curses"

module Displayable

  include Curses;

  def update
    doupdate;
  end

  def setColors(col1, col2, id)
    Curses.init_pair(id, col1, col2)
    @display.color_set(id)
    @display.refresh();
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
    @display.refresh();
  end

  def setText(text)
    @display.clear
    @display.addstr(text)
    @display.refresh();
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
    setCursor(1, 1)
    setColors(Curses::COLOR_BLACK, Curses::COLOR_BLACK, 100)
    (1..(@height - 1)).each { |y| setCursor(1, y); addText(" " * (@width - 2)) }
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

  def makeSelection(message, selections)
    selection = 0
    max = selections.length - 1
    setKeypad(true)
    
    while true
      clearBox()
      @display.color_set(2)
      setCursor(1, 1)

      addText(message)

      current = 0
      selections.each { |hash|
        setCursor(1, 3 + current)
        @display.color_set(current == selection ? 3 : 2)
        addText((current == selection ? "-> " : "   ") + hash[:text])
        current += 1
      }

      character = @display.getch

      case character
      when KEY_UP
        selection = [selection -= 1, 0].max
      when "s", "S", KEY_DOWN
        selection = [selection += 1, max].min
      when 10
        break;
      else
        debug "#{character}";
      end

      debug "done"

      doupdate
    end
    setKeypad(false)

    return selections[selection][:value];
  end
end
