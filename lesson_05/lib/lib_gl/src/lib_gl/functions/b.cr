lib LibGL

  fun begin = glBegin(mode  : Enum) : Void

  # Begins conditional rendering.
  fun begin_conditional_render = glBeginConditionalRender(id    : UInt,
                                                          mode  : Enum) : Void
  # Delimits the boundaries of a query object.
  fun begin_query = glBeginQuery(target : Enum,
                                 id     : UInt) : Void

  # Delimits the bouundaries of a query object on an indexed target.
  fun begin_query_indexed = glBeginQueryIndexed(target  : Enum,
                                                index   : UInt,
                                                id      : UInt) : Void

  # Starts transform feedback operation.
  fun begin_transform_feedback = glBeginTransformFeedback(primitive_mode : Enum) : Void

  # Associates a generic vertex attribute index with a named attribute variable.
  fun bind_attrib_location = glBindAttribLocation(program : UInt,
                                                  index   : UInt,
                                                  name    : Pointer(Char)) : Void

  # Binds a named buffer object.
  fun bind_buffer = glBindBuffer(target : Enum,
                                 buffer : UInt) : Void

  # Binds a buffer object to an indexed buffer target.
  fun bind_buffer_base = glBindBufferBase(target  : Enum,
                                          index   : UInt,
                                          buffer  : UInt) : Void

  # Binds a range within a buffer object to an indexed buffer target.
  fun bind_buffer_range = glBindBufferRange(target  : Enum,
                                            index   : UInt,
                                            buffer  : UInt,
                                            offset  : IntPtr,
                                            size    : SizeiPtr) : Void

  # Binds one or more buffer objects to a sequence of indexed buffer targets.
  fun bind_buffers_base = glBindBuffersBase(target  : Enum,
                                            first   : UInt,
                                            count   : Sizei,
                                            buffers : Pointer(UInt)) : Void

  # Binds ranges of one or more buffer objects to a sequence of indexed buffer targets.
  fun bind_buffers_range = glBindBuffersRange(target  : Enum,
                                              first   : UInt,
                                              count   : Sizei,
                                              buffers : Pointer(UInt),
                                              offsets : Pointer(IntPtr),
                                              sizes   : Pointer(IntPtr)) : Void

  # Binds a user-defined varying out variable to a fragment shader color number.
  fun bind_frag_data_location = glBindFragDataLocation(program      : UInt,
                                                       color_number : UInt,
                                                       name         : Pointer(Char)) : Void

  # Binds a user-defined varying out variable to a fragment shader color number and index.
  fun bind_frag_data_location_indexed = glBindFragDataLocationIndexed(program       : UInt,
                                                                      color_number  : UInt,
                                                                      index         : UInt,
                                                                      name          : Pointer(Char)) : Void

  # Binds a framebuffer to a framebuffer target.
  fun bind_framebuffer = glBindFramebuffer( target      : Enum,
                                            framebuffer : UInt) : Void

  # Binds a level of a texture to an image unit.
  fun bind_image_texture = glBindImageTexture(unit    : UInt,
                                              texture : UInt,
                                              level   : Int,
                                              layered : Boolean,
                                              layer   : Int,
                                              access  : Enum,
                                              format  : Enum) : Void

  # Binds one or more named texture images to a sequence of consecutive image units.
  fun bind_image_textures = glBindImageTextures(first     : UInt,
                                                count     : Int,
                                                textures  : Pointer(UInt)) : Void

  # Binds a program pipeline to the current context.
  fun bind_program_pipeline = glBindProgramPipeline(pipeline : UInt) : Void

  # Binds a renderbuffer to a renderbuffer target.
  fun bind_renderbuffer = glBindRenderbuffer( target        : Enum,
                                              renderbuffer  : UInt) : Void

  # Binds a named sampler to a texturing target.
  fun bind_sampler = glBindSampler( unit    : UInt,
                                    sampler : UInt) : Void

  # Binds one or more named sampler objects to a sequence of consecutive sampler units.
  fun bind_samplers = glBindSamplers( first     : UInt,
                                      count     : Sizei,
                                      samplers  : Pointer(UInt)) : Void

  # Binds a named texture to a texturing target.
  fun bind_texture = glBindTexture( target  : Enum,
                                    texture : UInt) : Void

  # Binds one or more named textures to a sequence of consecutive texture units.
  fun bind_textures = glBindTextures( first     : UInt,
                                      count     : Sizei,
                                      textures  : Pointer(UInt)) : Void

  # Binds a transform feedback object.
  fun bind_transform_feedback = glBindTransformFeedback(target  : Enum,
                                                        id      : UInt) : Void

  # Binds a vertex array object.
  fun bind_vertex_array = glBindVertexArray(array : UInt) : Void

  # Binds a buffer to a vertex buffer bind point.
  fun bind_vertex_buffer = glBindVertexBuffer(binding_index : UInt,
                                              buffer        : UInt,
                                              offset        : IntPtr,
                                              stride        : Sizei) : Void

  # Binds one or more named buffer objects to a sequence of consecutive vertex buffer binding points.
  fun bind_vertex_buffers = glBindVertexBuffers(first   : UInt,
                                                count   : Sizei,
                                                buffers : Pointer(UInt),
                                                offsets : Pointer(IntPtr),
                                                strides : Pointer(Sizei)) : Void

  # Sets the blend color.
  fun blend_color = glBlendColor( red   : Float,
                                  green : Float,
                                  blue  : Float,
                                  alpha : Float) : Void

  # Sets the blend equation.
  fun blend_equation = glBlendEquation(mode : Enum) : Void

  # Sets the blend equation for the given draw buffer.
  fun blend_equation_i = glBlendEquationi(buf   : UInt,
                                          mode  : Enum) : Void

  # Sets the RGB blend equation and the alpha blend equation separately.
  fun blend_equation_separate = glBlendEquationSeparate(mode_rgb    : Enum,
                                                        mode_alpha  : Enum) : Void

  # Sets the RGB blend equation and the alpha blend equation separately for the given draw buffer.
  fun blend_equation_separate_i = glBlendEquationSeparatei( buf         : UInt,
                                                            mode_rgb    : Enum,
                                                            mode_alpha  : Enum) : Void

  # Specifies pixel arithmetic for RGB and Alpha components.
  fun blend_func = glBlendFunc( sfactor : Enum,
                                dfactor : Enum) : Void

  # Specifies pixel arithmetic for RGB and Alpha components for the given draw buffer.
  fun blend_func_i = glBlendFunci(buf     : UInt,
                                  sfactor : Enum,
                                  dfactor : Enum) : Void

  # Specifies pixel arithmetic for RGB and Alpha components separately.
  fun blend_func_separate = glBlendFuncSeparate(src_rgb   : Enum,
                                                dst_rgb   : Enum,
                                                src_alpha : Enum,
                                                dst_alpha : Enum) : Void

  # Specifies pixel arithmetic for RGB and Alpha components separately for the given draw buffer.
  fun blend_func_separate_i = glBlendFuncSeparatei( buf       : UInt,
                                                    src_rgb   : Enum,
                                                    dst_rgb   : Enum,
                                                    src_alpha : Enum,
                                                    dst_alpha : Enum) : Void

  # Copies a block of pixels from the read framebuffer to the draw framebuffer.
  fun blit_framebuffer = glBlitFramebuffer( src_x0  : Int,
                                            src_y0  : Int,
                                            src_x1  : Int,
                                            src_y1  : Int,
                                            dst_x0  : Int,
                                            dst_y0  : Int,
                                            dst_x1  : Int,
                                            dst_y1  : Int,
                                            mask    : Bitfield,
                                            filter  : Enum) : Void

  # Creates and initializes a buffer object's data store.
  fun buffer_data = glBufferData( target  : Enum,
                                  size    : SizeiPtr,
                                  data    : Pointer(Void),
                                  usage   : Enum) : Void

  # Creates and initializes a buffer object's immutable data store.
  fun buffer_storage = glBufferStorage( target  : Enum,
                                        size    : SizeiPtr,
                                        data    : Pointer(Void),
                                        flags   : Bitfield) : Void

  # Updates a subset of a buffer object's data store.
  fun buffer_sub_data = glBufferSubData(target  : Enum,
                                        offset  : IntPtr,
                                        size    : SizeiPtr,
                                        data    : Pointer(Void)) : Void
end
