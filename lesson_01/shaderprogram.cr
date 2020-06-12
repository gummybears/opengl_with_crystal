class ShaderProgram

  property programId : LibGL::UInt
  property vertexShaderId : LibGL::UInt
  property fragmentShaderId : LibGL::UInt
  #property vertexfile : String
  #property fragmentfile : String

  def initialize(vertexfile : String, fragmentfile : String)

    #@vertexfile = vertexfile
    #@fragmentfile = fragmentfile

    lines = File.read_lines(vertexfile)
    @vertexShaderId = load_shader(lines.join("\n"), LibGL::VERTEX_SHADER)

    lines = File.read_lines(fragmentfile)
    @fragmentShaderId = load_shader(lines.join("\n"), LibGL::FRAGMENT_SHADER)

    @programId = LibGL.create_program()
    LibGL.attach_shader(@programId, @vertexShaderId)
    LibGL.attach_shader(@programId, @fragmentShaderId)
    LibGL.link_program(@programId)
    LibGL.validate_program(@programId)
  end

  def start()
    LibGL.use_program(@programId)
  end

  def stop()
    LibGL.use_program(0)
  end

  def cleanup()
    stop()
    LibGL.detach_shader(@programId, @vertexShaderId)
    LibGL.detach_shader(@programId, @fragmentShaderId)
    LibGL.delete_shader(@vertexShaderId)
    LibGL.delete_shader(@fragmentShaderId)
    LibGL.delete_program(@programId)
  end

  def bind_attributes()
  end

  def bind_attribute(attribute : Int32, variable_name : String)
    puts "program id #{@programId} attr #{attribute} name #{variable_name}"
    LibGL.bind_attrib_location(@programId, attribute, variable_name)
  end

  def load_shader(text : String, type : LibGL::UInt) : LibGL::UInt
    shader_id = LibGL.create_shader(type)
    if shader_id == 0
      shader_error_code = LibGL.get_error
      raise "Error #{shader_error_code}: Shader creation failed. Could not find valid memory location when adding shader"
    end

    ptr = text.to_unsafe
    source = [ptr]
    LibGL.shader_source(shader_id, 1, source, Pointer(Int32).new(0))
    LibGL.compile_shader(shader_id)

    LibGL.get_shader_iv(shader_id, LibGL::COMPILE_STATUS, out compile_status)
    if compile_status == LibGL::FALSE
      LibGL.get_shader_info_log(shader_id, 2048, nil, out compile_log)
      compile_log_str = String.new(pointerof(compile_log))
      compile_error_code = LibGL.get_error
      raise "Error #{compile_error_code}: Failed compiling shader.\n'#{text}': #{compile_log_str}"
    end

    #puts "shader compiled #{compile_status}"
    return shader_id
  end

end
