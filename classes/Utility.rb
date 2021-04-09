require "artii"

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

  return longest;
end
