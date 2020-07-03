require "./errors.cr"

class Program

  property program_id : LibGL::UInt = 0
  property vs_id      : LibGL::UInt = 0
  property fs_id      : LibGL::UInt = 0

  def initialize()
  end

  def compile(vertexfile : String, fragmentfile : String)

    lines  = File.read_lines(vertexfile).join("\n")
    @vs_id = load_shader(lines, LibGL::VERTEX_SHADER)

    lines  = File.read_lines(fragmentfile).join("\n")
    @fs_id = load_shader(lines, LibGL::FRAGMENT_SHADER)

    @program_id = LibGL.create_program()

    LibGL.attach_shader(@program_id, @vs_id)
    LibGL.attach_shader(@program_id, @fs_id)
    LibGL.link_program(@program_id)
    LibGL.validate_program(@program_id)

    LibGL.delete_shader(@vs_id)
    LibGL.delete_shader(@fs_id)
  end

  def use(&block)
    LibGL.use_program(@program_id)
    yield
  end

  def start()
    LibGL.use_program(@program_id)
  end

  def stop()
    LibGL.use_program(0)
  end

  def cleanup()
    stop()
    LibGL.detach_shader(@program_id, @vs_id)
    LibGL.detach_shader(@program_id, @fs_id)
    LibGL.delete_shader(@vs_id)
    LibGL.delete_shader(@fs_id)
    LibGL.delete_program(@program_id)
  end

  def bind_attribute(attribute : Int32, variable_name : String)
    LibGL.bind_attrib_location(@program_id, attribute, variable_name)
  end

  def load_shader(text : String, type : LibGL::UInt) : LibGL::UInt

    shader_id = LibGL.create_shader(type)
    if shader_id == 0
      shader_error_code = LibGL.get_error

      str = [] of String
      str << "shader creation failed, error :"
      str << "#{shader_error_code}"
      s = str.join("\n")
      puts s
      exit
    end

    ptr    = text.to_unsafe
    source = [ptr]

    LibGL.shader_source(shader_id, 1, source, Pointer(Int32).new(0))
    LibGL.compile_shader(shader_id)

    LibGL.get_shader_iv(shader_id, LibGL::COMPILE_STATUS, out compile_status)

    if compile_status == LibGL::FALSE
      LibGL.get_shader_info_log(shader_id, 2048, nil, out compile_log)

      compile_log_str    = String.new(pointerof(compile_log))
      compile_error_code = LibGL.get_error

      str = [] of String
      str << "shader compile error"
      str << "failed to compile"
      str << text
      s = str.join("\n")
      puts s

      puts "error '#{compile_log}'"
      exit
    end

    return shader_id
  end

  #
  # set uniform matrix
  #
  def set_uniform_matrix_4f(name : String, value : GLM::Matrix)
    use do
      location = LibGL.get_uniform_location(@program_id, name)
      LibGL.uniform_matrix_4fv(location, 1, LibGL::FALSE, value.buffer)
    end
  end

  #
  # set uniform vector3
  #
  def set_uniform_vector3(name : String, value : GLM::Vector3)
    use do
      location = LibGL.get_uniform_location(@program_id, name)
      LibGL.uniform_3fv(location, 1, value.buffer)
    end
  end

  #
  # set uniform vector2
  #
  def set_uniform_vector2(name : String, value : GLM::Vector2)
    use do
      location = LibGL.get_uniform_location(@program_id, name)
      LibGL.uniform_2fv(location, 1, value.buffer)
    end
  end

  #
  # set uniform float
  #
  def set_uniform_float(name : String, value : Float32)
    use do
      location  = LibGL.get_uniform_location(@program_id, name)
      LibGL.uniform_1f(location,value)
    end
  end

  #
  # set uniform integer
  #
  def set_uniform_int(name : String, value : Int32)
    use do
      location  = LibGL.get_uniform_location(@program_id, name)
      LibGL.uniform_1i(location,value)
    end
  end

  def load_view_matrix(matrix : GLM::Matrix)
    use do
      set_uniform_matrix_4f("view", matrix)
    end
  end

  def load_projection_matrix(matrix : GLM::Matrix)
    use do
      set_uniform_matrix_4f("projection", matrix)
    end
  end

  def load_transformation(matrix : GLM::Matrix)
    use do
      set_uniform_matrix_4f("model", matrix)
    end
  end
end
