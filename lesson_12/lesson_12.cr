require "yaml"
require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./core/**"

PROGRAM = "lesson_12"

def lesson_12(configfile : String)

  entities  = [] of Entity

  scene = Scene.new(configfile)
  settings = scene.settings()

  light  = Light.new(scene.light_position(),scene.light_color())
  camera = Camera.new(settings.camera)

  vertexshader   = scene.model_vertex_shader("dragon")
  fragmentshader = scene.model_fragment_shader("dragon")

  dragon_data    = ModelData.from_obj(scene.model_object("dragon"))
  player_data    = ModelData.from_obj(scene.model_object("player"))
  terrain_data   = ModelData.terrain(0,0,32,64)

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

    #terrain_model = TextureModel.new(Model.load(terrain_data),scene.model_texture("terrain"))
    #entities << Entity.new(terrain_model,scene.model_position("terrain"),scene.model_rotation("terrain"),scene.model_scale("terrain"))

    program = Program.new(vertexshader,fragmentshader)
    display.old_render(entities,program,camera,light)
  end

end

x = ARGV
if x.size != 1
  puts "usage: lesson_20 config_file.yml"
  exit
end

filename = x[0]
filenotfound(filename)
lesson_12(filename)
