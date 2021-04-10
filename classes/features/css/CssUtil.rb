# Best name I could come up with LMAO
class CssUtil

  # Function to ensure root variable name begins with --
  def CssUtil.rootVariableName(name)
    if !name.start_with?("--")
      name = "--" + name
    end
    return name
  end

  # Function to ensure class name begins with .
  def CssUtil.classVariableName(name)
    if !name.start_with?(".")
        name = "." + name;
    end
    return name;
  end
end
