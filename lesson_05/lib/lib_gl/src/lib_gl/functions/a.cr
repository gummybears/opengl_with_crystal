lib LibGL

  # Sets the active program object for a program pipeline object.
  fun active_shader_program = glActiveShaderProgram(pipeline  : UInt,
                                                    program   : UInt) : Void

  # Specifies which texture unit to make active.
  fun active_texture = glActiveTexture(texture : Enum) : Void

  # Attaches a shader object to a program object.
  fun attach_shader = glAttachShader(program  : UInt,
                                     shader   : UInt) : Void

end
