require "lib_gl"
require "crystglfw"
require "./shaderprogram.cr"
require "./color.cr"

include CrystGLFW

class Display
  property title        : String = ""
  property width        : Float32
  property height       : Float32
  property bg           : Color

  property fov          : Float32
  property near         : Float32
  property far          : Float32
  property aspect_ratio : Float32

  property window : CrystGLFW::Window

  def initialize(title : String, width : Float32, height : Float32, fov : Float32, near : Float32, far : Float32, bg : Color)
    @title        = title
    @width        = width
    @height       = height
    @bg           = bg
    @fov          = fov
    @near         = near
    @far          = far
    @aspect_ratio = (@width/height).to_f32

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
    LibGL.enable(LibGL::DEPTH_TEST)
    LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
  end

  #
  # render a model
  #
  def render(entities : Array(Entity), shaderprogram : ShaderProgram, camera : Camera, light : Light)

    projection = GLM.perspective(@fov,@aspect_ratio,@near, @far)
    shaderprogram.set_uniform_matrix_4f("projection", projection)

    until @window.should_close?
      CrystGLFW.poll_events

      #
      # close when ESCAPE key is pressed
      #
      if @window.key_pressed?(Key::Escape)
        @window.should_close
      end

      clear()

      shaderprogram.use() do

        view  = GLM.translate(camera.position)
        shaderprogram.set_uniform_matrix_4f("view", view)
        shaderprogram.set_uniform_vector("light_position",light.position)
        shaderprogram.set_uniform_vector("light_color",light.color)

        if @window.key_pressed?(Key::W)
          camera.move_w()
        end

        if @window.key_pressed?(Key::A)
          camera.move_a()
        end

        if @window.key_pressed?(Key::D)
          camera.move_d()
        end

        if @window.key_pressed?(Key::X)
          camera.move_x()
        end

        entities[0].increaseRotation(0.0,0.05,0.0)
        entities[0].increasePosition(0.0,0.0,0.0)

        entities.each do |x|
          x.draw(shaderprogram)
        end

      end

      @window.swap_buffers
    end

    @window.destroy

    shaderprogram.cleanup()
  end # render

end
