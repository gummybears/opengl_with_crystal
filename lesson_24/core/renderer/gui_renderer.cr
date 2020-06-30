require "lib_gl"
require "../shaders/program.cr"

class GuiRenderer

  property settings : Settings
  property shader   : GuiShader
  property model    : Model

  #def initialize(shader : StaticShader, settings : Settings)
  def initialize(settings : Settings)
    @settings = settings
    @shader   = GuiShader.new

    #
    # using a triangle strip to create the positions of the 2 triangles
    #
    positions  = [-1f32, 1f32, -1f32, -1f32, 1f32, 1f32, 1f32, -1f32]
    @model = Model.load(positions)

  end

  def render(guis : Array(GuiTexture))
    @model.bind()

    #
    # render quad model
    #
    guis.each do |gui|
      LibGL.active_texture(LibGL::TEXTURE0)
      LibGL.bind_texture(LibGL::TEXTURE_2D, gui.id)

      LibGL.draw_arrays(LibGL::TRIANGLE_STRIP, 0, @model.nr_vertices)
    end

    @model.unbind()
  end

  def cleanup()
    @shader.cleanup()
  end

end

