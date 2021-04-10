# Best name I could come up with LMAO
module CssAble

  # Function to ensure root variable name begins with --
  def rootVariableName(name)
    if !name.start_with?("--")
      name = "--" + name
    end
    return name
  end

  # Function to ensure class name begins with .
  def classVariableName(name)
    if !name.start_with?(".")
        name = "." + name;
    end
    return name;
  end
end
