require "lib_gl"
require "crystglfw"
require "./shaders/program.cr"
require "./textures/color.cr"

include CrystGLFW

class Display

  property settings : Settings
  property window   : CrystGLFW::Window
  property delta    : Float64

  def initialize(settings : Settings)

    @delta = 0.0f32
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
  end

  #
  # render entities
  #
  def render(entities : Array(Entity), terrains : Array(Terrain), camera : Camera, light : Light)

    master_renderer = MasterRenderer.new(@settings)
    until @window.should_close?

      CrystGLFW.poll_events

      # get current time
      last_frame_time = LibGLFW.get_time

      # move the camera
      camera.move(self)

      #
      # close when ESCAPE key is pressed
      #
      if @window.key_pressed?(Key::Escape)
        @window.should_close
      end

      #
      # render the terrains
      #
      master_renderer.process_terrains(terrains)
      entities.each do |entity|

        #
        # move the player
        #
        if entity.name == "player"
          player = entity.as(Player)
          player.move(self)
        end
        master_renderer.process_entity(entity)
      end
      master_renderer.render(light,camera)

      @window.swap_buffers

      #
      # get the current time
      #
      current_time = LibGLFW.get_time
      @delta = 1.0 * (current_time - last_frame_time)

    end

    @window.destroy
    master_renderer.cleanup()
  end # render

end
