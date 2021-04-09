require "tty-prompt"
require "curses"
require_relative "Display"

class Screen
  include Curses

  attr_reader :width, :height, :displays

  def initialize(colors)
    init_screen

    if (colors)
      start_color
    end

    curs_set 0

    @height, @width, @displays = Curses.lines - 1, Curses.cols - 1, [{}]
  end

  def createDisplay(name, x, y, width, height)
    displays << { name: name, display: (display = Display.create(x, y, width, height)) }
    return display
  end

  def getDisplay(name)
    displays.find { |hash| hash[:name] == name }
  end
end
