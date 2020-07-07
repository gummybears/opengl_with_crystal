require "lib_gl"
require "crystglfw"
require "./program.cr"
require "./model.cr"
require "./math/**"

include CrystGLFW

class GpuCompute

  property model          : Model
  property window         : CrystGLFW::Window
  property shader         : Program
  property title          : String
  property width          : Int32
  property height         : Int32

  property scrolling      : Bool = false
  property scroll_offset  : GLM::Vector2 = GLM::Vector2.new(0,0)
  property mouse_dx       : Float32 = 0f32
  property mouse_dy       : Float32 = 0f32
  property mouse_x        : Float32 = 0f32
  property mouse_y        : Float32 = 0f32

  property vertexshader   : String = ""
  property fragmentshader : String = ""

  def initialize(title : String, width : Int32, height : Int32, vertexshader : String, fragmentshader : String)

    filenotfound(vertexshader)
    filenotfound(fragmentshader)

    @vertexshader   = vertexshader
    @fragmentshader = fragmentshader

    @title  = title
    @width  = width
    @height = height
    #
    # Request a specific version of OpenGL in core profile mode with forward compatibility.
    #
    hints = {
      Window::HintLabel::ContextVersionMajor => 3,
      Window::HintLabel::ContextVersionMinor => 3,
      Window::HintLabel::ClientAPI => ClientAPI::OpenGL,
      Window::HintLabel::OpenGLProfile => OpenGLProfile::Core
    }

    #
    # create a new window
    #
    @window = Window.new(width: width, height: height,title: title, hints: hints)
    #
    # Make the window the current OpenGL context
    #
    @window.make_context_current

    #
    # load the quad
    #
    @model = Model.load_quad()

    @shader = Program.new()
  end

  def run()

    CrystGLFW.run do

      #
      # compile shaders
      # must be done in run loop
      #
      @shader.compile(@vertexshader,@fragmentshader)

      until @window.should_close?

        CrystGLFW.poll_events

        # get current time
        last_time = LibGLFW.get_time

        @shader.use do

          @shader.set_uniform_int("screen_width",  @width)
          @shader.set_uniform_int("screen_height", @height)
          @shader.set_uniform_float("time",last_time.to_f32)

          #
          # draw a model
          #
          @model.draw()
        end

        process_keys()
        process_mouse()

        @window.swap_buffers

      end # should_close?

      @window.destroy
      @shader.cleanup()

    end # run loop
  end

  def process_keys()

    #
    # close when ESCAPE key is pressed
    #
    if @window.key_pressed?(Key::Escape)
      @window.should_close
    end

    # reload shaders
    if @window.key_pressed?(Key::R)

      #
      # recompile shaders
      #
      @shader.compile(@vertexshader,@fragmentshader)

      # inform user the shaders will be recompiled
      puts "recompiling shaders : #{@vertexshader} and #{@fragmentshader}"
    end

  end

  #
  # processing of mouse events is
  # basic, just to make things work
  # need to be improved
  #
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

    #
    # reset scrolling
    #
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

      #
      # stop scrolling
      #
      @scrolling = false
      new_cursor_pos = event.position
      @mouse_dx = (new_cursor_pos[:x] - old_cursor_pos[:x]).to_f32
      @mouse_dy = (new_cursor_pos[:y] - old_cursor_pos[:y]).to_f32

      @mouse_x  = new_cursor_pos[:x].to_f32
      @mouse_y  = new_cursor_pos[:y].to_f32
    end
  end

end
