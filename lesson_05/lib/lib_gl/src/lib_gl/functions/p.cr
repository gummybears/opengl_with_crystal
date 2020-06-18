lib LibGL
  # Specifies the parameters for patch primitives
  fun patch_parameter_i = glPatchParameteri(name  : Enum,
                                            value : Int) : Void

  # Specifies the parameters for patch primitives
  fun patch_parameter_fv = glPatchParameterfv(name    : Enum,
                                              values  : Pointer(Float)) : Void

  # Pauses transform feedback operations.
  fun pause_transform_feedback = glPauseTransformFeedback : Void

  # Sets pixel storage modes.
  fun pixel_store_f = glPixelStoref(p_name  : Enum,
                                    param   : Float) : Void
                                    
  # Sets pixel storage modes.
  fun pixel_store_i = glPixelStorei(p_name  : Enum,
                                    param   : Int) : Void

  # Specifies point parameters.
  fun point_parameter_f = glPointParameterf(p_name  : Enum,
                                            param   : Float) : Void

  # Specifies point parameters.
  fun point_parameter_i = glPointParameteri(p_name  : Enum,
                                            param   : Int) : Void

  # Specifies the diameter of rasterized points.
  fun point_size = glPointSize(size : Float) : Void

  # Selects a polygon rasterization mode.
  fun polygon_mode = glPolygonMode( face  : Enum,
                                    mode  : Enum) : Void

  # Sets the scale and units used to calculate depth values.
  fun polygon_offset = glPolygonOffset( factor  : Float,
                                        units   : Float) : Void

  # Pops the active debug group.
  fun pop_debug_group = glPopDebugGroup : Void

  # Specifies the primitive restart index.
  fun primitive_restart_index = glPrimitiveRestartIndex(index : UInt) : Void

  # Loads a program object with a program binary.
  fun program_binary = glProgramBinary( program       : UInt,
                                        binary_format : Enum,
                                        binary        : Pointer(Void),
                                        length        : Sizei) : Void

  # Specifies a parameter for a program object.
  fun program_parameter_i = glProgramParameteri(program : UInt,
                                                p_name  : Enum,
                                                value   : Int) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_1f = glProgramUniform1f(program   : UInt,
                                              location  : Int,
                                              v0        : Float) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_2f = glProgramUniform2f(program   : UInt,
                                              location  : Int,
                                              v0        : Float,
                                              v1        : Float) : Void
                                                
  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_3f = glProgramUniform3f(program   : UInt,
                                              location  : Int,
                                              v0        : Float,
                                              v1        : Float,
                                              v2        : Float) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_4f = glProgramUniform4f(program   : UInt,
                                              location  : Int,
                                              v0        : Float,
                                              v1        : Float,
                                              v2        : Float,
                                              v3        : Float) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_1i = glProgramUniform1i(program   : UInt,
                                              location  : Int,
                                              v0        : Int) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_2i = glProgramUniform2i(program   : UInt,
                                              location  : Int,
                                              v0        : Int,
                                              v1        : Int) : Void
                                                
  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_3i = glProgramUniform3i(program   : UInt,
                                              location  : Int,
                                              v0        : Int,
                                              v1        : Int,
                                              v2        : Int) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_4i = glProgramUniform4i(program   : UInt,
                                              location  : Int,
                                              v0        : Int,
                                              v1        : Int,
                                              v2        : Int,
                                              v3        : Int) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_1ui = glProgramUniform1ui(program   : UInt,
                                                location  : Int,
                                                v0        : UInt) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_2ui = glProgramUniform2ui(program   : UInt,
                                                location  : Int,
                                                v0        : UInt,
                                                v1        : UInt) : Void
                                                
  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_3ui = glProgramUniform3ui(program   : UInt,
                                                location  : Int,
                                                v0        : UInt,
                                                v1        : UInt,
                                                v2        : UInt) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_4ui = glProgramUniform4ui(program   : UInt,
                                                location  : Int,
                                                v0        : UInt,
                                                v1        : UInt,
                                                v2        : UInt,
                                                v3        : UInt) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_1fv = glProgramUniform1fv(program   : UInt,
                                                location  : Int,
                                                count     : Sizei,
                                                value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_2fv = glProgramUniform2fv(program   : UInt,
                                                location  : Int,
                                                count     : Sizei,
                                                value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_3fv = glProgramUniform3fv(program   : UInt,
                                                location  : Int,
                                                count     : Sizei,
                                                value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_4fv = glProgramUniform4fv(program   : UInt,
                                                location  : Int,
                                                count     : Sizei,
                                                value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_1iv = glProgramUniform1iv(program   : UInt,
                                                location  : Int,
                                                count     : Sizei,
                                                value     : Pointer(Int)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_2iv = glProgramUniform2iv(program   : UInt,
                                                location  : Int,
                                                count     : Sizei,
                                                value     : Pointer(Int)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_3iv = glProgramUniform3iv(program   : UInt,
                                                location  : Int,
                                                count     : Sizei,
                                                value     : Pointer(Int)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_4iv = glProgramUniform4iv(program   : UInt,
                                                location  : Int,
                                                count     : Sizei,
                                                value     : Pointer(Int)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_1uiv = glProgramUniform1uiv(program   : UInt,
                                                  location  : Int,
                                                  count     : Sizei,
                                                  value     : Pointer(UInt)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_2uiv = glProgramUniform2uiv(program   : UInt,
                                                  location  : Int,
                                                  count     : Sizei,
                                                  value     : Pointer(UInt)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_3uiv = glProgramUniform3uiv(program   : UInt,
                                                  location  : Int,
                                                  count     : Sizei,
                                                  value     : Pointer(UInt)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_4uiv = glProgramUniform4uiv(program   : UInt,
                                                  location  : Int,
                                                  count     : Sizei,
                                                  value     : Pointer(UInt)) : Void
  
  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_2fv = glProgramUniformMatrix2fv( program   : UInt,
                                                              location  : Int,
                                                              count     : Sizei,
                                                              transpose : Boolean,
                                                              value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_3fv = glProgramUniformMatrix3fv( program   : UInt,
                                                              location  : Int,
                                                              count     : Sizei,
                                                              transpose : Boolean,
                                                              value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_4fv = glProgramUniformMatrix4fv( program   : UInt,
                                                              location  : Int,
                                                              count     : Sizei,
                                                              transpose : Boolean,
                                                              value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_2x3fv = glProgramUniformMatrix2x3fv( program   : UInt,
                                                                  location  : Int,
                                                                  count     : Sizei,
                                                                  transpose : Boolean,
                                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_3x2fv = glProgramUniformMatrix3x2fv( program   : UInt,
                                                                  location  : Int,
                                                                  count     : Sizei,
                                                                  transpose : Boolean,
                                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_2x4fv = glProgramUniformMatrix2x4fv( program   : UInt,
                                                                  location  : Int,
                                                                  count     : Sizei,
                                                                  transpose : Boolean,
                                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_4x2fv = glProgramUniformMatrix4x2fv( program   : UInt,
                                                                  location  : Int,
                                                                  count     : Sizei,
                                                                  transpose : Boolean,
                                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_3x4fv = glProgramUniformMatrix3x4fv( program   : UInt,
                                                                  location  : Int,
                                                                  count     : Sizei,
                                                                  transpose : Boolean,
                                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for a specified program object.
  fun program_uniform_matrix_4x3fv = glProgramUniformMatrix4x3fv( program   : UInt,
                                                                  location  : Int,
                                                                  count     : Sizei,
                                                                  transpose : Boolean,
                                                                  value     : Pointer(Float)) : Void

  # Specifies the vertex to be used as the source of data for flat shaded varings.
  fun provoking_vertex = glProvokingVertex(provoke_mode : Enum) : Void

  # Pushes a named debug group into the command stream.
  fun push_debug_group = glPushDebugGroup(source  : Enum,
                                          id      : UInt,
                                          length  : Sizei,
                                          message : Pointer(Char)) : Void
end