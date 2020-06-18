lib LibGL

  # Creates a new sync object and inserts it into the GL command stream.
  fun fence_sync = glFenceSync( condition : Enum,
                                flags     : Bitfield) : Sync

  # Blocks until all GL execution is complete.
  fun finish = glFinish : Void

  # Forces execution of GL commands in finite time.
  fun flush = glFlush : Void

  # Indicates modifications to a range of a mapped buffer.
  fun flush_mapped_buffer_range = glFlushMappedBufferRange( target  : Enum,
                                                            offset  : IntPtr,
                                                            length  : SizeiPtr) : Void

  # Sets a named parameter of a framebuffer.
  fun framebuffer_parameter = glFramebufferParameteri(target  : Enum,
                                                      p_name  : Enum,
                                                      param   : Int) : Void

  # Attaches a renderbuffer as a logical buffer to the currently bound framebuffer object.
  fun framebuffer_renderbuffer = glFramebufferRenderbuffer( target              : Enum,
                                                            attachment          : Enum,
                                                            renderbuffer_target : Enum,
                                                            renderbuffer        : UInt) : Void

  # Attaches a level of a texture object as a logical buffer to the currently bound framebuffer object.
  fun framebuffer_texture = glFramebufferTexture( target      : Enum,
                                                  attachment  : Enum,
                                                  texture     : UInt,
                                                  level       : Int) : Void

  # Attaches a level of a texture object as a logical buffer to the currently bound framebuffer object.
  fun framebuffer_texture_1d = glFramebufferTexture1D(target      : Enum,
                                                      attachment  : Enum,
                                                      tex_target  : Enum,
                                                      texture     : UInt,
                                                      level       : Int) : Void

  # Attaches a level of a texture object as a logical buffer to the currently bound framebuffer object.
  fun framebuffer_texture_2d = glFramebufferTexture2D(target      : Enum,
                                                      attachment  : Enum,
                                                      tex_target  : Enum,
                                                      texture     : UInt,
                                                      level       : Int) : Void

  # Attaches a level of a texture object as a logical buffer to the currently bound framebuffer object.
  fun framebuffer_texture_3d = glFramebufferTexture3D(target      : Enum,
                                                      attachment  : Enum,
                                                      tex_target  : Enum,
                                                      texture     : UInt,
                                                      level       : Int,
                                                      layer       : Int) : Void

  # Attaches a single layer of a texture to a framebuffer.
  fun framebuffer_texture_layer = glFramebufferTextureLayer(target      : Enum,
                                                            attachment  : Enum,
                                                            texture     : UInt,
                                                            level       : Int,
                                                            layer       : Int) : Void

  # Defines front and back facing polygons.
  fun front_face = glFrontFace(mode : Enum) : Void
end