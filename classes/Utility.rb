require "artii"
require "tty-box"
require "strings"
require "fileutils"

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
  toReturn = { debug: false, colors: true, animation: true }

  toReturn[:debug] = argsContain(["-debug", "-d", "--debug", "--d"])
  toReturn[:colors] = !argsContain(["-nocolor", "-nc", "--nocolors", "--nc", "--colorless", "-colorless"])
  toReturn[:animation] = !argsContain(["-noanimation", "-na", "--na", "--noanimation", "--quick", "-quick", "-q", "--q"])

  return toReturn
end

def makeConfigFolder
  FileUtils.mkdir_p "configs/"
end

def configExists(file)
  return File.exist?("configs/#{file}.RWEcfg")
end

def makeConfigFile(configName)
  File.new("configs/#{configName}.RWEcfg", "w+")
end

def alphanumeric(string)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    return string.chars.detect {|ch| !chars.include?(ch)}.nil?
end
