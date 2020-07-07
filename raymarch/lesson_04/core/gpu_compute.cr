require "lib_gl"
require "crystglfw"
require "stumpy_png"
require "./program.cr"
require "./model.cr"
require "./math/**"
require "./config.cr"
include CrystGLFW

class GpuCompute

  property model          : Model
  property window         : CrystGLFW::Window
  property shader         : Program
  property title          : String
  property width          : Int32
  property height         : Int32

  # mouse properties
  property scrolling      : Bool = false
  property scroll_offset  : GLM::Vector2 = GLM::Vector2.new(0,0)
  property mouse_dx       : Float32 = 0f32
  property mouse_dy       : Float32 = 0f32
  property mouse_x        : Float32 = 0f32
  property mouse_y        : Float32 = 0f32

  # shaders
  property vertexshader   : String = ""
  property fragmentshader : String = ""

  # camera
  property camera         : GLM::Vector3

  # lights
  property lights         : Array(GLM::Vector3)

  property primary_light  : GLM::Vector3

  def initialize(config : Config)

    filenotfound(config.vertexshader)
    filenotfound(config.fragmentshader)

    @vertexshader   = config.vertexshader
    @fragmentshader = config.fragmentshader

    @title  = config.title
    @width  = config.width
    @height = config.height

    # camera
    @camera = config.camera

    # lights
    @lights = config.lights
    if @lights.size == 0
      puts "no light sources found, exit"
      exit(-1)
    end

    @primary_light = @lights[0]

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

      @window.enable_sticky_keys

      #
      # compile shaders
      # must be done in run loop
      #
      @shader.compile(@vertexshader,@fragmentshader)

      until @window.should_close?

        CrystGLFW.poll_events

        #
        # get current time
        #
        last_time = LibGLFW.get_time

        #
        # Important to set viewport especially
        # when we resize the window
        #
        LibGL.viewport(0,0,@width,@height)

        # window resize
        window_resize()

        @shader.use do

          @shader.set_uniform_int("screen_width",  @width)
          @shader.set_uniform_int("screen_height", @height)
          @shader.set_uniform_float("time",        last_time.to_f32)
          @shader.set_uniform_vector3("camera",    @camera)
          @shader.set_uniform_vector3("primary_light", @primary_light)

          #
          # draw a model
          #
          @model.draw()
        end

        @window.swap_buffers

        process_keys()
        process_mouse()

      end # should_close?

      @window.destroy
      @shader.cleanup()

    end # run loop
  end

  def window_resize()

    @window.on_resize do |event|
      @width  = event.size[:width]
      @height = event.size[:height]
    end

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

    # take screenshot
    if @window.key_pressed?(Key::S)

      #
      # inform user a screenshot will be taken
      #
      puts "taking screenshot and saving it to screenshot.ppm"
      if File.exists?("screenshot.ppm")
        File.delete("screenshot.ppm")
      end

      saveasppm("screenshot.ppm")
    end
  end

  def saveasppm(filename : String)

    #
    # allocate memory to save the screen pixels
    #
    x = 0
    y = 0
    format    = LibGL::RGBA
    data_type = LibGL::UNSIGNED_BYTE

    #
    # factor 3 is for the RGB component
    #
    buffer_size = @width * @height * 4
    image_data = Pointer(UInt8).malloc(buffer_size)
    LibGL.read_buffer(LibGL::FRONT)
    LibGL.read_pixels(x,y,@width,@height,format,data_type,image_data)

    arr = Array.new(@width) { Array.new(@height) { Color.new }}
    pos = 0

    (0..@height-1).each do |j|
      (0..@width-1).each do |i|
        slice = Bytes.new(4)
        slice[0] = image_data[pos]
        pos = pos + 1
        slice[1] = image_data[pos]
        pos = pos + 1
        slice[2] = image_data[pos]
        pos = pos + 1
        slice[3] = image_data[pos]
        pos = pos + 1

        arr[i][j] = Color.new(slice[0],slice[1],slice[2],slice[3])
      end
    end

    file = File.new(filename,"wb")
    file.puts "P6"
    file.puts "#{@width} #{@height}"
    file.puts "255"

    #
    # the (0,0) coordinate is at the bottom left
    # need to flip the image in the y direction
    #
    (@height-1).downto(0).each do |j|
      (0..@width-1).each do |i|
        slice = Bytes.new(3)
        slice[0] = arr[i][j].red
        slice[1] = arr[i][j].blue
        slice[2] = arr[i][j].green
        file.write(slice)
      end
    end
    file.close

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
