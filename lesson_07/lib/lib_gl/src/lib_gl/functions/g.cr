lib LibGL
  # Generates buffer object names.
  fun gen_buffers = glGenBuffers( n       : Sizei,
                                  buffers : Pointer(UInt)) : Void

  # Generates mipmaps for a specified texture target.
  fun generate_mipmap = glGenerateMipmap(target : Enum) : Void

  # Generates framebuffer object names.
  fun gen_framebuffers = glGenerateFramebuffers(n   : Sizei,
                                                ids : Pointer(UInt)) : Void

  # Reserves program pipeline object names.
  fun gen_program_pipelines = glGenProgramPipelines(n         : Sizei,
                                                    pipelines : Pointer(UInt)) : Void

  # Generates query object names.
  fun gen_queries = glGenQueries( n   : Sizei,
                                  ids : Pointer(UInt)) : Void

  fun gen_renderbuffers = glGenRenderbuffers( n               : Sizei,
                                              render_buffers  : Pointer(UInt)) : Void

  # Generates sampler object names.
  fun gen_samplers = glGenSamplers( n         : Sizei,
                                    samplers  : Pointer(UInt)) : Void

  # Generates texture names.
  fun gen_textures = glGenTextures( n         : Sizei,
                                    textures  : Pointer(UInt)) : Void

  # Reserves transform feedback object names.
  fun gen_transform_feedbacks = glGenTransformFeedbacks(n   : Sizei,
                                                        ids : Pointer(UInt)) : Void

  # Generates vertex array object names.
  fun gen_vertex_arrays = glGenVertexArrays(n       : Sizei,
                                            arrays  : Pointer(UInt)) : Void

  # Returns the value or values of a selected parameter.
  fun get_boolean_v = glGetBooleanv(p_name  : Enum,
                                    params  : Pointer(Boolean)) : Void

  # Returns the value or values of a selected parameter.
  fun get_double_v = glGetDoublev(p_name  : Enum,
                                  params  : Pointer(Double)) : Void

  # Returns the value or values of a selected parameter.
  fun get_float_v = glGetFloatv(p_name  : Enum,
                                params  : Pointer(Float)) : Void

  # Returns the value or values of a selected parameter.
  fun get_integer_v = glGetIntegerv(p_name  : Enum,
                                    params  : Pointer(Int)) : Void

  # Returns the value or values of a selected parameter.
  fun get_integer64_v = glGetInteger64v(p_name  : Enum,
                                        params  : Pointer(Long)) : Void

  # Returns the value or values of a selected parameter.
  fun get_boolean_iv = glGetBooleani_v( p_name  : Enum,
                                        index   : UInt,
                                        params  : Pointer(Boolean)) : Void

  # Returns the value or values of a selected parameter.
  fun get_double_iv = glGetDoublei_v( p_name  : Enum,
                                      index   : UInt,
                                      params  : Pointer(Double)) : Void

  # Returns the value or values of a selected parameter.
  fun get_float_iv = glGetFloati_v( p_name  : Enum,
                                    index   : UInt,
                                    params  : Pointer(Float)) : Void

  # Returns the value or values of a selected parameter.
  fun get_integer_iv = glGetIntegeri_v( p_name  : Enum,
                                        index   : UInt,
                                        params  : Pointer(Int)) : Void

  # Returns the value or values of a selected parameter.
  fun get_integer64_iv = glGetInteger64i_v( p_name  : Enum,
                                            index   : UInt,
                                            params  : Pointer(Long)) : Void

  # Retrieves information about the set of active atomic counter buffers for a program.
  fun get_active_atomic_counter_buffer_iv = glGetActiveAtomicCounterBufferiv( program       : UInt,
                                                                              buffer_index  : UInt,
                                                                              p_name        : Enum,
                                                                              params        : Pointer(Int)) : Void

  # Returns information about an active attribute variable for the specified program object.
  fun get_active_attrib = glGetActiveAttrib(program   : UInt,
                                            index     : UInt,
                                            buf_size  : Sizei,
                                            length    : Pointer(Sizei),
                                            size      : Pointer(Int),
                                            data_type : Pointer(Enum),
                                            name      : Pointer(Char)) : Void

  # Queries the name of an active shader subroutine.
  fun get_active_subroutine_name = glGetActiveSubroutineName( program     : UInt,
                                                              shader_type : Enum,
                                                              index       : UInt,
                                                              buf_size    : Sizei,
                                                              length      : Pointer(Sizei),
                                                              name        : Pointer(Char)) : Void

  # Queries the property of an active shader subroutine uniform.
  fun get_active_subroutine_uniform_iv = glGetActiveSubroutineUniformiv(program     : UInt,
                                                                        shader_type : Enum,
                                                                        index       : UInt,
                                                                        p_name      : Enum,
                                                                        values      : Pointer(Int)) : Void

  # Queries the name of an active shader subroutine uniform.
  fun get_active_subroutine_uniform_name = glGetActiveSubroutineUniformName(program     : UInt,
                                                                            shader_type : Enum,
                                                                            index       : UInt,
                                                                            buf_size    : Sizei,
                                                                            length      : Pointer(Sizei),
                                                                            name        : Pointer(Char)) : Void

  # Returns information about an active uniform variable for the specified program object.
  fun get_active_uniform = glGetActiveUniform(program   : UInt,
                                              index     : UInt,
                                              buf_size  : Sizei,
                                              length    : Pointer(Sizei),
                                              size      : Pointer(Int),
                                              data_type : Pointer(Enum),
                                              name      : Pointer(Char)) : Void

  # Queries information about an active uniform block.
  fun get_active_uniform_block_iv = glGetActiveUniformBlockiv(program             : UInt,
                                                              uniform_block_index : UInt,
                                                              p_name              : Enum,
                                                              params              : Pointer(Int)) : Void

  # Retrieves the name of an active uniform block.
  fun get_active_uniform_block_name = glGetActiveUniformBlockName(program             : UInt,
                                                                  uniform_block_index : UInt,
                                                                  buf_size            : Sizei,
                                                                  length              : Pointer(Sizei),
                                                                  uniform_block_name  : Pointer(Char)) : Void

  # Queries the name of an active uniform.
  fun get_active_uniform_name = glGetActiveUniformName( program       : UInt,
                                                        uniform_index : UInt,
                                                        buf_size      : Sizei,
                                                        length        : Pointer(Sizei),
                                                        uniform_name  : Pointer(Char)) : Void
  
  # Returns information about several active uniform variables for the specified program object.
  fun get_active_uniforms_iv = glGetActiveUniformsiv( program         : UInt,
                                                      uniform_count   : Sizei,
                                                      uniform_indices : Pointer(UInt),
                                                      p_name          : Enum,
                                                      params          : Pointer(Int)) : Void

  # Returns the handles of the shader objects attached to a program object.
  fun get_attached_shaders = glGetAttachedShaders(program   : UInt,
                                                  max_count : Sizei,
                                                  count     : Pointer(Sizei),
                                                  shaders   : Pointer(UInt)) : Void

  # Returns the location of an attribute variable.
  fun get_attrib_location = glGetAttribLocation(program : UInt,
                                                name    : Pointer(Char)) : Void

  # Returns parameters of a buffer object.
  fun get_buffer_parameter_iv = glGetBufferParameteriv( target  : Enum,
                                                        value   : Enum,
                                                        data    : Pointer(Int)) : Void

  # Returns parameters of a buffer object.
  fun get_buffer_parameter_i64v = glGetBufferParameteri64v( target  : Enum,
                                                            value   : Enum,
                                                            data    : Pointer(Long)) : Void
                                                        
  # Returns the pointer to a mapped buffer object's data store.
  fun get_buffer_pointer_v = glGetBufferPointerv( target  : Enum,
                                                  p_name  : Enum,
                                                  params  : Pointer(Pointer(Void))) : Void

  # Returns a subset of a buffer object's data store.
  fun get_buffer_sub_data = glGetBufferSubData( target  : Enum,
                                                offset  : IntPtr,
                                                size    : SizeiPtr,
                                                data    : Pointer(Void)) : Void

  # Returns a compressed texture image.
  fun get_compressed_tex_image = glGetCompressedTexImage( target  : Enum,
                                                          lod     : Int,
                                                          img     : Pointer(Void)) : Void

  # Retrieves messages from the debug message log.
  fun get_debug_message_log = glGetDebugMessageLog( count       : UInt,
                                                    buf_size    : Sizei,
                                                    sources     : Pointer(Enum),
                                                    types       : Pointer(Enum),
                                                    ids         : Pointer(UInt),
                                                    severities  : Pointer(Enum),
                                                    lengths     : Pointer(Sizei),
                                                    message_log : Pointer(Char)) : UInt

  # Returns error information.
  fun get_error = glGetError : Enum

  # Queries the bindings of color indices to user-defined varying out variables.
  fun get_frag_data_index = glGetFragDataIndex( program : UInt,
                                                name    : Pointer(Char)) : Int

  # Queries the bindings of color numbers to user-defined varying out variables.
  fun get_frag_data_location = glGetFragDataLocation( program : UInt,
                                                      name    : Pointer(Char)) : Int

  # Retrieves information about attachments of a bound framebuffer object.
  fun get_framebuffer_attachment_parameter_iv = glGetFramebufferAttachmentParameteriv(target      : Enum,
                                                                                      attachment  : Enum,
                                                                                      p_name      : Enum,
                                                                                      params      : Pointer(Int)) : Void

  # Retrieves a named parameter from a framebuffer.
  fun get_framebuffer_parameter_iv = glGetFramebufferParameteriv( target  : Enum,
                                                                  p_name  : Enum,
                                                                  params  : Pointer(Int)) : Void

  # Retrieves information about implementation-dependent support for internal formats.
  fun get_internal_format_iv = glGetInternalFormativ( target          : Enum,
                                                      internal_format : Enum,
                                                      p_name          : Enum,
                                                      buf_size        : Sizei,
                                                      params          : Pointer(Int)) : Void

  # Retrieves information about implementation-dependent support for internal formats.
  fun get_internal_format_i64v = glGetInternalFormati64v( target          : Enum,
                                                          internal_format : Enum,
                                                          p_name          : Enum,
                                                          buf_size        : Sizei,
                                                          params          : Pointer(Long)) : Void

  # Retrieves the location of a sample.
  fun get_multisample_fv = glGetMultisamplefv(p_name  : Enum,
                                              index   : UInt,
                                              val     : Pointer(Float)) : Void

  # Retrieves the label of a named object identified within a namespace.
  fun get_object_label = glGetObjectLabel(identifier  : Enum,
                                          name        : UInt,
                                          buf_size    : Sizei,
                                          length      : Pointer(Sizei),
                                          label       : Pointer(Char)) : Void

  # Retrieves the label of a sync object identified by a pointer.
  fun get_object_ptr_label = glGetObjectPtrLabel( ptr       : Pointer(Void),
                                                  buf_size  : Sizei,
                                                  length    : Pointer(Sizei),
                                                  label     : Pointer(Char)) : Void

  # Returns a parameter from a program object.
  fun get_program_iv = glGetProgramiv(program : UInt,
                                      p_name  : Enum,
                                      params  : Pointer(Int)) : Void

  # Returns a binary representation of a program object's compiled and linked executable source.
  fun get_program_binary = glGetProgramBinary(program       : UInt,
                                              buf_size      : Sizei,
                                              length        : Pointer(Sizei),
                                              binary_format : Pointer(Enum),
                                              binary        : Pointer(Void)) : Void

  # Returns the information log for a program object.
  fun get_program_info_log = glGetProgramInfoLog( program     : UInt,
                                                  max_length  : Sizei,
                                                  length      : Pointer(Sizei),
                                                  info_log    : Pointer(Char)) : Void
                                                
  # Queries a property of an interface in a program.
  fun get_program_interface_iv = glGetProgramInterfaceiv( program           : UInt,
                                                          program_interface : Enum,
                                                          p_name            : Enum,
                                                          params            : Pointer(Int)) : Void

  # Retrieves properties of a program pipeline object.
  fun get_program_pipeline_iv = glGetProgramPipelineiv( pipeline  : UInt,
                                                        p_name    : Enum,
                                                        params    : Pointer(Int)) : Void

  # Retrieves the info log string from a program pipeline object.
  fun get_program_pipeline_info_log = glGetProgramPipelineInfoLog(pipeline  : UInt,
                                                                  buf_size  : Sizei,
                                                                  length    : Pointer(Sizei),
                                                                  info_log  : Pointer(Char)) : Void

  # Retrieves values for multiple properties of a single active resource within a program object.
  fun get_program_resource_iv = glGetProgramResourceiv( program           : UInt,
                                                        program_interface : Enum,
                                                        index             : UInt,
                                                        prop_count        : Sizei,
                                                        props             : Pointer(Enum),
                                                        buf_size          : Sizei,
                                                        length            : Pointer(Sizei),
                                                        params            : Pointer(Int)) : Void

  # Queries the location of a named resource within a program.
  fun get_program_resource_location = glGetProgramResourceLocation( program           : UInt,
                                                                    program_interface : Enum,
                                                                    name              : Pointer(Char)) : Int
  
  # Queries the fragment color index of a named variable within a program.
  fun get_program_resource_location_index = glGetProgramResourceLocationIndex(program           : UInt,
                                                                              program_interface : Enum,
                                                                              name              : Pointer(Char)) : Int

  # Queries the index of a named resource within a program.
  fun get_program_resource_index = glGetProgramResourceIndex( program           : UInt,
                                                              program_interface : Enum,
                                                              name              : Pointer(Char)) : UInt

  # Queries the name of an indexed resource within a program.
  fun get_program_resource_name = glGetProgramResourceName( program           : UInt,
                                                            program_interface : Enum,
                                                            index             : UInt,
                                                            buf_size          : Sizei,
                                                            length            : Pointer(Sizei),
                                                            name              : Pointer(Char)) : Void

  # Retrieves properties of a program object corresponding to a specified shader stage.
  fun get_program_stage_iv = glGetProgramStageiv( program     : UInt,
                                                  shader_type : Enum,
                                                  p_name      : Enum,
                                                  values      : Pointer(Int)) : Void

  # Returns parameters of a query object target.
  fun get_query_iv = glGetQueryiv(target  : Enum,
                                  p_name  : Enum,
                                  params  : Pointer(Int)) : Void

  # Returns parameters of an indexed query object target.
  fun get_query_indexed_iv = glGetQueryIndexediv( target  : Enum,
                                                  index   : UInt,
                                                  p_name  : Enum,
                                                  params  : Pointer(Int)) : Void

  # Returns parameters of a query object.
  fun get_query_object_iv = glGetQueryObjectiv( id      : UInt,
                                                p_name  : Enum,
                                                params  : Pointer(Int)) : Void

  # Returns parameters of a query object.
  fun get_query_object_uiv = glGetQueryObjectuiv( id      : UInt,
                                                  p_name  : Enum,
                                                  params  : Pointer(UInt)) : Void

  # Returns parameters of a query object.
  fun get_query_object_i64v = glGetQueryObjecti64v( id      : UInt,
                                                    p_name  : Enum,
                                                    params  : Pointer(Long)) : Void

  # Returns parameters of a query object.
  fun get_query_object_ui64v = glGetQueryObjectui64v( id      : UInt,
                                                      p_name  : Enum,
                                                      params  : Pointer(ULong)) : Void

  # Retrieves information about a bound renderbuffer object.
  fun get_renderbuffer_parameter_iv = glGetRenderbufferParameteriv( target  : Enum,
                                                                    p_name  : Enum,
                                                                    params  : Pointer(Int)) : Void

  # Returns sampler parameter values.
  fun get_sampler_parameter_fv = glGetSamplerParameterfv( sampler : UInt,
                                                          p_name  : Enum,
                                                          params  : Pointer(Float)) : Void

  # Returns sampler parameter values.
  fun get_sampler_parameter_iv = glGetSamplerParameteriv( sampler : UInt,
                                                          p_name  : Enum,
                                                          params  : Pointer(Int)) : Void
  
  # Returns sampler parameter values.
  fun get_sampler_parameter_iiv = glGetSamplerParameterIiv( sampler : UInt,
                                                            p_name  : Enum,
                                                            params  : Pointer(Int)) : Void

  # Returns sampler parameter values.
  fun get_sampler_parameter_iuiv = glGetSamplerParameterIuiv( sampler : UInt,
                                                              p_name  : Enum,
                                                              params  : Pointer(UInt)) : Void

  # Returns a parameter from a shader object.
  fun get_shader_iv = glGetShaderiv(shader  : UInt,
                                    p_name  : Enum,
                                    params  : Pointer(Int)) : Void

  # Returns the information log for a shader object.
  fun get_shader_info_log = glGetShaderInfoLog( shader      : UInt,
                                                max_length  : Sizei,
                                                length      : Pointer(Sizei),
                                                info_log    : Pointer(Char)) : Void

  # Retrieves the range and precision for numeric formats supported by the shader compiler.
  fun get_shader_precision_format = glGetShaderPrecisionFormat( shader_type     : Enum,
                                                                precision_type  : Enum,
                                                                range           : Pointer(Int),
                                                                precision       : Pointer(Int)) : Void

  # Returns the source code string from a shader object.
  fun get_shader_source = glGetShaderSource(shader    : UInt,
                                            buf_size  : Sizei,
                                            length    : Pointer(Sizei),
                                            source    : Pointer(Char)) : Void

  # Returns a string describing the current GL connection.
  fun get_string = glGetString(name  : Enum) : Pointer(UByte)

  # Returns a string describing the current GL connection.
  fun get_string_i = glGetStringi(name  : Enum,
                                  index : UInt) : Pointer(UByte)

  # Retrieves the index of a subroutine uniform of a given shader stage within a program.
  fun get_subroutine_index = glGetSubroutineIndex(program     : UInt,
                                                  shader_type : Enum,
                                                  name        : Pointer(Char)) : UInt

  # Retrieves the location of a subroutine uniform of a given shader stage within a program.
  fun get_subroutine_uniform_location = glGetSubroutineUniformLocation( program     : UInt,
                                                                        shader_type : Enum,
                                                                        name        : Pointer(Char)) : Int

  # Queries the properties of a sync object.
  fun get_sync_iv = glGetSynciv(sync      : Sync,
                                p_name    : Enum,
                                buf_size  : Sizei,
                                length    : Pointer(Sizei),
                                values    : Pointer(Int)) : Void

  # Returns a texture image.
  fun get_tex_image = glGetTexImage(target      : Enum,
                                    level       : Int,
                                    format      : Enum,
                                    pixel_type  : Enum,
                                    img         : Pointer(Void))

  # Returns texture parameter values for a specific level of detail.
  fun get_tex_level_parameter_fv = glGetTexLevelParameterfv(target  : Enum,
                                                            level   : Int,
                                                            p_name  : Enum,
                                                            params  : Pointer(Float)) : Void

  # Returns texture parameter values for a specific level of detail.
  fun get_tex_level_parameter_iv = glGetTexLevelParameteriv(target  : Enum,
                                                            level   : Int,
                                                            p_name  : Enum,
                                                            params  : Pointer(Int)) : Void

  # Returns texture parameter values.
  fun get_tex_parameter_fv = glGetTexParameterfv( target  : Enum,
                                                  p_name  : Enum,
                                                  params  : Pointer(Float)) : Void

  # Returns texture parameter values.
  fun get_tex_parameter_iv = glGetTexParameteriv( target  : Enum,
                                                  p_name  : Enum,
                                                  params  : Pointer(Int)) : Void

  # Returns texture parameter values.
  fun get_tex_parameter_iiv = glGetTexParameterIiv( target  : Enum,
                                                    p_name  : Enum,
                                                    params  : Pointer(Int)) : Void

  # Returns texture parameter values.
  fun get_tex_parameter_iuiv = glGetTexParameterIuiv( target  : Enum,
                                                      p_name  : Enum,
                                                      params  : Pointer(UInt)) : Void

  # Retrieves information about varying variables selected for transform feedback.
  fun get_transform_feedback_varying = glGetTransformFeedbackVarying( program       : UInt,
                                                                      index         : UInt,
                                                                      buf_size      : Sizei,
                                                                      length        : Pointer(Sizei),
                                                                      size          : Sizei,
                                                                      varying_type  : Pointer(Enum),
                                                                      name          : Pointer(Char)) : Void

  # Returns the value of a uniform variable.
  fun get_uniform_fv = glGetUniformfv(program   : UInt,
                                      location  : Int,
                                      params    : Pointer(Float)) : Void

  # Returns the value of a uniform variable.
  fun get_uniform_iv = glGetUniformiv(program   : UInt,
                                      location  : Int,
                                      params    : Pointer(Int)) : Void

  # Returns the value of a uniform variable.
  fun get_uniform_uiv = glGetUniformuiv(program   : UInt,
                                        location  : Int,
                                        params    : Pointer(UInt)) : Void

  # Returns the value of a uniform variable.
  fun get_uniform_dv = glGetUniformdv(program   : UInt,
                                      location  : Int,
                                      params    : Pointer(Double)) : Void

  # Retrieves the index of a named uniform block.
  fun get_uniform_block_index = glGetUniformBlockIndex( program             : UInt,
                                                        uniform_block_name  : Pointer(Char)) : UInt

  # Retrieves the index of a named uniform block.
  fun get_uniform_indices = glGetUniformIndices(program         : UInt,
                                                uniform_count   : Sizei,
                                                uniform_names   : Pointer(Pointer(Char)),
                                                uniform_indices : Pointer(UInt)) : Void

  # Returns the location of a uniform variable.
  fun get_uniform_location = glGetUniformLocation(program : UInt,
                                                  name    : Pointer(Char)) : Int

  # Retrieves the value of a subroutine uniform of a given shader stage of the current program.
  fun get_uniform_subroutine_uiv = glGetUniformSubroutineuiv( shader_type : Enum,
                                                              location    : Int,
                                                              values      : Pointer(UInt)) : Void

  # Returns a generic vertex attribute parameter.
  fun get_vertex_attrib_dv = glGetVertexAttribdv( index   : UInt,
                                                  p_name  : Enum,
                                                  params  : Pointer(Double)) : Void

  # Returns a generic vertex attribute parameter.
  fun get_vertex_attrib_fv = glGetVertexAttribfv( index   : UInt,
                                                  p_name  : Enum,
                                                  params  : Pointer(Float)) : Void

  # Returns a generic vertex attribute parameter.
  fun get_vertex_attrib_iv = glGetVertexAttribiv( index   : UInt,
                                                  p_name  : Enum,
                                                  params  : Pointer(Int)) : Void

  # Returns a generic vertex attribute parameter.
  fun get_vertex_attrib_iiv = glGetVertexAttribIiv( index   : UInt,
                                                    p_name  : Enum,
                                                    params  : Pointer(Int)) : Void

  # Returns a generic vertex attribute parameter.
  fun get_vertex_attrib_iuiv = glGetVertexAttribIuiv( index   : UInt,
                                                      p_name  : Enum,
                                                      params  : Pointer(UInt)) : Void

  # Returns a generic vertex attribute parameter.
  fun get_vertex_attrib_ldv = glGetVertexAttribLdv( index   : UInt,
                                                    p_name  : Enum,
                                                    params  : Pointer(Double)) : Void

  # Returns the address of the specified generic vertex attribute pointer.
  fun get_vertex_attrib_pointer_v = glGetVertexAttribPointerv(index   : UInt,
                                                              p_name  : Enum,
                                                              pointer : Pointer(Pointer(Void))) : Void
end