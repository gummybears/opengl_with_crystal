lib LibGL
  # Invalidates the content of a buffer object's data store.
  fun invalidate_buffer_data = glInvalidateBufferData(buffer : UInt) : Void

  # Invalidates a region of a buffer object's data store.
  fun invalidate_buffer_sub_data = glInvalidateBufferSubData( buffer  : UInt,
                                                              offset  : IntPtr,
                                                              length  : SizeiPtr) : Void

  # Invalidates the content some or all of a framebuffer object's attachments.
  fun invalidate_framebuffer = glInvalidateFramebuffer( target          : Enum,
                                                        num_attachments : Sizei,
                                                        attachments     : Pointer(Enum)) : Void

  # Invalidates the content of a region of some or all of a framebuffer object's attachments.
  fun invalidate_sub_framebuffer = glInvalidateSubFramebuffer(target          : Enum,
                                                              num_attachments : Sizei,
                                                              attachments     : Pointer(Enum),
                                                              x               : Int,
                                                              y               : Int,
                                                              width           : Int,
                                                              height          : Int) : Void

  # Invalidates the entirety of a texture image.
  fun invalidate_tex_image = glInvalidateTexImage(texture : UInt,
                                                  level   : Int) : Void

  # Invalidates a region of a texture image.
  fun invalidate_tex_sub_image = glInvalidateTexSubImage( texture   : UInt,
                                                          level     : Int,
                                                          x_offset  : Int,
                                                          y_offset  : Int,
                                                          z_offset  : Int,
                                                          width     : Sizei,
                                                          height    : Sizei,
                                                          depth     : Sizei) : Void

  # Determines if a name corresponds to a buffer object.
  fun is_buffer = glIsBuffer(buffer : UInt) : Boolean 

  # Tests whether a capability is enabled.
  fun is_enabled = glIsEnabled(cap : Enum) : Boolean 

  # Tests whether a capability is enabled.
  fun is_enabled_i = glIsEnabledi(cap   : Enum,
                                  index : UInt) : Boolean 

  # Determines if a name corresponds to a framebuffer object.
  fun is_framebuffer = glIsFramebuffer(framebuffer : UInt) : Boolean 

  # Determines if a name corresponds to a program object.
  fun is_program = glIsProgram(program : UInt) : Boolean 

  # Determines if a name corresponds to a program pipeline object.
  fun is_program_pipeline = glIsProgramPipeline(pipeline : UInt) : Boolean 

  # Determines if a name corresponds to a query object.
  fun is_query = glIsQuery(id : UInt) : Boolean

  # Determines if a name corresponds to a renderbuffer object.
  fun is_renderbuffer = glIsRenderbuffer(renderbuffer : UInt) : Boolean

  # Determines is a name corresponds to a sampler object.
  fun is_sampler = glIsSampler(id : UInt) : Boolean

  # Determines if a name corresponds to a shader object.
  fun is_shader = glIsShader(shader : UInt) : Boolean

  # Determines if a name corresponds to a sync object.
  fun is_sync = glIsSync(sync : Sync) : Boolean

  # Determines if a name corresponds to a texture.
  fun is_texture = glIsTexture(texture : UInt) : Boolean

  # Determines if a name corresponds to a transform feedback object.
  fun is_transform_feedback = glIsTransformFeedback(id : UInt) : Boolean

  # Determines if a name corresponds to a vertex array object.
  fun is_vertex_array = glIsVertexArray(array : UInt) : Boolean
end