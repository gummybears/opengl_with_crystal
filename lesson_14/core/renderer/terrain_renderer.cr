require "lib_gl"
require "../shader/program.cr"

class TerrainRenderer

  property shader : TerrainShader

  def initialize(shader : TerrainShader, projection : GLM::Mat4, settings : Settings)
    @shader = shader
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

    if model.class.to_s == "TextureModel"
      x = model.as(TextureModel)
      LibGL.bind_texture(LibGL::TEXTURE_2D, x.id)
    end

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

    trans  = GLM.translate(position)
    rotate = GLM.rotation(rot)
    scale  = GLM.scale(scale)

    model_matrix = trans * rotate * scale
    @shader.load_transformation(model_matrix)
  end
end

