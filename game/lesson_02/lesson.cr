require "lib_gl"
require "crystglfw"
require "./shaderprogram.cr"

include CrystGLFW

def twotriangles() : {Array(Float32), Array(Int32)}

  vertices = [
               0.5,  0.5,  0.0,
               0.5, -0.5,  0.0,
              -0.5, -0.5,  0.0,
              -0.5,  0.5,  0.0
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

def lesson(title : String = "OpenGL lesson 2, using indices ", width : Int32 = 800, height : Int32 = 600)

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
  vertices, indices  = twotriangles()

  nr_vertices = (vertices.size/3).to_i
  nr_indices  = indices.size

  CrystGLFW.run do

    # Create a new window
    window = Window.new(width: width, height: height,title: title, hints: hints)

    #
    # Make the window the current OpenGL context
    #
    window.make_context_current

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

      window.swap_buffers
    end

    window.destroy
  end # run loop
end

lesson()
