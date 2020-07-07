require "lib_gl"
require "crystglfw"
require "./core/**"
include CrystGLFW

CrystGLFW.run do
  gpucompute = GpuCompute.new("Ray marching, simple shapes",1920,1080,"rayshader.vs","rayshader.fs")
  gpucompute.run()
end
