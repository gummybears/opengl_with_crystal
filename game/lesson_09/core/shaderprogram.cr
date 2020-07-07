require "../math/**"

class ShaderProgram

  property program_id : LibGL::UInt
  property vs_id      : LibGL::UInt
  property fs_id      : LibGL::UInt

  def initialize(vertexfile : String, fragmentfile : String)

    if File.exists?(vertexfile) == false
      puts "file #{vertexfile} not found"
      exit
    end

    if File.exists?(fragmentfile) == false
      puts "file #{fragmentfile} not found"
      exit
    end

    lines  = File.read_lines(vertexfile)
    @vs_id = load_shader(lines.join("\n"), LibGL::VERTEX_SHADER)

    lines  = File.read_lines(fragmentfile)
    @fs_id = load_shader(lines.join("\n"), LibGL::FRAGMENT_SHADER)

    @program_id = LibGL.create_program()

    bind_attributes()

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

  def bind_attributes()
    bind_attribute(0,"position")
    bind_attribute(1,"pass_textureCoords")
    bind_attribute(2,"normal")
  end

  def bind_attribute(attribute : Int32, variable_name : String)
    LibGL.bind_attrib_location(@program_id, attribute, variable_name)
  end

  def load_shader(text : String, type : LibGL::UInt) : LibGL::UInt

    shader_id = LibGL.create_shader(type)
    if shader_id == 0
      shader_error_code = LibGL.get_error
      raise "error #{shader_error_code}: shader creation failed. Could not find valid memory location when adding shader"
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

      raise "error #{compile_error_code}: failed compiling shader.\n'#{text}': #{compile_log_str}"
    end

    return shader_id
  end

  #
  # set uniform matrix
  #
  def set_uniform_matrix_4f(name, value)
    use do
      location = LibGL.get_uniform_location(@program_id, name)
      LibGL.uniform_matrix_4fv(location, 1, LibGL::FALSE, value.buffer)
    end
  end

  #
  # set uniform vector3
  #
  def set_uniform_vector(name, value)
    use do
      location = LibGL.get_uniform_location(@program_id, name)
      LibGL.uniform_3fv(location, 1, value.buffer)
    end
  end

end
