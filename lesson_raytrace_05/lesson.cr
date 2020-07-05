require "lib_gl"
require "crystglfw"
require "./core/**"
include CrystGLFW

def lesson(filename : String)

  config = Config.new(filename)

  CrystGLFW.run do
    gpu_shader = GpuShader.new(config)
    gpu_shader.run()
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
