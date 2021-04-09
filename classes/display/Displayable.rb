require "curses"

module Displayable

  def setColors(col1, col2, id)
    Curses.init_pair(id, col1, col2)
    @display.color_set(id)
    @display.refresh
  end

  def setCursor(x, y) 
    @display.setpos(y, x);
  end

  def getCursor
    return [@display.curx(), @display.cury];
  end

  def clearDisplay
    @display.clear;
  end

  def setBorder(vertical, horizontal)
    @display.box(vertical, horizontal)
    @display.refresh;
  end

  def setText(text)
    @display.clear
    @display.addstr(text)
    @display.refresh
  end

  def seperator(character)
    @display.setpos(@height, 0)
    @display.addstr(character * @width)
    @display.refresh
  end

  def addText(text)
    @display.addstr(text)
    @display.refresh
  end

  def fillLine(text)
    @display.addstr text * @width
    @display.refresh
  end
end
