require "lib_gl"
require "../shader/program.cr"

class Renderer

  property fov          : Float32
  property near         : Float32
  property far          : Float32
  property aspect_ratio : Float32
  property bg           : Color

  property projection   : GLM::Mat4
  property shader       : Program

  def initialize(shader : Program, fov : Float32, aspect_ratio : Float32, near : Float32, far : Float32, bg : Color)

    # cull all faces which are invisible for the camera
    LibGL.enable(LibGL::CULL_FACE)
    LibGL.cull_face(LibGL::BACK)

    @shader       = shader

    @fov          = fov
    @near         = near
    @far          = far
    @bg           = bg
    @aspect_ratio = aspect_ratio
    @projection   = GLM.perspective(@fov,@aspect_ratio,@near, @far)
  end

  def prepare()
    LibGL.enable(LibGL::DEPTH_TEST)
    LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)

    # cull all faces which are invisible for the camera
    LibGL.enable(LibGL::CULL_FACE)
    LibGL.cull_face(LibGL::BACK)

    LibGL.clear_color(@bg.red, @bg.green, @bg.blue, @bg.opacity)

  end

  #def render(entities : Hash(TextureModel,Array(Entity)) )
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

  def prepare_texture_model(model : Model) #TextureModel)
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

    # model matrix
    @shader.set_uniform_matrix_4f("model", entity.model_matrix())

  end
end

