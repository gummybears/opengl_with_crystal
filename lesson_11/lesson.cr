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
  texture_file   = "res/purple.png"

  positions = [] of GLM::Vec3
  rotations = [] of GLM::Vec3
  scales    = [] of GLM::Vec3

  positions << GLM::Vec3.new(0, 0, -25)
  rotations << GLM::Vec3.new(0,0,0)
  scales    << GLM::Vec3.new(0, 0, 0)

  CrystGLFW.run do

    display = Display.new(settings.title, settings.width, settings.height, settings.fov, settings.near, settings.far, settings.bg)

    # model from OBJ file
    model     = ObjModel.load("models/dragon.obj")
    obj_model = TextureModel.new(model,texture_file)
    obj_model.shine_damper = 10.0f32
    obj_model.reflectivity = 1.0f32

    # create a light source
    light = Light.new(GLM::Vec3.new(0,0,-20),GLM::Vec3.new(1,1,1));

    positions.each_with_index do |pos,i|
      entities << Entity.new(obj_model,pos,rotations[i],scales[i])
    end

    camera        = Camera.new(settings.camera)
    shaderprogram = ShaderProgram.new(vertexshader,fragmentshader)
    display.render(entities,shaderprogram,camera,light)
  end
end

bg = Color.new(0.5,0.5,0.5,1.0)
settings = Settings.new("OpenGL lesson 11, per pixel lighting (ambient lighting)", 1920, 1080, 90, 0.1, 100, GLM::Vec3.new(0,0,1), bg)
lesson(settings)
