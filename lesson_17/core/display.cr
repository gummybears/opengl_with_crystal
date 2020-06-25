require "lib_gl"
require "crystglfw"
require "./shaders/program.cr"
require "./textures/color.cr"

include CrystGLFW

class Display

  property settings     : Settings
  property window       : CrystGLFW::Window

  def initialize(settings : Settings)
    @settings = settings

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
    @window = Window.new(width: settings.width, height: settings.height,title: settings.title, hints: hints)

    #
    # Make the window the current OpenGL context
    #
    @window.make_context_current

    @last_frame_time = Time::Span.zero
    @delta = Time::Span.zero

  end

  #
  # render entities
  #
  def render(entities : Array(Entity), terrains : Array(Terrain), camera : Camera, light : Light)

    master_renderer = MasterRenderer.new(@settings)
    until @window.should_close?

      CrystGLFW.poll_events

      move(camera)
      #
      # close when ESCAPE key is pressed
      #
      if @window.key_pressed?(Key::Escape)
        @window.should_close
      end

      # render the terrains
      master_renderer.process_terrains(terrains)

      entities.each do |entity|
        master_renderer.process_entity(entity)
      end
      master_renderer.render(light,camera)

      @window.swap_buffers
    end

    @window.destroy
    master_renderer.cleanup()
  end # render

  def move(camera : Camera)
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
  end

end
