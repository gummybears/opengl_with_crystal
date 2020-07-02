require "lib_gl"
require "crystglfw"
require "./program.cr"
require "./model.cr"

include CrystGLFW

class GpuCompute

  property model   : Model
  property window  : CrystGLFW::Window

  def initialize(title : String, width : Int32, height : Int32)
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
    # set the cursor input mode, see https://www.glfw.org/docs/3.2/group__input.html#gaa92336e173da9c8834558b54ee80563b
    #
    @window.cursor.disable

    vertices, indices = quad()
    @model = Model.load(vertices,indices)
  end

  def quad() : {Array(Float32), Array(Int32)}
    vertices = [
                 1.0,  1.0,  0.0,
                 1.0, -1.0,  0.0,
                -1.0, -1.0,  0.0,
                -1.0,  1.0,  0.0
              ]

    indices = [
                0,1,3, # first triangle
                1,2,3  # second triangle
              ]

    vertex_arr = [] of Float32
    vertices.each do |v|
      vertex_arr << v.to_f32
    end

    index_arr = [] of Int32
    indices.each do |v|
      index_arr << v.to_i32
    end

    return vertex_arr, index_arr
  end

  def run()

    CrystGLFW.run do

      #
      # compile shaders
      # must be done in run loop
      #
      shader = Program.new("shader.vs","shader.fs")

      until window.should_close?
        CrystGLFW.poll_events

        shader.use do

          #
          # draw a model
          #
          @model.draw()
        end

        # close when ESCAPE key is pressed
        if window.key_pressed?(Key::Escape)
          window.should_close
        end

        window.swap_buffers
      end # should_close?

      window.destroy
      shader.cleanup()

    end # run loop
  end
end
