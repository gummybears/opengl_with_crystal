require "yaml"
require "lib_gl"
require "crystglfw"
include CrystGLFW
require "./core/**"

def lesson_terrain(configfile : String)

  entities     = [] of Entity
  terrains     = [] of Terrain
  scene        = Scene.new(configfile)
  settings     = scene.settings()

  light  = Light.new(scene.light_position(),scene.light_color())
  camera = Camera.new(settings.camera)

  CrystGLFW.run do

    display = Display.new(settings)

    terrain1 = Terrain.new(0f32,0f32,scene.vertex_count("terrain"),scene.size("terrain"),scene.model_texture("terrain"))
    terrain2 = Terrain.new(0f32,0.8f32,scene.vertex_count("terrain"),scene.size("terrain"),scene.model_texture("terrain"))
    terrain3 = Terrain.new(-0.8f32,0f32,scene.vertex_count("terrain"),scene.size("terrain"),scene.model_texture("terrain"))
    terrain4 = Terrain.new(-0.8f32,0.8f32,scene.vertex_count("terrain"),scene.size("terrain"),scene.model_texture("terrain"))

    terrains << terrain1
    terrains << terrain2
    terrains << terrain3
    terrains << terrain4

    display.render(entities,terrains,camera,light)
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
