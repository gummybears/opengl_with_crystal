require "yaml"
require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./core/**"
require "./settings.cr"

#def load_config(configfile)
#  filenotfound(configfile)
#
#  x = YAML.parse(File.read(configfile))
#  title    = x["display"]["screen"]["title"].to_s
#  width    = x["display"]["screen"]["width"].as_f.to_f32
#  height   = x["display"]["screen"]["height"].as_f.to_f32
#  fov      = x["display"]["screen"]["fov"].as_f.to_f32
#  near     = x["display"]["screen"]["near"].as_f.to_f32
#  far      = x["display"]["screen"]["far"].as_f.to_f32
#
#  bgred    = x["display"]["background"]["color"]["r"].as_f.to_f32
#  bgblue   = x["display"]["background"]["color"]["b"].as_f.to_f32
#  bggreen  = x["display"]["background"]["color"]["g"].as_f.to_f32
#  opacity  = x["display"]["background"]["color"]["a"].as_f.to_f32
#  camerax  = x["camera"]["x"].as_f.to_f32
#  cameray  = x["camera"]["y"].as_f.to_f32
#  cameraz  = x["camera"]["z"].as_f.to_f32
#  camera = GLM::Vec3.new(camerax,cameray,cameraz)
#  bg = Color.new(bgred,bgblue,bggreen,opacity)
#
#  settings = Settings.new(title, width, height, fov, near, far, camera, bg)
#
#  lesson_12(settings)
#
#end


def load_settings(configfile)
  filenotfound(configfile)

  x = YAML.parse(File.read(configfile))
  title    = x["display"]["screen"]["title"].to_s
  width    = x["display"]["screen"]["width"].as_f.to_f32
  height   = x["display"]["screen"]["height"].as_f.to_f32
  fov      = x["display"]["screen"]["fov"].as_f.to_f32
  near     = x["display"]["screen"]["near"].as_f.to_f32
  far      = x["display"]["screen"]["far"].as_f.to_f32

  bgred    = x["display"]["background"]["color"]["r"].as_f.to_f32
  bgblue   = x["display"]["background"]["color"]["b"].as_f.to_f32
  bggreen  = x["display"]["background"]["color"]["g"].as_f.to_f32
  opacity  = x["display"]["background"]["color"]["a"].as_f.to_f32
  camerax  = x["camera"]["x"].as_f.to_f32
  cameray  = x["camera"]["y"].as_f.to_f32
  cameraz  = x["camera"]["z"].as_f.to_f32
  camera = GLM::Vec3.new(camerax,cameray,cameraz)
  bg = Color.new(bgred,bgblue,bggreen,opacity)

  settings = Settings.new(title, width, height, fov, near, far, camera, bg)
  return settings
end

def load_models(configfile) : Array(ModelData)
  filenotfound(configfile)

  x = YAML.parse(File.read(configfile))

end

def lesson_12(configfile : String)


  settings = load_settings(configfile)

  entities  = [] of Entity
  models    = [] of Model
  positions = [] of GLM::Vec3
  rotations = [] of GLM::Vec3
  scales    = [] of GLM::Vec3

  # shader and texture file
  vertexshader   = "shaders/uniform.vs"
  fragmentshader = "shaders/uniform.fs"

  positions << GLM::Vec3.new(0, 0, -25)
  rotations << GLM::Vec3.new(0,0,0)
  scales    << GLM::Vec3.new(0, 0, 0)

  positions << GLM::Vec3.new(0, 0, -5)
  rotations << GLM::Vec3.new(0,0,0)
  scales    << GLM::Vec3.new(0, 0, 0)

  #
  # create a light source
  #
  light        = Light.new(GLM::Vec3.new(3,0,-20),GLM::Vec3.new(1,1,1));
  camera       = Camera.new(settings.camera)
  object_data  = ModelData.from_obj("res/dragon.obj")
  terrain_data = ModelData.terrain(0,0,16,32)
  player_data  = ModelData.from_obj("res/bunny.obj")

  CrystGLFW.run do

    display = Display.new(settings)

    dragon_model = TextureModel.new(Model.load(ModelType::OBJ,object_data),"res/purple.png")
    dragon_model.shine_damper = 10.0f32
    dragon_model.reflectivity = 1.0f32
    models << dragon_model

    entities << Entity.new(dragon_model,positions[0],rotations[0],scales[0])

    #terrain_model = TextureModel.new(Model.load(ModelType::TERRAIN,terrain_data),"res/grass.png")
    #models << terrain_model
    #entities << Entity.new(terrain_model,positions[1],rotations[1],scales[1])

    player_model = TextureModel.new(Model.load(ModelType::PLAYER,player_data),"res/white.png")
    player      = Player.new(player_model,GLM::Vec3.new(10f32,0f32,-20f32), GLM::Vec3.new(0,0,0),GLM::Vec3.new(0,0,0))
    entities << player

    #(0..models.size() - 1).each do |i|
    #  entities << Entity.new(models[i],positions[i],rotations[i],scales[i])
    #end

    program = Program.new(vertexshader,fragmentshader)
    display.render(entities,program,camera,light)
  end

end

lesson_12("scene.yml")
