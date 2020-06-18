require "./math/**"

class ShaderProgram

  property program_id : LibGL::UInt
  property vs_id      : LibGL::UInt
  property fs_id      : LibGL::UInt

  property matrix_location_id : Int32 = 0 #LibGL::UInt

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
    LibGL.attach_shader(@program_id, @vs_id)
    LibGL.attach_shader(@program_id, @fs_id)
    LibGL.link_program(@program_id)
    LibGL.validate_program(@program_id)

    if @program_id == 0
      puts "failed to compiled shaders"
      exit
    end

    get_all_uniform_locations()
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
  end

  def bind_attribute(attribute : Int32, variable_name : String)
    LibGL.bind_attrib_location(@program_id, attribute, variable_name)
  end

  def get_uniform_location(uniform_name : String) : Int32
    return LibGL.get_uniform_location(@program_id,uniform_name)
  end

  def get_all_uniform_locations()
    @matrix_location_id = get_uniform_location("transformation_matrix")
  end

  def load_shader(text : String, type : LibGL::UInt) : LibGL::UInt
    shader_id = LibGL.create_shader(type)
    if shader_id == 0

      shader_error_code = LibGL.get_error
      raise "Error #{shader_error_code}: Shader creation failed. Could not find valid memory location when adding shader"

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

      raise "Error #{compile_error_code}: Failed compiling shader.\n'#{text}': #{compile_log_str}"
    end

    return shader_id
  end

  def load_float(location : Int32, value : Float32)
    LibGL.uniform1f(location,value)
  end

  def load_vector(location : Int33, value : Vector3f)
    LibGL.uniform3f(location,value.x,vector,y,vector,z)
  end

  def load_boolean(location : Int32, value : Bool)

    val = 0.0
    if value == true
      val = 1.0
    end

    LibGL.uniform1f(location,val)
  end

  def load_matrix(location : Int33, value : Array(Float32))

    transpose = false
    LibGL.uniform_matrix_4fv(location,16,transpose,value)

    #matrix = Matrix.new(value)
    #LibGL.uniform_matrix4(location,transpose,matrix)
  end

  def load_transformation_matrix(matrix : Matrix4f)
    load_matrix(@matrix_location_id,matrix.values)
  end

end
