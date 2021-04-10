class Color
  include Curses

  def Color.setup
    Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_BLACK)
    Curses.init_pair(2, Curses::COLOR_YELLOW, Curses::COLOR_BLACK)
    Curses.init_pair(3, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
    Curses.init_pair(4, Curses::COLOR_CYAN, Curses::COLOR_BLACK)
    Curses.init_pair(5, Curses::COLOR_BLUE, Curses::COLOR_BLACK)
    Curses.init_pair(6, Curses::COLOR_MAGENTA, Curses::COLOR_MAGENTA)
    Curses.init_pair(7, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
    Curses.init_pair(8, Curses::COLOR_BLACK, Curses::COLOR_BLACK)
    
    @red = 1
    @yellow = 2
    @green = 3
    @cyan = 4
    @blue = 5
    @magenta = 6
    @white = 7
    @black = 8

    @dim = @dark = A_DIM
    @bright = @bold = A_BOLD
    @normal = @default = A_NORMAL
    @blink = @blinking = A_BLINK
  end
  
  def Color.set(display, id, type = @normal)
    # Disable previous color
    display.display.attroff(display.color) if display.color != nil

    # Set the color variable of that display, for caching
    display.setColor(Curses::color_pair(instance_variable_get("@#{id}")) | (type != @normal ? instance_variable_get("@#{type}") : type))

    # Enable the provided color
    display.display.attron(display.color)

  end

  def Color.setByAttribute(display, attribute)
    display.setColor(attribute)
    display.display.attron(attribute)
  end
end
