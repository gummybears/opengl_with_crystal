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

  def prepare()
    LibGL.clear_color(@bg.red, @bg.green, @bg.blue, @bg.opacity)
    LibGL.enable(LibGL::DEPTH_TEST)
    LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)

    # cull all faces which are invisible for the camera
    LibGL.enable(LibGL::CULL_FACE)
    LibGL.cull_face(LibGL::BACK)

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

      prepare()

      shaderprogram.use() do

        view  = GLM.translate(camera.position)
        shaderprogram.set_uniform_matrix_4f("view", view)

        shaderprogram.set_uniform_vector("light_position",light.position)
        shaderprogram.set_uniform_vector("light_color",light.color)

        # move negative z
        if @window.key_pressed?(Key::W)
          camera.move_in()
        end

        # move positive z
        if @window.key_pressed?(Key::X)
          camera.move_out()
        end

        # move negative x
        if @window.key_pressed?(Key::A)
          camera.move_left()
        end

        # move positive x
        if @window.key_pressed?(Key::D)
          camera.move_right()
        end

        # move negative y
        if @window.key_pressed?(Key::Y)
          camera.move_down()
        end

        # move positive y
        if @window.key_pressed?(Key::Z)
          camera.move_up()
        end

        entities[0].increaseRotation(0.0,0.05,0.0)
        entities[0].increasePosition(0.0,0.0,0.0)

        entities.each do |x|

          #
          # each entity model when of type TextureModel
          # has a property shine damper and property reflectivity
          #
          if x.model.class.to_s == "TextureModel"
            texture_model = x.model.as(TextureModel)
            shaderprogram.set_uniform_float("shine_damper",texture_model.shine_damper)
            shaderprogram.set_uniform_float("reflectivity",texture_model.reflectivity)
          end

          x.draw(shaderprogram)
        end

      end

      @window.swap_buffers
    end

    @window.destroy
    shaderprogram.cleanup()
  end # render

end
