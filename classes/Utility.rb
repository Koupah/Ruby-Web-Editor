require "artii"
require "tty-box"
require "strings"

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

def makeBox(content, width, height, title = nil)
  box = TTY::Box.frame(width: width, height: height, title: { top: title }) { content }
end

def argsContain(query)
  case query
  when Array
    ARGV.each { |arg|
      return true if query.include? arg
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
  
  return toReturn;
end