require_relative "CssAble"

class RootVariable
  include CssAble

  def RootVariable.set()
    name = getStringInput("What is the name of the root variable you wish to set? (Example: --color-red )")

    value = getStringInput("What is the value you wish to set to this root variable? (Example: color: #fff )")

    return { name: rootVariableName(name), values: [value] }
  end
end
