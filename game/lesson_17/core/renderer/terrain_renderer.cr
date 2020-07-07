require "lib_gl"
require "../shaders/program.cr"

class TerrainRenderer

  property settings : Settings
  property shader   : TerrainShader

  def initialize(shader : TerrainShader, projection : GLM::Mat4, settings : Settings)
    @settings = settings
    @shader   = shader

    @shader.load_projection(projection)

    # connect all the texture units
    @shader.connect_texture_units()
  end

  #
  # render entities
  #
  def render(terrains : Array(Terrain))

    terrains.each do |terrain|

      prepare_terrain(terrain)
      load_model_matrix(terrain)
      LibGL.draw_elements(LibGL::TRIANGLES, terrain.model.nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))
      unbind_texture_model(terrain.model)

    end # each

  end

  def prepare_terrain(terrain : Terrain)

    model = terrain.model
    model.bind()

    bind_textures(terrain)

    @shader.set_uniform_float("shine_damper",10.0)
    @shader.set_uniform_float("reflectivity",1.0)
    @shader.set_uniform_float("density",@settings.fog_density)
    @shader.set_uniform_float("gradient",@settings.fog_gradient)

  end

  def unbind_texture_model(model : Model)
    model.unbind()
  end

  def bind_textures(terrain : Terrain)
    texture_pack = terrain.texture_pack

    LibGL.active_texture(LibGL::TEXTURE0)
    LibGL.bind_texture(LibGL::TEXTURE_2D, texture_pack.background_texture.id)

    LibGL.active_texture(LibGL::TEXTURE1)
    LibGL.bind_texture(LibGL::TEXTURE_2D, texture_pack.r_texture.id)

    LibGL.active_texture(LibGL::TEXTURE2)
    LibGL.bind_texture(LibGL::TEXTURE_2D, texture_pack.g_texture.id)

    LibGL.active_texture(LibGL::TEXTURE3)
    LibGL.bind_texture(LibGL::TEXTURE_2D, texture_pack.b_texture.id)

    LibGL.active_texture(LibGL::TEXTURE4)
    LibGL.bind_texture(LibGL::TEXTURE_2D, terrain.blend_map.id)
  end

  #
  # load model matrix
  #
  def load_model_matrix(terrain : Terrain)

    position = GLM::Vec3.new(terrain.x,0,terrain.z)
    rot      = GLM::Vec3.new(0,0,0)
    scale    = GLM::Vec3.new(0,0,0)

    model_trans  = GLM.translate(position)
    model_rotate = GLM.rotation(rot)
    model_scale  = GLM.scale(scale)

    model_matrix = model_trans * model_rotate * model_scale
    @shader.load_transformation(model_matrix)
  end
end

