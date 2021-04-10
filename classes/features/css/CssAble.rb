module CssAble

  # Function to ensure root variable name begins with --
  def rootVariableName(name)
    if !name.start_with?("--")
      name = "--" + name
    end
    return name
  end
end
