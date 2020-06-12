require "crystglfw"
include CrystGLFW

require "lib_gl"
require "./shaderprogram.cr"

# vertices = [
#             -0.5,  0.5,  0.0, # v0
#             -0.5, -0.5,  0.0, # v1
#               0.5,  0.5,  0.0, # v3
#               0.5,  0.5,  0.0, # v3
#             -0.5, -0.5,  0.0, # v1
#               0.5, -0.5,  0.0 # v2
#           ]
#
# indices = [
#             0,1,3, # top left triangle
#             3,1,2  # bottom right triangle
#           ]

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
def version()
  version = CrystGLFW.version
  puts "#{version[:major]}.#{version[:minor]}.#{version[:rev]}"
end

def opengl0(title : String = "OpenGL lesson 1", width : Int32 = 800, height : Int32 = 600)

  version()

  #
  # Request a specific version of OpenGL in core profile mode with forward compatibility.
  #
  hints = {
    Window::HintLabel::ContextVersionMajor => 3,
    Window::HintLabel::ContextVersionMinor => 3,
    Window::HintLabel::ClientAPI => ClientAPI::OpenGL,
    Window::HintLabel::OpenGLProfile => OpenGLProfile::Core
  }

  # color triangle
  red     = 0.2
  green   = 0.3
  blue    = 0.3
  opacity = 1.0

  # data
  vertices = triangle()

  CrystGLFW.run do

    # Create a new window
    window = Window.new(width: width, height: height,title: title, hints: hints)

    ## Configure the window to print its dimensions each time it is resized.
    #window.on_resize do |event|
    #  puts "Window resized to #{event.size}"
    #end

    #
    # Make the window the current OpenGL context
    #
    window.make_context_current
    # link errors, window.maximize

    #
    # viewport
    #
    # LibGL.viewport(0, 0, width, height)

    #
    # compile shaders
    # must be done in run loop
    #
    shaderprogram = ShaderProgram.new("shader.vs","shader.fs")

    #
    # buffers
    #
    # copy vertex data into the vbo buffer
    #
    # 1 vbo buffer
    LibGL.gen_buffers(1, out vbo_id)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, vbo_id)
    #LibGL.buffer_data(LibGL::ELEMENT_ARRAY_BUFFER, indices.size * sizeof(Int32), indices, LibGL::STATIC_DRAW)
    LibGL.buffer_data(LibGL::ARRAY_BUFFER, vertices.size * sizeof(Float32), vertices, LibGL::STATIC_DRAW)

    # vertex buffer
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
      LibGL.clear_color(red, green, blue, opacity)
      LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)

      shaderprogram.start()

      # bind vao
      LibGL.bind_vertex_array(vao_id)
      # draw triangle
      LibGL.draw_arrays(LibGL::TRIANGLES, 0, 3)
      # unbind vao
      #LibGL.bind_vertex_array(0)

      shaderprogram.stop()

      window.swap_buffers
    end

    window.destroy
  end # run loop
end

opengl0()
