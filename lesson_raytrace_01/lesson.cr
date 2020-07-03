require "lib_gl"
require "crystglfw"
require "./core/**"
include CrystGLFW

CrystGLFW.run do
  gpucompute = GpuCompute.new("Ray tracing with SDF fields",1920,1080)
  #gpucompute = GpuCompute.new("Ray tracing with SDF fields",800,600)
  gpucompute.run()
end
