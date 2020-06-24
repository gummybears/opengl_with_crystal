require "lib_gl"
require "../shader/program.cr"

class EntityRenderer

  property shader : StaticShader

  def initialize(shader : StaticShader, projection : GLM::Mat4, settings : Settings)
    @shader = shader
    @shader.load_projection(projection)
  end

  #
  # render entities
  #
  def render(entities : Hash(Model,Array(Entity)) )

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

  def prepare_texture_model(model : Model)
    model.bind()

    if model.class.to_s == "TextureModel"
      x = model.as(TextureModel)
      LibGL.bind_texture(LibGL::TEXTURE_2D, x.id)

    end

    if model.has_transparency
      MasterRenderer.disable_culling()
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

  end

  def unbind_texture_model(model : Model)
    model.unbind()
    # enable back face culling
    MasterRenderer.enable_culling()
  end

  def prepare_instance(entity : Entity)
    #
    # load model matrix
    #
    @shader.load_transformation(entity.model_matrix)
  end
end

