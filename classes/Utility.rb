require "artii"
require "tty-box"
require "fileutils"
require "rbconfig"
require_relative "display/Color"

def defaultBox(display, title)
  Color.set(display, :magenta, :bright)
  display.setBorder("|", "-", title)
  Color.set(display, :green, :bright)
end

def isWindows()
  return (RbConfig::CONFIG["host_os"] =~ /mswin|mingw|cygwin/)
end

def writeSharecode(shareCode)
  File.write("configs/Latest-Share-Code.txt", shareCode)
end

def generateArt(string, font = "big")
  a = Artii::Base.new :font => font
  a.asciify(string)
end

def getWidth(string)
  longest = 0
  string.split(/\n/).each { |line|
    if longest < line.length
      longest = line.length
    end
  }

  return longest
end

def getLines(string)
  return string.split(/\n/).length
end

def makeBox(content, width, height, title = nil)
  box = TTY::Box.frame(width: width, height: height, title: { top: title }) { content }
end

# Essentially just checking if any of the VARGS are in our query, could be done in reverse but :shrug:
def argsContain(query)
  case query
  when Array
    ARGV.each { |arg|
      return true if query.include? arg.downcase
    }
    return false
  else
    return ARGV.include? query
  end
  return false
end

def checkArguments
  toReturn = { debug: false, colors: true, animation: true, rgb: false, help: false }

  toReturn[:debug] = argsContain(["-debug", "-d", "--debug", "--d"])
  toReturn[:colors] = !argsContain(["-nocolor", "-nc", "--nocolors", "--nc", "--colorless", "-colorless"])
  toReturn[:animation] = !argsContain(["-noanimation", "-na", "--na", "--noanimation", "--quick", "-quick", "-q", "--q"])
  toReturn[:rgb] = argsContain(["-vomit", "-puke", "-rgb", "-rainbow", "--vomit", "--puke", "--rgb", "--rainbow", "-rnbw", "--rnbw"])
  toReturn[:help] = argsContain(["-help", "-h", "--help", "--h"])

  return toReturn
end

def makeConfigFolder
  FileUtils.mkdir_p "configs/"
end

def configExists(file)
  return File.exist?("configs/#{file}.rwecfg")
end

def deleteConfig(configName)
  begin
    result = File.delete("configs/#{configName}.rwecfg")
    return result
  rescue Exception => e
    return false
  end
  # This shouldn't run? but incase it does, the 'return result' mustn't have worked
  return false
end

def readConfig(name)
  begin
    return File.read("configs/#{name}.rwecfg")
  rescue => exception
    return false
  end
  # Same as comment in above function
  return false
end

def saveConfig(name, data)
  begin
    File.write("configs/#{name}.rwecfg", JSON.pretty_generate(data))
    return true
  rescue => exception
    return false
  end
  # Same as comment in above above function
  return false
end

def makeConfigFile(configName)
  begin
    File.write("configs/#{configName}.rwecfg", JSON.pretty_generate({ rootValues: "", classValues: "" }))
    return true
  rescue => exception
    return false
  end
  # Same as comment in above above function
  return false
end

def getAllConfigs(removeExtension = true)
  configs = Dir.entries("configs/").select { |file| file.downcase.end_with?(".rwecfg") }
  return configs.map { |file| file[0..(file.length - 8)] } unless !removeExtension
  return configs
end

def alphanumeric(string)
  chars = ("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a
  return string.chars.detect { |ch| !chars.include?(ch) }.nil?
end
