lib LibGL
  # Attaches the storage for a buffer object to the active buffer texture.
  fun tex_buffer = glTexBuffer( target          : Enum,
                                internal_format : Enum,
                                buffer          : UInt) : Void

  # Binds a range of a buffer's data store to a buffer texture.
  fun tex_buffer_range = glTexBufferRange(target          : Enum,
                                          internal_format : Enum,
                                          buffer          : UInt,
                                          offset          : IntPtr,
                                          size            : SizeiPtr) : Void

  # Specifies a one-dimensional texture image.
  fun tex_image_1d = glTexImage1D(target          : Enum,
                                  level           : Int,
                                  internal_format : Int,
                                  width           : Sizei,
                                  border          : Int,
                                  format          : Enum,
                                  data_type       : Enum,
                                  data            : Pointer(Void)) : Void

  # Specifies a two-dimensional texture image.
  fun tex_image_2d = glTexImage2D(target          : Enum,
                                  level           : Int,
                                  internal_format : Int,
                                  width           : Sizei,
                                  height          : Sizei,
                                  border          : Int,
                                  format          : Enum,
                                  data_type       : Enum,
                                  data            : Pointer(Void)) : Void

  # Establishes the data storage, format, dimensions, and number of samples of a multisample texture's image.
  fun tex_image_2d_multisample = glTexImage2DMultisample( target                  : Enum,
                                                          samples                 : Sizei,
                                                          internal_format         : Int,
                                                          width                   : Sizei,
                                                          height                  : Sizei,
                                                          fixed_sample_locations  : Boolean) : Void

  # Specifies a three-dimensional texture image.
  fun tex_image_3d = glTexImage3D(target          : Enum,
                                  level           : Int,
                                  internal_format : Int,
                                  width           : Sizei,
                                  height          : Sizei,
                                  depth           : Sizei,
                                  border          : Int,
                                  format          : Enum,
                                  data_type       : Enum,
                                  data            : Pointer(Void)) : Void
  
  # Establishes the data storage, format, dimensions, and number of samples of a multisample texture's image.
  fun tex_image_3d_multisample = glTexImage3DMultisample( target                  : Enum,
                                                          samples                 : Sizei,
                                                          internal_format         : Int,
                                                          width                   : Sizei,
                                                          height                  : Sizei,
                                                          depth                   : Sizei,
                                                          fixed_sample_locations  : Boolean) : Void

  # Sets texture parameters.
  fun tex_parameter_f = glTexParameterf(target  : Enum,
                                        p_name  : Enum,
                                        param   : Float) : Void

  # Sets texture parameters.
  fun tex_parameter_i = glTexParameteri(target  : Enum,
                                        p_name  : Enum,
                                        param   : Int) : Void

  # Sets texture parameters.
  fun tex_parameter_fv = glTexParameterfv(target  : Enum,
                                          p_name  : Enum,
                                          params  : Pointer(Float)) : Void

  # Sets texture parameters.
  fun tex_parameter_iv = glTexParameteriv(target  : Enum,
                                          p_name  : Enum,
                                          params  : Pointer(Int)) : Void

  # Sets texture parameters.
  fun tex_parameter_iiv = glTexParameterIiv(target  : Enum,
                                            p_name  : Enum,
                                            params  : Pointer(Int)) : Void
  
  # Sets texture parameters.
  fun tex_parameter_iuiv = glTexParameterIuiv(target  : Enum,
                                              p_name  : Enum,
                                              params  : Pointer(UInt)) : Void

  # Simultaneously specify storage for all levels of a one-dimensional texture.
  fun tex_storage_1d = glTexStorage1D(target          : Enum,
                                      levels          : Sizei,
                                      internal_format : Enum,
                                      width           : Sizei) : Void

  # Simultaneously specify storage for all levels of a two-dimensional texture.
  fun tex_storage_2d = glTexStorage2D(target          : Enum,
                                      levels          : Sizei,
                                      internal_format : Enum,
                                      width           : Sizei,
                                      height          : Sizei) : Void
  
  # Specifies storage for a two-dimensional multisample texture.
  fun tex_storage_2d_multisample = glTexStorage2DMultisample( target                  : Enum,
                                                              samples                 : Sizei,
                                                              internal_format         : Enum,
                                                              width                   : Sizei,
                                                              height                  : Sizei,
                                                              fixed_sample_locations  : Boolean) : Void

  # Simultaneously specify storage for all levels of a three-dimensional texture.
  fun tex_storage_3d = glTexStorage3D(target          : Enum,
                                      levels          : Sizei,
                                      internal_format : Enum,
                                      width           : Sizei,
                                      height          : Sizei,
                                      depth           : Sizei) : Void
  
  # Specifies storage for a three-dimensional multisample texture.
  fun tex_storage_3d_multisample = glTexStorage3DMultisample( target                  : Enum,
                                                              samples                 : Sizei,
                                                              internal_format         : Enum,
                                                              width                   : Sizei,
                                                              height                  : Sizei,
                                                              depth                   : Sizei,
                                                              fixed_sample_locations  : Boolean) : Void

  # Specifies a one-dimensional texture subimage.
  fun tex_sub_image_1d = glTexSubImage1D( target    : Enum,
                                          level     : Int,
                                          x_offset  : Int,
                                          width     : Sizei,
                                          format    : Enum,
                                          data_type : Enum,
                                          data      : Pointer(Void)) : Void

  # Specifies a two-dimensional texture subimage.
  fun tex_sub_image_2d = glTexSubImage2D( target    : Enum,
                                          level     : Int,
                                          x_offset  : Int,
                                          y_offset  : Int,
                                          width     : Sizei,
                                          height    : Sizei,
                                          format    : Enum,
                                          data_type : Enum,
                                          data      : Pointer(Void)) : Void

  # Specifies a three-dimensional texture subimage.
  fun tex_sub_image_3d = glTexSubImage3D( target    : Enum,
                                          level     : Int,
                                          x_offset  : Int,
                                          y_offset  : Int,
                                          z_offset  : Int,
                                          width     : Sizei,
                                          height    : Sizei,
                                          depth     : Sizei,
                                          format    : Enum,
                                          data_type : Enum,
                                          data      : Pointer(Void)) : Void

  # Initializes a texture as a data alias of another texture's data store.
  fun texture_view = glTextureView( texture         : UInt,
                                    target          : Enum,
                                    orig_texture    : UInt,
                                    internal_format : Enum,
                                    min_level       : UInt,
                                    num_levels      : UInt,
                                    min_layer       : UInt,
                                    num_layers      : UInt) : Void

  # Specifies values to record in transform feedback buffers.
  fun transform_feedback_varyings = glTransformFeedbackVaryings(program     : UInt,
                                                                count       : Sizei,
                                                                varyings    : Pointer(Pointer(Char)),
                                                                buffer_mode : Enum) : Void
end