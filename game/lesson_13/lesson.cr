require "yaml"
require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./core/**"

def lesson(configfile : String)

  entities  = [] of Entity

  scene = Scene.new(configfile)
  settings = scene.settings()

  light  = Light.new(scene.light_position(),scene.light_color())
  camera = Camera.new(settings.camera)

  vertexshader   = scene.model_vertex_shader("dragon")
  fragmentshader = scene.model_fragment_shader("dragon")

  dragon_data    = ModelData.from_obj(scene.model_object("dragon"))
  player_data    = ModelData.from_obj(scene.model_object("player"))

  CrystGLFW.run do

    display = Display.new(settings)

    dragon_model = TextureModel.new(Model.load(dragon_data),scene.model_texture("dragon"))
    player_model = TextureModel.new(Model.load(player_data),scene.model_texture("player"))

    dragon_model.shine_damper = scene.model_shine("dragon")
    dragon_model.reflectivity = scene.model_reflectivity("dragon")

    player_model.shine_damper = scene.model_shine("player")
    player_model.reflectivity = scene.model_reflectivity("player")


    dragon = Entity.new(dragon_model,scene.model_position("dragon"),scene.model_rotation("dragon"),scene.model_scale("dragon"))
    player = Player.new(player_model,scene.model_position("player"),scene.model_rotation("player"),scene.model_scale("player"))

    entities << dragon
    entities << player

    display.render(entities,camera,light)
  end

end

x = ARGV
if x.size != 1
  puts "usage: lesson config_file.yml"
  exit
end

filename = x[0]
filenotfound(filename)
lesson(filename)
