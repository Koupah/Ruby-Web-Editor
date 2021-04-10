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
    @red = 1
    @yellow = 2
    @green = 3
    @cyan = 4
    @blue = 5
    @magenta = 6
    @white = 7

    @dim = A_DIM
    @bright = A_BOLD
    @normal = A_NORMAL
  end

  def Color.set(display, id, type = @normal)
    display.display.attron(Curses::color_pair(instance_variable_get("@#{id}")) | (type != @normal ? instance_variable_get("@#{type}") : type))
    # display.color_set(instance_variable_get("@#{id}"))
  end
end
