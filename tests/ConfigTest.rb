require "test/unit"
require_relative "../classes/features/css/Config"

# Config is HIGHLY relevant to the apps features as everything revolves around it

class ConfigTest < Test::Unit::TestCase
  def testNewInstance
    config = Config.new("configName")
    assert_not_nil(config)
    assert_equal("configName", config.name)

    config2 = Config.new("configName2")
    assert_not_nil(config2)
    assert_equal("configName2", config2.name)

    assert_not_equal(config, config2)
  end

  def testNewInstanceNoParams
    assert_raise {
      config = Config.new
    }
  end
end
