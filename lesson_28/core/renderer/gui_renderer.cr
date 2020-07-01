require "lib_gl"
require "../shaders/program.cr"

class GuiRenderer

  property settings : Settings
  property shader   : GuiShader
  property model    : Model

  def initialize(settings : Settings)
    @settings = settings
    @shader   = GuiShader.new

    #
    # using a triangle strip to create the positions of the 2 triangles
    #
    positions = [-1f32, 1f32, -1f32, -1f32, 1f32, 1f32, 1f32, -1f32]
    @model = Model.load(positions,2)
  end

  def render(guis : Array(GuiTexture))
    @model.bind()

    #
    # enable blending
    #
    LibGL.enable(LibGL::BLEND)
    LibGL.blend_func(LibGL::SRC_ALPHA,LibGL::ONE_MINUS_SRC_ALPHA)
    #
    # render the quad model with the gui
    #
    guis.each do |gui|

      LibGL.active_texture(LibGL::TEXTURE0)
      LibGL.bind_texture(LibGL::TEXTURE_2D, gui.id)

      prepare_instance(gui)

      LibGL.draw_arrays(LibGL::TRIANGLE_STRIP, 0, @model.nr_vertices)
    end

    @model.unbind()

    #
    # disable blending
    #
    LibGL.disable(LibGL::BLEND)

  end

  def create_model_matrix(position : GLM::Vector2, scale : GLM::Vector2) : GLM::Matrix

    position3 = GLM::Vector3.new(position.x,position.y,0f32)
    trans     = GLM.translate(position3)

    scale3    = GLM::Vector3.new(scale.x,scale.y,1f32)
    scale     = GLM.scale(scale3)

    r = trans * scale
    return r
  end

  #
  # load model matrix
  #
  def prepare_instance(gui : GuiTexture)

    position     = gui.position
    scale        = gui.scale
    model_matrix = create_model_matrix(position,scale)

    @shader.load_transformation(model_matrix)
  end

  def cleanup()
    @shader.cleanup()
  end

end

