require "json"
require "base64"
require "clipboard"

class Config
  attr_reader :values, :name

  def initialize(name)
    # Example layout of data
    # @rootValues = [{ name: "--color-red", value: "color: red" }]
    # @classValues = [{ name: ".class", values: ["background: red", "color: green"] }]
    # Wrap it all up into a hash?
    # @values = {root: [], class: []}

    @name = name
  end

  def load(display, data = nil)
    fromShareCode = !data.nil?
    if fromShareCode
      decoded = Base64.decode64(data)
      parts = decoded.split("-", 2)
      @name = parts[0]
      if configExists(@name)
        display.popup("You already have a config with the name \"#{@name}\"!\nPlease delete it to be able to import this Config!")
        return false
      end
      data = parts[1]
      save()
    else
      data = readConfig(name)
    end
    rootValues = []
    classValues = []

    # false == error occurred when reading
    if data == false
      return false
    end

    begin
      json = JSON.parse(data, { :symbolize_names => true })
    rescue => exception
      display.popup("Failed to import that Config!\nPlease ensure the Share Code is correct!") if fromShareCode
      return false
    end

    if (!json[:rootValues].nil? && json[:rootValues].length > 0)
      json[:rootValues].each { |item|
        rootValues << { name: item[:name], value: item[:value] }
      }
    end

    if (!json[:classValues].nil? && json[:classValues].length > 0)
      json[:classValues].each { |item|
        classValues << { name: item[:name], values: item[:values] }
      }
    end

    @values = { rootValues: rootValues, classValues: classValues }

    return true
  end

  def save
    saveConfig(@name, @values)
  end

  def addRootValue(hash)
    @values[:rootValues] << hash
  end

  def addClassValues(hash)
    @values[:classValues] << hash
  end

  def getClassNames
    return @values[:classValues].collect { |item| item[:name] }
  end

  def getRootNames
    return @values[:rootValues].collect { |item| item[:name] }
  end

  def removeRootVariable(name)
    @values[:rootValues].delete_at(@values[:rootValues].index(@values[:rootValues].find { |item| item[:name].downcase == name.downcase }))
  end

  def removeClassVariable(name)
    @values[:classValues].find { |item| item[:name].downcase == name.downcase }[:values] = []
  end

  def hasClassValues(name)
    return !@values[:classValues].find { |item| item[:name].downcase == name.downcase }.nil?
  end

  def getClassVariable(name)
    return @values[:classValues].find { |item| item[:name].downcase == name.downcase }
  end

  def getShareCode
    shareCode = Base64.encode64("#{@name}-#{JSON.generate(@values)}")
    shareCode = shareCode.tr("\n", "")
    Clipboard.copy(shareCode) if isWindows()
    return shareCode
  end

  def networkHandler(message, client)
    client.send("[E]console.log('Connected to Ruby Web Editor!');")

    rootSetFunction = "var r = document.querySelector(':root');"
    @values[:rootValues].each { |rootValue|
      rootSetFunction += "r.style.setProperty('#{rootValue[:name]}', '#{rootValue[:value]}');"
    }
    client.send("[E]#{rootSetFunction}")

    styleSetFunction = "function changeStyle(e,t){for(s in document.styleSheets){var r=document.styleSheets[s].cssRules;for(x in r)if(r[x].selectorText==e){for(cssprop in t)r[x].style[cssprop]=t[cssprop];return!0}}return!1};"
    @values[:classValues].each { |item|
      styleSetFunction += "changeStyle('#{item[:name]}', {#{cssify(item[:values])}});"
    }
    client.send("[E]#{styleSetFunction}")

    client.send("[E]console.log('Completed Config Application!');")

  end

  def cssify(array)
    combined = ""
    array.each_with_index { |line, index|
      parts = line.split(": ", 2)
      combined += "'#{parts[0]}': '#{parts[1] || "/* No Value */"}'"
      combined += ", " if array.length - 1 > index
    }

    return combined;
  end
end
