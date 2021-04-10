require_relative "CssAble"

class RootVariable
  include CssAble

  def RootVariable.set()
    name = getStringInput("What is the name of the root variable you wish to set? (Example: --color-red)")

    values = []

    # If 'done' isn't specified as input, add input to the values array
    while (value = getStringInput("Type a value to add to this class, or type \"Done\" if you're finished! (Example: color: #fff)")).downcase != "done"
      values << value
    end

    return { name: classVariableName(name), values: values }
  end
end
