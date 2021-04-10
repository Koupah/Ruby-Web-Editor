require_relative "CssAble"

class ClassVariable
  include CssAble

  def ClassVariable.set()
    name = getStringInput("What is the name of the class you wish to modify? (Example: .text-box )")

    values = []

    # If 'done' isn't specified as input, add input to the values array
    while (value = getStringInput("Type a value to add to this class, or type \"Done\" if you're finished! (Example: background-color: #fff )")).downcase != "done"
      values << value
    end

    return { name: classVariableName(name), values: values }
  end
end
