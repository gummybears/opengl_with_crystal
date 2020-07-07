require "lib_gl"
require "crystglfw"
require "./core/**"
include CrystGLFW

CrystGLFW.run do
  gpucompute = GpuCompute.new("Ray marching, basic algorithm",1920,1080)
  gpucompute.run()
end
