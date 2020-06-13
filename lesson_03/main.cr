require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./display.cr"

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

def lesson_03(title : String = "OpenGL lesson 3, introduce class Display and struct Color", width : Int32 = 800, height : Int32 = 600)

  CrystGLFW.run do

    bg = Color.new(0.2,0.3,0.3,1.0)
    display = Display.new(title, width, height, bg)

    # data
    vertices, indices = twotriangles()
    display.render(vertices,indices)
  end

end

lesson_03()
