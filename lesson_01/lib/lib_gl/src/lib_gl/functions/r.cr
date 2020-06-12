lib LibGL
  # Selects a color buffer source for pixel read operations from the current read framebuffer.
  fun read_buffer = glReadBuffer(mode : Enum) : Void

  # Reads a block of pixels from the frame buffer.
  fun read_pixels = glReadPixels( x         : Int,
                                  y         : Int,
                                  width     : Sizei,
                                  height    : Sizei,
                                  format    : Enum,
                                  data_type : Enum,
                                  data      : Pointer(Void)) : Void

  # Releases resources consumed by the implementation's shader compiler.
  fun release_shader_compiler = glReleaseShaderCompiler : Void

  # Establishes data storage, format and dimensions of a renderbuffer object's image.
  fun renderbuffer_storage = glRenderbufferStorage( target          : Enum,
                                                    internal_format : Sizei,
                                                    width           : Sizei,
                                                    height          : Sizei) : Void

  # Establishes data storage, format, dimensions, and sample count of a renderbuffer object's image.
  fun renderbuffer_storage_multisample = glRenderbufferStorageMultisample(target          : Enum,
                                                                          samples         : Sizei,
                                                                          internal_format : Enum,
                                                                          width           : Sizei,
                                                                          height          : Sizei) : Void

  # Resumes transform feedback operations.
  fun resume_transform_feedback = glResumeTransformFeedback : Void
end