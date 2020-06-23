require "yaml"
require "lib_gl"
require "crystglfw"
include CrystGLFW
require "./core/**"


def lesson_terrain(configfile : String)

  entities  = [] of Entity

  scene = Scene.new(configfile)
  settings = scene.settings()

  light  = Light.new(scene.light_position(),scene.light_color())
  camera = Camera.new(settings.camera)
  puts "camera #{settings.camera.to_s}"

  vertexshader   = scene.model_vertex_shader("terrain")
  fragmentshader = scene.model_fragment_shader("terrain")

  vertex_count = 100
  size = 1920

  terrain_data1  = ModelData.terrain(0,0,vertex_count,size)

  CrystGLFW.run do

    display = Display.new(settings)

    terrain_model1 = TextureModel.new(Model.load(terrain_data1),scene.model_texture("terrain"))
    terrain_model1.shine_damper = scene.model_shine("terrain")
    terrain_model1.reflectivity = scene.model_reflectivity("terrain")

    entities << Entity.new(terrain_model1,GLM::Vec3.new(0,0,0),scene.model_rotation("terrain"),scene.model_scale("terrain"))
    entities << Entity.new(terrain_model1,GLM::Vec3.new(-1,0,0),scene.model_rotation("terrain"),scene.model_scale("terrain"))

    program = Program.new(vertexshader,fragmentshader)
    display.old_render(entities,program,camera,light)
  end

end

x = ARGV
if x.size != 1
  puts "usage: lesson_terrain config_file.yml"
  exit
end

filename = x[0]
filenotfound(filename)
lesson_terrain(filename)
