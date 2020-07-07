require "lib_gl"
require "crystglfw"
require "./shaderprogram.cr"

include CrystGLFW

def triangle() : Array(Float32)

  vertex_arr = [
    -0.5, -0.5, 0.0,
     0.5, -0.5, 0.0,
     0.0,  0.5, 0.0,
  ]

  vertices = [] of Float32
  vertex_arr.each do |v|
    vertices << v.to_f32
  end

  return vertices
end

# => {major: 3, minor: 2, rev: 1}
def crystal_glfw_version()
  version = CrystGLFW.version
  puts "Crystal GLFW version #{version[:major]}.#{version[:minor]}.#{version[:rev]}"
end

def lesson(title : String = "OpenGL lesson 1, simple triangle", width : Int32 = 800, height : Int32 = 600)

  crystal_glfw_version()

  #
  # Request a specific version of OpenGL in core profile mode with forward compatibility.
  #
  hints = {
    Window::HintLabel::ContextVersionMajor => 3,
    Window::HintLabel::ContextVersionMinor => 3,
    Window::HintLabel::ClientAPI => ClientAPI::OpenGL,
    Window::HintLabel::OpenGLProfile => OpenGLProfile::Core
  }

  # color window background
  window_red     = 0.2
  window_green   = 0.3
  window_blue    = 0.3
  window_opacity = 1.0

  # data
  vertices = triangle()

  nr_vertices = (vertices.size/3).to_i

  CrystGLFW.run do

    # Create a new window
    window = Window.new(width: width, height: height,title: title, hints: hints)

    #
    # Make the window the current OpenGL context
    #
    window.make_context_current
    # link errors, window.maximize

    #
    # compile shaders
    # must be done in run loop
    #
    shaderprogram = ShaderProgram.new("shader.vs","shader.fs")

    #
    # vbo buffer
    #
    LibGL.gen_buffers(1, out vbo_id)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, vbo_id)
    LibGL.buffer_data(LibGL::ARRAY_BUFFER, vertices.size * sizeof(Float32), vertices, LibGL::STATIC_DRAW)

    #
    # vao buffer
    #
    LibGL.gen_vertex_arrays(1, out vao_id)
    LibGL.bind_vertex_array(vao_id)

    LibGL.vertex_attrib_pointer(0, nr_vertices, LibGL::FLOAT, LibGL::FALSE, nr_vertices * sizeof(Float32), Pointer(Void).new(0) )
    LibGL.enable_vertex_attrib_array(0)


    until window.should_close?
      CrystGLFW.poll_events

      #
      # needs to be placed after poll_events
      #

      # close when ESCAPE key is pressed
      if window.key_pressed?(Key::Escape)
        window.should_close
      end

      #
      # rendering here
      #
      LibGL.clear_color(window_red, window_green, window_blue, window_opacity)
      LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)

      shaderprogram.start()

      # bind vao
      LibGL.bind_vertex_array(vao_id)
      # draw triangle
      LibGL.draw_arrays(LibGL::TRIANGLES, 0, 3)

      shaderprogram.stop()

      window.swap_buffers
    end

    window.destroy
  end # run loop
end

lesson()
