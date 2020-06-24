require "lib_gl"
require "../shader/program.cr"

class TerrainRenderer

  property settings : Settings
  property shader   : TerrainShader

  def initialize(shader : TerrainShader, projection : GLM::Mat4, settings : Settings)
    @settings = settings
    @shader   = shader

    @shader.load_projection(projection)
  end

  #
  # render entities
  #
  def render(terrains : Array(Terrain))

    terrains.each do |terrain|

      prepare_terrain(terrain)
      load_model_matrix(terrain)

      # final render
      LibGL.draw_elements(LibGL::TRIANGLES, terrain.model.nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))

      unbind_texture_model(terrain.model)
    end # each

  end

  def prepare_terrain(terrain : Terrain)

    #model = TextureModel.new(terrain.model_data,scene.model_texture("terrain"))

    model = terrain.model
    model.bind()

    LibGL.bind_texture(LibGL::TEXTURE_2D, model.id)
    @shader.set_uniform_float("shine_damper",model.shine_damper)
    @shader.set_uniform_float("reflectivity",model.reflectivity)

  end

  def unbind_texture_model(model : Model)
    model.unbind()

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

