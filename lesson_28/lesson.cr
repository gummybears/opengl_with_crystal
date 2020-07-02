require "crystglfw"
include CrystGLFW
require "./core/**"

def lesson(filename : String)

  CrystGLFW.run do

    game = Game.new(filename)
    game.setup()
    game.render()

  end

end

x = ARGV
if x.size != 1
  puts "usage: lesson config_file.yml"
  exit
end

filename = x[0]
filenotfound(filename)
lesson(filename)
