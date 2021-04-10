require "test/unit"
require_relative "../classes/display/Display"

# Checking if the display works, most important part of the application

class DisplayTest < Test::Unit::TestCase
  def testNewInstance
    Color.setup();

    display = Display.new(1,2,3,4)
    assert_not_nil(display)
    assert_equal("OPTIONS", display.title)
    assert_equal(1, display.x)
    assert_equal(2, display.y)
    assert_equal(3, display.width)
    assert_equal(4, display.height)
    
    display2 = Display.new(4,5,6,7)
    assert_not_equal(display, display2)

    assert_not_equal(1, display2.x)
    assert_not_equal(2, display2.y)
    assert_not_equal(3, display2.width)
    assert_not_equal(4, display2.height)
  end

  def testNewInstanceNoParams
    assert_raise {
      display = Display.new
    }
  end
end
