require_relative "CssUtil"

class ClassVariable

  def ClassVariable.set(display, config)
    name = CssUtil.classVariableName(display.getStringInput("What is the name of the class you wish to modify? (Example: .text-box )"))

    if config.hasClassValues(name)
      display.popup("Appending to existing class in config!");
      values = config.getClassValues(name)[:values];
      config.removeClassValues(name)
    else
      values = []
    end
    

    # If 'done' isn't specified as input, add input to the values array
    while (value = display.getStringInput("Type a value to add to this class, or type \"Done\" if you're finished! (Example: background-color: #fff )")).downcase != "done"
      values << value
    end

    return { name: name, values: values }
  end

  def ClassVariable.get(name, values)
    return { name: name, values: values }
  end
end
