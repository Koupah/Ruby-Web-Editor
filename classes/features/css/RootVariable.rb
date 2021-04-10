require_relative "CssUtil"

class RootVariable

  def RootVariable.set(display)
    name = CssUtil.rootVariableName(display.getStringInput("What is the name of the Root Variable you wish to set? (Example: --color-red )"))

    value = display.getStringInput("What is the value you wish to set to this Root Variable? (Example: color: #fff )")

    return { name: name, value: value }
  end

  def RootVariable.get(name, value)
    return { name: name, value: value }
  end
end
