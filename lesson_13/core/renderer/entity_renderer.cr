require "lib_gl"
require "../shader/program.cr"

class EntityRenderer

  #property bg           : Color
  property shader       : StaticShader

  def initialize(shader : StaticShader, projection : GLM::Mat4, settings : Settings)

    @shader = shader
    #@bg     = settings.bg

    # moved # cull all faces which are invisible for the camera
    # moved LibGL.enable(LibGL::CULL_FACE)
    # moved LibGL.cull_face(LibGL::BACK)

    #projection = create_projection(settings.fov,settings.aspect_ratio,settings.near,settings.far)
    @shader.load_projection(projection)

  end

  # moved def create_projection(fov : Float32, aspect_ratio : Float32, near : Float32, far : Float32)
  # moved   GLM.perspective(fov,aspect_ratio,near, far)
  # moved end

  # moved def prepare()
  # moved   LibGL.enable(LibGL::DEPTH_TEST)
  # moved   LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
  # moved   LibGL.clear_color(@bg.red, @bg.green, @bg.blue, @bg.opacity)
  # moved end

  #
  # render entities
  #
  def render(entities : Hash(Model,Array(Entity)) )

    entities.each do |key, value|

      model = key
      prepare_texture_model(model)

      # value is a list of entities
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

    @shader.set_uniform_float("shine_damper",model.shine_damper)
    @shader.set_uniform_float("reflectivity",model.reflectivity)

  end

  def unbind_texture_model(model : Model)
    model.unbind()

  end

  def prepare_instance(entity : Entity)

    #
    # load model matrix
    #
    @shader.load_transformation(entity.model_matrix)
  end
end

