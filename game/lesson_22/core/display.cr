require "lib_gl"
require "crystglfw"
require "./shaders/program.cr"
require "./textures/color.cr"

include CrystGLFW

class Display

  property settings      : Settings
  property window        : CrystGLFW::Window

  property scroll_offset : GLM::Vector2
  property scrolling     : Bool = false
  property mouse_dx      : Float32
  property mouse_dy      : Float32
  property elapsed       : Float64

  property mouse_left    : Int32 = -1
  property mouse_right   : Int32 = -1

  def initialize(settings : Settings)

    @scroll_offset = GLM::Vector2.new(0f32,0f32)
    @mouse_dx      = 0.0f32
    @mouse_dy      = 0.0f32
    @elapsed       = 0.0f32
    @settings      = settings

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

    #
    # set the cursor input mode, see https://www.glfw.org/docs/3.2/group__input.html#gaa92336e173da9c8834558b54ee80563b
    #
    @window.cursor.disable

  end

  #
  # render entities
  #
  def render(entities : Array(Entity), terrains : Array(Terrain), camera : Camera, light : Light)

    scrolled = false

    master_renderer = MasterRenderer.new(@settings)
    until @window.should_close?

      CrystGLFW.poll_events

      # get current time
      last_time = LibGLFW.get_time

      process_keys()
      process_mouse()

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

          #
          # need to find the terrain the player is standing on
          # for now take the first terrain as test
          #

          terrain_index = player_in_which_terrain(terrains,player)
          terrain = terrains[terrain_index]
          player.move(self,terrain)

          if camera.is_a?(ThirdPersonCamera)
            camera.move(self)
          end
        end

        master_renderer.process_entity(entity)
      end

      master_renderer.render(light,camera)
      @window.swap_buffers

      #
      # get the current time
      #
      current_time = LibGLFW.get_time
      @elapsed = 1.0 * (current_time - last_time)

    end

    @window.destroy
    master_renderer.cleanup()
  end # render

  def player_in_which_terrain(terrains : Array(Terrain), player : Player) : Int32

    position = player.position
    terrains.each_with_index do |terrain,i|

      x = terrain.x
      z = terrain.z

      if position.x >= x && position.x <= x + terrain.size
        if position.z >= z && position.z <= z + terrain.size
          #puts "pos #{position.to_s} terrain x #{x} z #{z} size #{terrain.size} in terrain #{i} " #, height #{height}"
          return i
        end
      end

      #puts "pos #{position.to_s} terrain x #{x} z #{z} size #{terrain.size} not in terrain"
    end

    return 0
  end

  def process_keys()

    #
    # close when ESCAPE key is pressed
    #
    if @window.key_pressed?(Key::Escape)
      @window.should_close
    end
  end

  def process_mouse()

    # get current time
    current_time = LibGLFW.get_time

    #
    # get the window cursor position
    #
    old_cursor_pos = @window.cursor.position

    @window.on_scroll do |event|
      @scroll_offset = GLM::Vector2.new(event.offset[:x].to_f32,event.offset[:y].to_f32)
      @scrolling     = true
      @mouse_left    = -1
      @mouse_right   = -1
    end

    # reset scrolling
    if @scrolling == false
      @scroll_offset = GLM::Vector2.new(0f32,0f32)
    end

    @window.on_mouse_button do |event|

      # stop scrolling
      @scrolling = false
      @scroll_offset = GLM::Vector2.new(0f32,0f32)

      mouse_button = event.mouse_button

      if event.action.press? && mouse_button.left?
        @mouse_left  = 1
        @mouse_right = -1
      end

      if event.action.press? && mouse_button.right?
        @mouse_left  = -1
        @mouse_right = 1
      end
    end

    @window.on_cursor_move do |event|

      # stop scrolling
      @scrolling = false
      new_cursor_pos = event.position
      @mouse_dx = (new_cursor_pos[:x] - old_cursor_pos[:x]).to_f32
      @mouse_dy = (new_cursor_pos[:y] - old_cursor_pos[:y]).to_f32
    end

  end

end
