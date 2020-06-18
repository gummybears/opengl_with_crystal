require "lib_gl"
require "crystglfw"
require "./shaderprogram.cr"
require "./color.cr"

include CrystGLFW

class Display
  property title  : String = ""
  property width  : Int32 = 800
  property height : Int32 = 600
  property bg     : Color

  property window : CrystGLFW::Window

  def initialize(title : String, width : Int32, height : Int32, bg : Color)
    @title  = title
    @width  = width
    @height = height
    @bg     = bg

    #
    # Request a specific version of OpenGL in core profile mode with forward compatibility.
    #
    hints = {
      Window::HintLabel::ContextVersionMajor => 3,
      Window::HintLabel::ContextVersionMinor => 3,
      Window::HintLabel::ClientAPI           => ClientAPI::OpenGL,
      Window::HintLabel::OpenGLProfile       => OpenGLProfile::Core
    }

    #
    # create a new window
    #
    @window = Window.new(width: width, height: height,title: title, hints: hints)

    #
    # Make the window the current OpenGL context
    #
    @window.make_context_current
  end

  def clear()
    LibGL.clear_color(@bg.red, @bg.green, @bg.blue, @bg.opacity)
    LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
  end

  #
  # render a model
  #
  def render(model : Model, shaderprogram : ShaderProgram)

    until @window.should_close?
      CrystGLFW.poll_events

      #
      # close when ESCAPE key is pressed
      #
      if @window.key_pressed?(Key::Escape)
        @window.should_close
      end

      #
      # draw model
      #
      clear()
      shaderprogram.start()
      model.draw()
      shaderprogram.stop()
      @window.swap_buffers
    end

    @window.destroy

    shaderprogram.cleanup()
  end # render

end
