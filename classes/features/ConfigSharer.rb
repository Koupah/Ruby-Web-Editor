require_relative "css/Config"
require "strings"
class ConfigSharer
  def ConfigSharer.start(display)
    while true
      case display.getSelectionInput("What would you like to do?", [{ text: "Import a Config", value: 1 }, { text: "Share/Export a Config", value: 2 }, { text: "Return", value: 9 }])
      when 1
        ConfigSharer.import(display)
      when 2
        ConfigSharer.export(display)
      when 9
        break
      end
    end
  end

  def ConfigSharer.shareCodeValidate(input)
    toReturn = { message: "", passed: true }
    if input.length < 4
      toReturn[:message] = "That Share Code is too short!"
      toReturn[:passed] = false
    end
    return toReturn
  end

  def ConfigSharer.import(display)
    input = display.getStringInput("Please type in the Share Code\nAlternatively you can type \"return\" to return", self.method(:shareCodeValidate)).tr("\n","")
    return if input.downcase == "return"
    
    imported = Config.new("placeholder")
    if !imported.load(display, input)
      return;
    else
      display.popup("Success!\n\"#{imported.name}\" has been imported!")
    end
    return
  end

  def ConfigSharer.export(display)
    configs = getAllConfigs()
    configs << "Return (None)"

    name = display.getScrollableSelectionInput("Which config would you like to export?", configs)
    return if name.downcase == "return (none)"

    config = Config.new(name)
    config.load(display)
    shareCode = config.getShareCode()

    writeSharecode(shareCode)
    if !isWindows()
      display.popup("Successfully exported \"#{name}\"\n\nPlease check the \"configs\" folder:\nInside it there is a \"Latest-Share-Code.txt\" file\nInside this file is the Share Code!")
    else
      display.popup("Successfully exported \"#{name}\"\n\nThe Share Code should be copied to your clipboard\nIf it isn't, check the \"configs\" folder\nIt will be inside \"Latest-Share-Code.txt\"!")
    end

   
    return
  end
end
