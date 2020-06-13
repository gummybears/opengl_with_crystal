require "lib_gl"
require "crystglfw"
require "./shaderprogram.cr"
require "./color.cr"

include CrystGLFW

class Display
  property title  : String = ""
  property width  : Int32 = 800
  property height : Int32 = 600
  property bg     : Color

  property window : CrystGLFW::Window

  def initialize(title : String, width : Int32, height : Int32, bg : Color)
    @title  = title
    @width  = width
    @height = height
    @bg     = bg
    #
    # Request a specific version of OpenGL in core profile mode with forward compatibility.
    #
    hints = {
      Window::HintLabel::ContextVersionMajor => 3,
      Window::HintLabel::ContextVersionMinor => 3,
      Window::HintLabel::ClientAPI => ClientAPI::OpenGL,
      Window::HintLabel::OpenGLProfile => OpenGLProfile::Core
    }

    # create a new window
    @window = Window.new(width: width, height: height,title: title, hints: hints)

  end

  def render(vertices, indices)

    CrystGLFW.run do

      #
      # Make the window the current OpenGL context
      #
      @window.make_context_current

      #
      # compile shaders
      # must be done in run loop
      #
      shaderprogram = ShaderProgram.new("shader.vs","shader.fs")

      #
      # vbo and ebo buffer (element array buffer)
      #
      LibGL.gen_buffers(1, out vbo_id)
      LibGL.bind_buffer(LibGL::ARRAY_BUFFER, vbo_id)
      LibGL.buffer_data(LibGL::ARRAY_BUFFER, vertices.size * sizeof(Float32), vertices, LibGL::STATIC_DRAW)

      LibGL.gen_buffers(1, out ebo_id)
      LibGL.bind_buffer(LibGL::ELEMENT_ARRAY_BUFFER, ebo_id)
      LibGL.buffer_data(LibGL::ELEMENT_ARRAY_BUFFER, indices.size * sizeof(Int32), indices, LibGL::STATIC_DRAW)

      #
      # vao buffer
      #
      LibGL.gen_vertex_arrays(1, out vao_id)
      LibGL.bind_vertex_array(vao_id)

      LibGL.vertex_attrib_pointer(0, 3, LibGL::FLOAT, LibGL::FALSE, 3 * sizeof(Float32), Pointer(Void).new(0) )
      LibGL.enable_vertex_attrib_array(0)

      until @window.should_close?
        CrystGLFW.poll_events

        #
        # needs to be placed after poll_events
        #

        # close when ESCAPE key is pressed
        if @window.key_pressed?(Key::Escape)
          @window.should_close
        end

        #
        # rendering here
        #
        LibGL.clear_color(@bg.red, @bg.green, @bg.blue, @bg.opacity)
        LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)

        shaderprogram.start()

        # bind vao
        LibGL.bind_vertex_array(vao_id)

        #
        # important to bind the EBO buffer before draw_elements
        #
        LibGL.bind_buffer(LibGL::ELEMENT_ARRAY_BUFFER, ebo_id)
        #
        # draw 2 triangles
        #
        # Note: the 6 is the number of indices
        LibGL.draw_elements(LibGL::TRIANGLES, 6, LibGL::UNSIGNED_INT, Pointer(Void).new(0))


        shaderprogram.stop()

        @window.swap_buffers
      end

      @window.destroy
    end # run loop

  end
end
