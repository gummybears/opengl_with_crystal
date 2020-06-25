require "yaml"
require "random"

require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./core/**"

def get_random_pos() : GLM::Vec3

  rand = Random.rand(400).to_f32

  # random x position
  x = rand  - 200f32
  y = 0.0f32

  # random z position
  rand = Random.rand(400).to_f32
  z = -rand - 200f32 #/4.0f32

  position = GLM::Vec3.new(x,y,z)
  return position
end

def lesson(configfile : String)

  entities  = [] of Entity
  terrains  = [] of Terrain
  scene     = Scene.new(configfile)
  settings  = scene.settings()

  light      = Light.new(scene.light_position(),scene.light_color())
  camera     = Camera.new(settings.camera)

  tree_data  = ModelData.from_obj(scene.model_object("tree"))
  other_tree_data  = ModelData.from_obj(scene.model_object("other_tree"))
  fern_data  = ModelData.from_obj(scene.model_object("fern"))
  grass_data = ModelData.from_obj(scene.model_object("grass"))

  CrystGLFW.run do

    display = Display.new(settings)

    tree_model  = TextureModel.new(Model.load(tree_data),scene.model_texture("tree"))
    other_tree_model  = TextureModel.new(Model.load(other_tree_data),scene.model_texture("other_tree"))
    fern_model  = TextureModel.new(Model.load(fern_data),scene.model_texture("fern"))
    grass_model = TextureModel.new(Model.load(grass_data),scene.model_texture("grass"))

    tree_model.shine_damper  = scene.model_shine("tree")
    tree_model.reflectivity  = scene.model_reflectivity("tree")
    tree_model.has_transparency  = false
    tree_model.use_fake_lighting = false
    tree_model.name = "tree"

    fern_model.shine_damper  = scene.model_shine("fern")
    fern_model.reflectivity  = scene.model_reflectivity("fern")
    fern_model.has_transparency  = false
    fern_model.use_fake_lighting = false
    fern_model.name = "fern"

    grass_model.shine_damper = scene.model_shine("grass")
    grass_model.reflectivity = scene.model_reflectivity("grass")
    grass_model.has_transparency  = true
    grass_model.use_fake_lighting = true
    grass_model.name = "grass"

    other_tree_model.shine_damper  = scene.model_shine("other_tree")
    other_tree_model.reflectivity  = scene.model_reflectivity("other_tree")
    other_tree_model.has_transparency  = false
    other_tree_model.use_fake_lighting = false
    other_tree_model.name = "other_tree"

    1.upto(200) do |i|

      position = get_random_pos()
      tree  = Entity.new(tree_model,position,scene.model_rotation("tree"),scene.model_scale("tree"))

      position = get_random_pos()
      fern  = Entity.new(fern_model,position,scene.model_rotation("fern"),scene.model_scale("fern"))

      position = get_random_pos()
      grass = Entity.new(grass_model,position,scene.model_rotation("grass"),scene.model_scale("grass"))

      position = get_random_pos()
      other_tree = Entity.new(grass_model,position,scene.model_rotation("other_tree"),scene.model_scale("other_tree"))

      entities << tree
      entities << fern
      entities << grass
      entities << other_tree
    end

    res1 = scene.model_texture("grassy")
    background_texture = TerrainTexture.new(ModelTexture.load(res1))

    res2 = scene.model_texture("dirt")
    r_texture = TerrainTexture.new(ModelTexture.load(res2))

    res3 = scene.model_texture("pink_flowers")
    g_texture = TerrainTexture.new(ModelTexture.load(res3))

    res4 = scene.model_texture("path")
    b_texture = TerrainTexture.new(ModelTexture.load(res4))

    texture_pack = TerrainTexturePack.new(background_texture,r_texture, g_texture, b_texture)

    res5 = scene.model_texture("blend_map")
    blend_map = TerrainTexture.new(ModelTexture.load(res5))

    vertex_count = scene.vertex_count("terrain")
    terrain_size = scene.size("terrain")

    terrain1 = Terrain.new(0f32,0f32,      vertex_count,terrain_size, texture_pack, blend_map)
    terrain2 = Terrain.new(0f32,0.8f32,    vertex_count,terrain_size, texture_pack, blend_map)
    terrain3 = Terrain.new(-0.8f32,0f32,   vertex_count,terrain_size, texture_pack, blend_map)
    terrain4 = Terrain.new(-0.8f32,0.8f32, vertex_count,terrain_size, texture_pack, blend_map)
    terrains << terrain1
    terrains << terrain2
    terrains << terrain3
    terrains << terrain4

    display.render(entities,terrains,camera,light)
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
