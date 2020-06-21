require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./core/**"
require "./settings.cr"

def lesson_12(settings : Settings)

  entities       = [] of Entity

  # shader and texture file
  vertexshader   = "shaders/uniform.vs"
  fragmentshader = "shaders/uniform.fs"

  positions = [] of GLM::Vec3
  rotations = [] of GLM::Vec3
  scales    = [] of GLM::Vec3

  positions << GLM::Vec3.new(0, 0, -25)
  rotations << GLM::Vec3.new(0,0,0)
  scales    << GLM::Vec3.new(0, 0, 0)

  positions << GLM::Vec3.new(0, 0, -5)
  rotations << GLM::Vec3.new(0,0,0)
  scales    << GLM::Vec3.new(0, 0, 0)

  models = [] of Model

  #
  # create a light source
  #
  light = Light.new(GLM::Vec3.new(3,0,-20),GLM::Vec3.new(1,1,1));

  CrystGLFW.run do

    display = Display.new(settings.title, settings.width, settings.height, settings.fov, settings.near, settings.far, settings.bg)

    # model from OBJ file
    model     = ObjModel.load("models/bunny.obj")
    texture_file = "res/purple.png"
    dragon_model = TextureModel.new(model,texture_file)
    dragon_model.shine_damper = 10.0f32
    dragon_model.reflectivity = 1.0f32
    models << dragon_model

    model = TerrainModel.load(0,0) #,texture_file)
    texture_file = "res/grass.png"
    terrain_model = TextureModel.new(model,texture_file)
    models << terrain_model

    (0..models.size() - 1).each do |i|
      entities << Entity.new(models[i],positions[i],rotations[i],scales[i])
    end

    #positions.each_with_index do |pos,i|
    #  entities << Entity.new(obj_model,pos,rotations[i],scales[i])
    #end

    camera        = Camera.new(settings.camera)
    shaderprogram = ShaderProgram.new(vertexshader,fragmentshader)
    display.render(entities,shaderprogram,camera,light)
  end
end

bg = Color.new(0.5,0.5,0.5,1.0)
settings = Settings.new("OpenGL lesson 12, simple terrain", 1920, 1080, 90, 0.1, 100, GLM::Vec3.new(0,0,1), bg)
lesson_12(settings)
