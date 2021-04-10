require "test/unit"
require_relative "../classes/display/Color"

class ColorTest < Test::Unit::TestCase
  def testNoSetup
    id = Color.get(:red)
    assert_nil(id)
  end

  def testVariables
    Color.setup()
    id = Color.get(:red)

    assert_equal(1, id)
    assert_not_equal("1", id)
  end

  def testNoParams
    assert_raise {
      id = Color.get
    }
  end
end
