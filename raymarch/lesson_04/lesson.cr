require "lib_gl"
require "crystglfw"
require "./core/**"
include CrystGLFW

def lesson(filename : String)

  config = Config.new(filename)

  CrystGLFW.run do
    gpucompute = GpuCompute.new(config)
    gpucompute.run()
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
