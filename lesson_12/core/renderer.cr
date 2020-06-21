require "lib_gl"
#require "crystglfw"
require "./shader/program.cr"

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
  end

  def render()

  end

  def prepare_texture_model(model : TextureModel)

  end

  def unbind_texture_model()

  end

  def prepare_instance(entity : Entity)

  end
end

