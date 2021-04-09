require_relative "Displayable"
require "curses"
require "tty-box"

class Display
  include Displayable
  include Curses

  attr_reader :display, :x, :y, :width, :height, :background, :foreground, :border

  def initialize(x, y, w, h)
    @display = Curses::Window.new(h + 1, w, y, x) # 1 needs to be added onto our height to make it correct, seems to be an issue with Curses?
    @x = x, @y = y, @width = w, @height = h, @border = false

    clearDisplay()
  end

  def Display.create(x, y, w, h)
    return Display.new(x, y, w, h)
  end
end