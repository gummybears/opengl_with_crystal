require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./core/**"
require "./models/cube.cr"
require "./settings.cr"

def lesson(settings : Settings)

  entities       = [] of Entity

  # shader and texture file
  vertexshader   = "shaders/uniform.vs"
  fragmentshader = "shaders/uniform.fs"
  texture_file   = "res/white.png"

  positions = [] of GLM::Vec3
  rotations = [] of GLM::Vec3
  scales    = [] of GLM::Vec3

  positions << GLM::Vec3.new(0, 0, -30)
  rotations << GLM::Vec3.new(0,0,0)
  scales    << GLM::Vec3.new(0, 0, 0)

  CrystGLFW.run do

    display = Display.new(settings.title, settings.width, settings.height, settings.fov, settings.near, settings.far, settings.bg)

    # model from OBJ file
    model = ObjModel.load("models/dragon.obj")
    # with a texture
    obj_model = TextureModel.new(model,texture_file)

    positions.each_with_index do |pos,i|
      entities << Entity.new(obj_model,pos,rotations[i],scales[i])
    end

    camera        = Camera.new(settings.camera)
    shaderprogram = ShaderProgram.new(vertexshader,fragmentshader)
    display.render(entities,shaderprogram,camera)
  end
end

bg = Color.new(0.2,0.3,0.3,1.0)
settings = Settings.new("OpenGL lesson 8, loading from OBJ files, file models/dragon.obj", 1920, 1080, 90, 0.1, 100, GLM::Vec3.new(0,0,1), bg)
lesson(settings)
