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

    master_renderer = MasterRenderer.new(program,@fov,@aspect_ratio,@near, @far, @bg)

    until @window.should_close?
      CrystGLFW.poll_events


      #
      # close when ESCAPE key is pressed
      #
      if @window.key_pressed?(Key::Escape)
        @window.should_close
      end

      entities.each do |entity|
        master_renderer.process_entity(entity)
      end

      master_renderer.render(light,camera)


      @window.swap_buffers
    end

    @window.destroy

    master_renderer.cleanup()
  end # render


  #
  # render a model
  #
  def old_render(entities : Array(Entity), program : Program, camera : Camera, light : Light)

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

          entities.each do |x|

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
