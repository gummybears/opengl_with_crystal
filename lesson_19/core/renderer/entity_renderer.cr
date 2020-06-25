require "lib_gl"
require "../shaders/program.cr"

class EntityRenderer

  property settings : Settings
  property shader : StaticShader

  def initialize(shader : StaticShader, projection : GLM::Mat4, settings : Settings)
    @settings = settings
    @shader   = shader
    @shader.load_projection_matrix(projection)
  end

  # enable/disable back face culling
  def enable_culling()
    LibGL.enable(LibGL::CULL_FACE)
    LibGL.cull_face(LibGL::BACK)
  end

  def disable_culling()
    LibGL.disable(LibGL::CULL_FACE)
  end

  #
  # render entities
  #
  def render(entities : Hash(TextureModel,Array(Entity)) )

    entities.each do |key, value|

      model = key
      prepare_texture_model(model)

      #
      # value is a list of entities
      #
      list = value
      list.each do |entity|
        prepare_instance(entity)

        # final render
        LibGL.draw_elements(LibGL::TRIANGLES, model.nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))

      end # each entity per model

      unbind_texture_model(model)
    end # each

  end

  def prepare_texture_model(model : TextureModel)

    model.bind()

    LibGL.active_texture(LibGL::TEXTURE0)
    LibGL.bind_texture(LibGL::TEXTURE_2D, model.id)

    if model.has_transparency
      disable_culling()
    end

    if model.use_fake_lighting
      fake_lighting = 1.0f32
      @shader.set_uniform_float("use_fake_lighting",fake_lighting)
    else
      fake_lighting = 0.0f32
      @shader.set_uniform_float("use_fake_lighting",fake_lighting)
    end

    @shader.set_uniform_float("shine_damper",model.shine_damper)
    @shader.set_uniform_float("reflectivity",model.reflectivity)
    @shader.set_uniform_float("density",@settings.fog_density)
    @shader.set_uniform_float("gradient",@settings.fog_gradient)

  end

  def unbind_texture_model(model : Model)
    model.unbind()
    # enable back face culling
    enable_culling()
  end

  def prepare_instance(entity : Entity)
    #
    # load model matrix
    #
    model_matrix = entity.create_model_matrix()
    @shader.load_transformation(model_matrix)
  end
end

