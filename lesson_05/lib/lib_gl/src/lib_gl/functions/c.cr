lib LibGL

  fun color3f = glColor3f(red : LibC::Float, green : LibC::Float, blue : LibC::Float) : Void

  # Checks the completeness status of a framebuffer.
  fun check_framebuffer_status = glCheckFramebufferStatus(target : Enum) : Enum

  # Specifies whether data read via `read_pixels` should be clamped.
  fun clamp_color = glClampColor( target  : Enum,
                                  clamp   : Enum) : Void

  # Clears buffers to preset values.
  fun clear = glClear(mask : Bitfield) : Void

  # Clears individual buffers of the currently bound draw framebuffer.
  fun clear_buffer_iv = glClearBufferiv(buffer      : Enum,
                                        draw_buffer : Int,
                                        value       : Pointer(Int)) : Void

  # Clears individual buffers of the currently bound draw framebuffer.
  fun clear_buffer_uiv = glClearBufferuiv(buffer      : Enum,
                                          draw_buffer : Int,
                                          value       : Pointer(UInt)) : Void

  # Clears individual buffers of the currently bound draw framebuffer.
  fun clear_buffer_fv = glClearBufferfv(buffer      : Enum,
                                        draw_buffer : Int,
                                        value       : Pointer(Float)) : Void

  # Clears individual buffers of the currently bound draw framebuffer.
  fun clear_buffer_fi = glClearBufferfi(buffer      : Enum,
                                        draw_buffer : Int,
                                        depth       : Float,
                                        stencil     : Int) : Void

  # Fills a buffer object's data store with a fixed value.
  fun clear_buffer_data = glClearBufferData(target          : Enum,
                                            internal_format : Enum,
                                            format          : Enum,
                                            data_type       : Enum,
                                            data            : Pointer(Void)) : Void

  # Fills all or part of a buffer object's data store with a fixed value.
  fun clear_buffer_sub_data = glClearBufferSubData( target          : Enum,
                                                    internal_format : Enum,
                                                    offset          : IntPtr,
                                                    size            : SizeiPtr,
                                                    format          : Enum,
                                                    data_type       : Enum,
                                                    data            : Pointer(Void)) : Void

  # Specifies clear values for the color buffers.
  fun clear_color = glClearColor( red   : Float,
                                  green : Float,
                                  blue  : Float,
                                  alpha : Float) : Void

  # Specifies the clear value for the depth buffer.
  fun clear_depth = glClearDepth(depth : Double) : Void

  # Specifies the clear value for the depth buffer.
  fun clear_depth_f = glClearDepthf(depth : Float) : Void

  # Specifies the clear value for the stencil buffer.
  fun clear_stencil = glClearStencil(s : Int) : Void

  # Fills all of a texture image with a constant value.
  fun clear_tex_image = glClearTexImage(texture   : UInt,
                                        level     : Int,
                                        format    : Enum,
                                        data_type : Enum,
                                        data      : Pointer(Void)) : Void

  # Fills all or part of a texture image with a constant value.
  fun clear_tex_sub_image = glClearTexSubImage( texture   : UInt,
                                                level     : Int,
                                                x_offset  : Int,
                                                y_offset  : Int,
                                                z_offset  : Int,
                                                width     : SizeiPtr,
                                                height    : SizeiPtr,
                                                depth     : SizeiPtr,
                                                format    : Enum,
                                                data_type : Enum,
                                                data      : Pointer(Void)) : Void

  # Blocks and waits for a sync object to become signaled.
  fun client_wait_sync = glClientWaitSync(sync    : Sync,
                                          flags   : Bitfield,
                                          timeout : ULong) : Enum

  # Enables and disables writing of framebuffer color components.
  fun color_mask = glColorMask( red   : Boolean,
                                green : Boolean,
                                blue  : Boolean,
                                alpha : Boolean) : Void

  # Enables and disables writing of framebuffer color components.
  fun color_mask_i = glColorMaski(buf   : UInt,
                                  red   : Boolean,
                                  green : Boolean,
                                  blue  : Boolean,
                                  alpha : Boolean) : Void

  # Compiles a shader object.
  fun compile_shader = glCompileShader(shader : UInt) : Void

  # Specifies a texture image in a compressed format.
  fun compressed_tex_image_1d = glCompressedTexImage1D( target          : Enum,
                                                        level           : Int,
                                                        internal_format : Enum,
                                                        width           : Sizei,
                                                        border          : Int,
                                                        image_size      : Sizei,
                                                        data            : Pointer(Void)) : Void

  # Specifies a texture image in a compressed format.
  fun compressed_tex_image_2d = glCompressedTexImage2D( target          : Enum,
                                                        level           : Int,
                                                        internal_format : Enum,
                                                        width           : Sizei,
                                                        height          : Sizei,
                                                        border          : Int,
                                                        image_size      : Sizei,
                                                        data            : Pointer(Void)) : Void

  # Specifies a texture image in a compressed format.
  fun compressed_tex_image_3d = glCompressedTexImage3D( target          : Enum,
                                                        level           : Int,
                                                        internal_format : Enum,
                                                        width           : Sizei,
                                                        height          : Sizei,
                                                        depth           : Sizei,
                                                        border          : Int,
                                                        image_size      : Sizei,
                                                        data            : Pointer(Void)) : Void

  # Specifies a texture subimage in a compressed format.
  fun compressed_tex_sub_image_1d = glCompressedTexSubImage1D(target      : Enum,
                                                              level       : Int,
                                                              x_offset    : Int,
                                                              width       : Sizei,
                                                              format      : Enum,
                                                              image_size  : Sizei,
                                                              data        : Pointer(Void)) : Void

  # Specifies a texture subimage in a compressed format.
  fun compressed_tex_sub_image_2d = glCompressedTexSubImage2D(target      : Enum,
                                                              level       : Int,
                                                              x_offset    : Int,
                                                              y_offset    : Int,
                                                              width       : Sizei,
                                                              height      : Sizei,
                                                              format      : Enum,
                                                              image_size  : Sizei,
                                                              data        : Pointer(Void)) : Void

  # Specifies a texture subimage in a compressed format.
  fun compressed_tex_sub_image_3d = glCompressedTexSubImage3D(target      : Enum,
                                                              level       : Int,
                                                              x_offset    : Int,
                                                              y_offset    : Int,
                                                              z_offset    : Int,
                                                              width       : Sizei,
                                                              height      : Sizei,
                                                              depth       : Sizei,
                                                              format      : Enum,
                                                              image_size  : Sizei,
                                                              data        : Pointer(Void)) : Void

  # Copies part of the data store of a buffer object to the data store of another buffer object.
  fun copy_buffer_sub_data = glCopyBufferSubData( read_target   : Enum,
                                                  write_target  : Enum,
                                                  read_offset   : IntPtr,
                                                  write_offset  : IntPtr,
                                                  size          : SizeiPtr) : Void

  # Performs a raw data copy between two images.
  fun copy_image_sub_data = glCopyImageSubData( src_name    : UInt,
                                                src_target  : Enum,
                                                src_level   : Int,
                                                src_x       : Int,
                                                src_y       : Int,
                                                src_z       : Int,
                                                dst_name    : UInt,
                                                dst_target  : Enum,
                                                dst_level   : Int,
                                                dst_x       : Int,
                                                dst_y       : Int,
                                                dst_z       : Int,
                                                src_width   : Sizei,
                                                src_height  : Sizei,
                                                src_depth   : Sizei) : Void

  # Copies pixels into a texture image.
  fun copy_tex_image_1d = glCopyTexImage1D( target          : Enum,
                                            level           : Int,
                                            internal_format : Enum,
                                            x               : Int,
                                            y               : Int,
                                            width           : Sizei,
                                            border          : Int) : Void

  # Copies pixels into a texture image.
  fun copy_tex_image_2d = glCopyTexImage2D( target          : Enum,
                                            level           : Int,
                                            internal_format : Enum,
                                            x               : Int,
                                            y               : Int,
                                            width           : Sizei,
                                            height          : Sizei,
                                            border          : Int) : Void

  # Copies a texture subimage.
  fun copy_tex_sub_image_1d = glCopyTexSubImage1D(target    : Enum,
                                                  level     : Int,
                                                  x_offset  : Int,
                                                  x         : Int,
                                                  y         : Int,
                                                  width     : Sizei) : Void

  # Copies a texture subimage.
  fun copy_tex_sub_image_2d = glCopyTexSubImage2D(target    : Enum,
                                                  level     : Int,
                                                  x_offset  : Int,
                                                  y_offset  : Int,
                                                  x         : Int,
                                                  y         : Int,
                                                  width     : Sizei,
                                                  height    : Sizei) : Void

  # Copies a texture subimage.
  fun copy_tex_sub_image_3d = glCopyTexSubImage3D(target    : Enum,
                                                  level     : Int,
                                                  x_offset  : Int,
                                                  y_offset  : Int,
                                                  z_offset  : Int,
                                                  x         : Int,
                                                  y         : Int,
                                                  width     : Sizei,
                                                  height    : Sizei) : Void

  # Creates a program object.
  fun create_program = glCreateProgram : UInt

  # Creates a shader object.
  fun create_shader = glCreateShader(shader_type : Enum) : UInt

  # Creates a standalone program from an array of null-terminated source code strings.
  fun create_shader_program_v = glCreateShaderProgramv( shader_type : Enum,
                                                        count       : SizeiPtr,
                                                        strings     : Pointer(Pointer(Char))) : UInt

  # Specifies whether front or back facing facets can be culled.
  fun cull_face = glCullFace(mode : Enum) : Void
end
