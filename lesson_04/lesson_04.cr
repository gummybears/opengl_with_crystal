require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./display.cr"
require "./model.cr"

def twotriangles() : {Array(Float32), Array(Int32)}

  vertices = [
               0.5,  0.5,  0.0,
               0.5, -0.5,  0.0,
              -0.5, -0.5,  0.0,
              -0.5,  0.5,  0.0
            ]

  indices = [
              0,1,3, # first triangle
              1,2,3  # second triangle
            ]

  vertex_arr = [] of Float32
  vertices.each do |v|
    vertex_arr << v.to_f32
  end

  index_arr = [] of Int32
  indices.each do |v|
    index_arr << v.to_i32
  end

  return vertex_arr, index_arr
end

def lesson_04(title : String = "OpenGL lesson 4, introduce class Model", width : Int32 = 800, height : Int32 = 600)

  vertices, indices = twotriangles()
  bg = Color.new(0.2,0.3,0.3,1.0)

  CrystGLFW.run do
    display = Display.new(title, width, height, bg)
    model   = Model.load(vertices,indices)
    display.render(model)
  end
end

lesson_04()
