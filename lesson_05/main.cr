require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./display.cr"
require "./model.cr"
require "./texture.cr"

def twotriangles() : {Array(Float32), Array(Int32), Array(Float32)}

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


  texture_coords = [
            1.0, 1.0, # top right
            1.0, 0.0, # bottom right
            0.0, 0.0, # bottom let
            0.0, 1.0  # top let
          ]

  vertex_arr = [] of Float32
  vertices.each do |v|
    vertex_arr << v.to_f32
  end

  index_arr = [] of Int32
  indices.each do |v|
    index_arr << v.to_i32
  end

  texture_arr = [] of Float32
  texture_coords.each do |v|
    texture_arr << v.to_f32
  end

  return vertex_arr, index_arr, texture_arr
end

def lesson_05(title : String = "OpenGL lesson 5, Textures", width : Int32 = 800, height : Int32 = 600)

  vertexshader   = "shaders/texture_shader.vs"
  fragmentshader = "shaders/texture_shader.fs"
  texture_file   = "res/bricks.png"

  vertices, indices, textures = twotriangles()
  bg = Color.new(0.2,0.3,0.3,1.0)

  CrystGLFW.run do

    display    = Display.new(title, width, height, bg)
    model      = Model.load(vertices,indices,textures)
    texture_id = Texture.load(texture_file)
    display.render(model,vertexshader,fragmentshader,texture_id)
  end
end

lesson_05()
