require_relative "Displayable"
require_relative "Color"
require "curses"
require "tty-box"

class Display
  include Displayable
  include Curses

  @@displays = []

  attr_reader :display, :x, :y, :width, :height, :color, :title

  def initialize(x, y, w, h, ignore = false)
    @display = Curses::Window.new(h + 1, w, y, x) # 1 needs to be added onto our height to make it correct, seems to be an issue with Curses?
    @x, @y, @width, @height, @color, @title = x, y, w, h, nil, "OPTIONS";

    Color.set(self, :white)

    if !ignore
      @@displays << self
    end
    clearDisplay()
  end

  def Display.create(x, y, w, h)
    return Display.new(x, y, w, h)
  end

  def Display.refreshAll
    @@displays.each { |display| display.display.refresh() }
  end

  def setColor(col)
    @color = col
  end
end
