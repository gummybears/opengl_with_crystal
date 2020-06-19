lib LibGL
  # Specifies the value of a uniform variable for the current program object.
  fun uniform_1f = glUniform1f(location  : Int,
                              v0        : Float) : Void
                                
  # Specifies the value of a uniform variable for the current program object.
  fun uniform_2f = glUniform2f(location  : Int,
                              v0        : Float,
                              v1        : Float) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_3f = glUniform3f(location  : Int,
                              v0        : Float,
                              v1        : Float,
                              v2        : Float) : Void
                                
  # Specifies the value of a uniform variable for the current program object.
  fun uniform_4f = glUniform4f(location  : Int,
                              v0        : Float,
                              v1        : Float,
                              v2        : Float,
                              v3        : Float) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_1i = glUniform1i( location  : Int,
                                v0        : Int) : Void
                                
  # Specifies the value of a uniform variable for the current program object.
  fun uniform_2i = glUniform2i( location  : Int,
                                v0        : Int,
                                v1        : Int) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_3i = glUniform3i( location  : Int,
                                v0        : Int,
                                v1        : Int,
                                v2        : Int) : Void
                                
  # Specifies the value of a uniform variable for the current program object.
  fun uniform_4i = glUniform4i( location  : Int,
                                v0        : Int,
                                v1        : Int,
                                v2        : Int,
                                v3        : Int) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_1ui = glUniform1ui( location  : Int,
                                  v0        : UInt) : Void
                                
  # Specifies the value of a uniform variable for the current program object.
  fun uniform_2ui = glUniform2ui( location  : Int,
                                  v0        : UInt,
                                  v1        : UInt) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_3ui = glUniform3ui( location  : Int,
                                  v0        : UInt,
                                  v1        : UInt,
                                  v2        : UInt) : Void
                                
  # Specifies the value of a uniform variable for the current program object.
  fun uniform_4ui = glUniform4ui( location  : Int,
                                  v0        : UInt,
                                  v1        : UInt,
                                  v2        : UInt,
                                  v3        : UInt) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_1fv = glUniform1fv( location  : Int,
                                  count     : Sizei,
                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_2fv = glUniform2fv( location  : Int,
                                  count     : Sizei,
                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_3fv = glUniform3fv( location  : Int,
                                  count     : Sizei,
                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_4fv = glUniform4fv( location  : Int,
                                  count     : Sizei,
                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_1iv = glUniform1iv( location  : Int,
                                  count     : Sizei,
                                  value     : Pointer(Int)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_2iv = glUniform2iv( location  : Int,
                                  count     : Sizei,
                                  value     : Pointer(Int)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_3iv = glUniform3iv( location  : Int,
                                  count     : Sizei,
                                  value     : Pointer(Int)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_4iv = glUniform4iv( location  : Int,
                                  count     : Sizei,
                                  value     : Pointer(Int)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_1uiv = glUniform1uiv( location  : Int,
                                    count     : Sizei,
                                    value     : Pointer(UInt)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_2uiv = glUniform2uiv( location  : Int,
                                    count     : Sizei,
                                    value     : Pointer(UInt)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_3uiv = glUniform3uiv( location  : Int,
                                    count     : Sizei,
                                    value     : Pointer(UInt)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_4uiv = glUniform4uiv( location  : Int,
                                    count     : Sizei,
                                    value     : Pointer(UInt)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_2fv = glUniformMatrix2fv(location  : Int,
                                              count     : Sizei,
                                              transpose : Boolean,
                                              value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_3fv = glUniformMatrix3fv(location  : Int,
                                              count     : Sizei,
                                              transpose : Boolean,
                                              value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_4fv = glUniformMatrix4fv(location  : Int,
                                              count     : Sizei,
                                              transpose : Boolean,
                                              value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_2x3fv = glUniformMatrix2x3fv(location  : Int,
                                                  count     : Sizei,
                                                  transpose : Boolean,
                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_3x2fv = glUniformMatrix3x2fv(location  : Int,
                                                  count     : Sizei,
                                                  transpose : Boolean,
                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_2x4fv = glUniformMatrix2x4fv(location  : Int,
                                                  count     : Sizei,
                                                  transpose : Boolean,
                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_4x2fv = glUniformMatrix4x2fv(location  : Int,
                                                  count     : Sizei,
                                                  transpose : Boolean,
                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_3x4fv = glUniformMatrix3x4fv(location  : Int,
                                                  count     : Sizei,
                                                  transpose : Boolean,
                                                  value     : Pointer(Float)) : Void

  # Specifies the value of a uniform variable for the current program object.
  fun uniform_matrix_4x3fv = glUniformMatrix4x3fv(location  : Int,
                                                  count     : Sizei,
                                                  transpose : Boolean,
                                                  value     : Pointer(Float)) : Void

  # Assigns a binding point to an active uniform block.
  fun uniform_block_binding = glUniformBlockBinding(program               : UInt,
                                                    uniform_block_index   : UInt,
                                                    uniform_block_binding : UInt) : Void

  # Loads active subroutine uniforms.
  fun uniform_subroutines_uiv = glUniformSubroutinesuiv(shader_type : Enum,
                                                        count       : Sizei,
                                                        indices     : Pointer(UInt)) : Void

  # Unmaps a buffer object's data store.
  fun unmap_buffer = glUnmapBuffer(target : Enum) : Boolean 

  # Installs a program object as part of current rendering state.
  fun use_program = glUseProgram(program : UInt) : Void

  # Binds stages of a program object to a program pipeline.
  fun use_program_stages = glUseProgramStages(pipeline  : UInt,
                                              stages    : Bitfield,
                                              program   : UInt) : Void
end