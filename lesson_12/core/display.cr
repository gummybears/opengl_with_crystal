require "lib_gl"
require "crystglfw"
require "./shader/program.cr"
require "./texture/color.cr"

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

  property window       : CrystGLFW::Window

  property last_frame_time : Time::Span
  property delta           : Time::Span

  #def initialize(title : String, width : Float32, height : Float32, fov : Float32, near : Float32, far : Float32, bg : Color)
  #  @title        = title
  #  @width        = width
  #  @height       = height
  #  @bg           = bg
  #  @fov          = fov
  #  @near         = near
  #  @far          = far
  #  @aspect_ratio = (@width/height).to_f32
  #
  #  #
  #  # Request a specific version of OpenGL in core profile mode with forward compatibility.
  #  #
  #  hints = {
  #    Window::HintLabel::ContextVersionMajor => 3,
  #    Window::HintLabel::ContextVersionMinor => 3,
  #    Window::HintLabel::ClientAPI           => ClientAPI::OpenGL,
  #    Window::HintLabel::OpenGLProfile       => OpenGLProfile::Core
  #  }
  #
  #  #
  #  # create a new window
  #  #
  #  @window = Window.new(width: width, height: height,title: title, hints: hints)
  #
  #  #
  #  # Make the window the current OpenGL context
  #  #
  #  @window.make_context_current
  #
  #  @last_frame_time = Time::Span.zero
  #  @delta = Time::Span.zero
  #
  #end

  def initialize(settings : Settings)
    @title        = settings.title
    @width        = settings.width
    @height       = settings.height
    @bg           = settings.bg
    @fov          = settings.fov
    @near         = settings.near
    @far          = settings.far
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

    @last_frame_time = Time::Span.zero
    @delta = Time::Span.zero

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
  def render(entities : Array(Entity), program : Program, camera : Camera, light : Light)

    #current_frame_time = get_current_time()
    @delta = Time.measure do

      projection = GLM.perspective(@fov,@aspect_ratio,@near, @far)
      program.set_uniform_matrix_4f("projection", projection)

      until @window.should_close?
        CrystGLFW.poll_events

        #
        # close when ESCAPE key is pressed
        #
        if @window.key_pressed?(Key::Escape)
          @window.should_close
        end

        prepare()

        program.use() do

          view  = GLM.translate(camera.position)
          program.set_uniform_matrix_4f("view", view)

          program.set_uniform_vector("light_position",light.position)
          program.set_uniform_vector("light_color",light.color)

          # old code # move negative z
          # old code if @window.key_pressed?(Key::W)
          # old code   camera.move_in()
          # old code end
          # old code
          # old code # move positive z
          # old code if @window.key_pressed?(Key::X)
          # old code   camera.move_out()
          # old code end
          # old code
          # old code # move negative x
          # old code if @window.key_pressed?(Key::A)
          # old code   camera.move_left()
          # old code end
          # old code
          # old code # move positive x
          # old code if @window.key_pressed?(Key::D)
          # old code   camera.move_right()
          # old code end
          # old code
          # old code # move negative y
          # old code if @window.key_pressed?(Key::Y)
          # old code   camera.move_down()
          # old code end
          # old code
          # old code # move positive y
          # old code if @window.key_pressed?(Key::Z)
          # old code   camera.move_up()
          # old code end

          entities[0].increaseRotation(0.0,0.05,0.0)
          entities[0].increasePosition(0.0,0.0,0.0)

          entities.each do |x|

            if x.class.to_s == "Player" #model.type == ModelType::PLAYER
              player = x.as(Player)
              player.move(self)
            end

            #
            # each entity model
            # has a property shine damper
            # and property reflectivity
            #
            program.set_uniform_float("shine_damper",x.model.shine_damper)
            program.set_uniform_float("reflectivity",x.model.reflectivity)

            x.draw(program)
          end

        end

        @window.swap_buffers

        # @delta = @last_frame_time - current_frame_time #- @last_frame_time)
        # @last_frame_time = get_current_time()
      end
    end

    @window.destroy
    program.cleanup()
  end # render

  def get_delta
    @delta
  end

  def get_current_time()
    Time.monotonic
  end
end
