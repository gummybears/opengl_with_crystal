lib LibGL
  # Specifies a callback to receive debugging messages from the GL.
  fun debug_message_callback = glDebugMessageCallback(callback    : Debugproc,
                                                      user_param  : Pointer(Void)) : Void

  # Controls the reporting of debug messages in a debug context.
  fun debug_message_control = glDebugMessageControl(source        : Enum,
                                                    message_type  : Enum,
                                                    severity      : Enum,
                                                    count         : Sizei,
                                                    ids           : Pointer(UInt),
                                                    enabled       : Boolean) : Void

  # Injects an application-supplied message into the debug message queue.
  fun debug_message_insert = glDebugMessageInsert(source        : Enum,
                                                  message_type  : Enum,
                                                  id            : UInt,
                                                  severity      : Enum,
                                                  length        : Sizei,
                                                  message       : Pointer(Char)) : Void

  # Deletes named buffer objects.
  fun delete_buffers = glDeleteBuffers( n       : Sizei,
                                        buffers : Pointer(UInt)) : Void                                             

  # Deletes framebuffer objects.
  fun delete_framebuffers = glDeleteFramebuffers( n             : Sizei,
                                                  framebuffers  : Pointer(UInt)) : Void

  # Deletes a program object.
  fun delete_program = glDeleteProgram(program : UInt) : Void
  
  # Deletes program pipeline objects.
  fun delete_program_pipelines = glDeleteProgramPipelines(n         : Sizei,
                                                          pipelines : Pointer(UInt)) : Void

  # Deletes named query objects.
  fun delete_queries = glDeleteQueries( n   : Sizei,
                                        ids : Pointer(UInt)) : Void

  # Deletes renderbuffer objects.
  fun delete_renderbuffers = glDeleteRenderbuffers( n             : Sizei,
                                                    renderbuffers : Pointer(UInt)) : Void

  # Deletes named sampler objects.
  fun delete_samplers = glDeleteSamplers( n         : Sizei,
                                          samplers  : Pointer(UInt)) : Void

  # Deletes a shader object.
  fun delete_shader = glDeleteShader(shader : UInt) : Void

  # Deletes a sync object.
  fun delete_sync = glDeleteSync(sync : Sync) : Void

  # Deletes named textures.
  fun delete_textures = glDeleteTextures( n         : Sizei,
                                          textures  : Pointer(UInt)) : Void
                                
  # Deletes transform feedback objects.
  fun delete_transform_feedbacks = glDeleteTransformFeedbacks(n   : Sizei,
                                                              ids : Pointer(UInt)) : Void

  # Deletes vertex array objects.
  fun delete_vertex_arrays = glDeleteVertexArrays(n       : Sizei,
                                                  arrays  : Pointer(UInt)) : Void

  # Specifies the value used for depth buffer comparisons.
  fun depth_func = glDepthFunc(func : Enum) : Void
                                          
  # Enbales or disables writing into the depth buffer.
  fun depth_mask = glDepthMask(flag : Boolean) : Void

  # Specifies mapping of depth values from normalized device coordinates to window coordinates
  fun depth_range = glDepthRange( near_val : Double,
                                  far_val  : Double) : Void
 
  # Specifies mapping of depth values from normalized device coordinates to window coordinates
  fun depth_range_f = glDepthRangef(near_val  : Float,
                                    far_val   : Float) : Void

  # Specifies mapping of depth values from normalized device coordinates to window coordinates for a specified set of viewports.
  fun depth_range_array_v = glDepthRangeArrayv( first : UInt,
                                                count : Sizei,
                                                v     : Pointer(Double)) : Void

  # Specifies mapping of depth values from normalized device coordinates to window coordinates for a specified viewport.
  fun depth_range_indexed = glDepthRangeIndexed(index     : UInt,
                                                near_val  : Double,
                                                far_val   : Double) : Void

  # Detaches a shader object from a program object to which it is attached.
  fun detach_shader = glDetachShader( program : UInt,
                                      shader  : UInt) : Void

  # Disables server-side GL capabilities.
  fun disable = glDisable(cap : Enum) : Void
  
  # Disables server-side GL capabilities.
  fun disable_i = glDisablei( cap   : Enum,
                              index : UInt) : Void

  # Disables a generic vertex attribute array.
  fun disable_vertex_attrib_array = glDisableVertexAttribArray(index : UInt) : Void

  # Launches one or more compute work groups.
  fun dispatch_compute = glDispatchCompute( num_groups_x  : UInt,
                                            num_groups_y  : UInt,
                                            num_groups_z  : UInt) : Void

  # Launches one or more compute work groups using parameters stored in a buffer.
  fun dispatch_compute_indirect = glDispatchComputeIndirect(indirect : IntPtr) : Void

  # Renders primitives from array data.
  fun draw_arrays = glDrawArrays( mode  : Enum,
                                  first : Int,
                                  count : Sizei) : Void

  # Renders primitives from array data, taking parameters from memory.
  fun draw_arrays_indirect = glDrawArraysIndirect(mode      : Enum,
                                                  indirect  : Pointer(Void)) : Void

  # Draws multiple instances of a range of elements.
  fun draw_arrays_instanced = glDrawArraysInstanced(mode        : Enum,
                                                    first       : Int,
                                                    count       : Sizei,
                                                    prim_count  : Sizei) : Void

  # Draws multiple instances of a range of elements with offset applied to instanced attributes
  fun draw_arrays_instanced_base_instance = glDrawArraysInstancedBaseInstance(mode          : Enum,
                                                                              first         : Int,
                                                                              count         : Sizei,
                                                                              prim_count    : Sizei,
                                                                              base_instance : UInt) : Void

  # Specifies which color buffers are to be drawn into.
  fun draw_buffer = glDrawBuffer(mode : Enum) : Void

  # Specifies a list of color buffers to be drawn into.
  fun draw_buffers = glDrawBuffers( n     : Sizei,
                                    bufs  : Pointer(Enum)) : Void

  # Renders primitives from array data.
  fun draw_elements = glDrawElements( mode        : Enum,
                                      count       : Sizei,
                                      value_type  : Enum,
                                      indices     : Pointer(Void)) : Void

  # Renders primitives from array data with a per-element offset.
  fun draw_elements_base_vertex = glDrawElementsBaseVertex( mode        : Enum,
                                                            count       : Sizei,
                                                            value_type  : Enum,
                                                            indices     : Pointer(Void),
                                                            base_vertex : Int) : Void

  # Renders indexed primitives from array data, taking parameters from memory.
  fun draw_elements_indirect = glDrawElementsIndirect(mode      : Enum,
                                                      data_type : Enum,
                                                      indirect  : Pointer(Void)) : Void

  # Draws multiple instances of a set of elements.
  fun draw_elements_instanced = glDrawElementsInstanced(mode        : Enum,
                                                        count       : Sizei,
                                                        value_type  : Enum,
                                                        indices     : Pointer(Void),
                                                        prim_count  : Sizei) : Void
  
  # Draws multiple instances of a set of elements with offset applied to instanced attributes.
  fun draw_elements_instanced_base_instance = glDrawElementsInstancedBaseInstance(mode          : Enum,
                                                                                  count         : Sizei,
                                                                                  value_type    : Enum,
                                                                                  indices       : Pointer(Void),
                                                                                  prim_count    : Sizei,
                                                                                  base_instance : UInt) : Void

  # Renders multiple instances of a set of primitives from array data with a per-element offset
  fun draw_elements_instanced_base_vertex = glDrawElementsInstancedBaseVertex(mode        : Enum,
                                                                              count       : Sizei,
                                                                              value_type  : Enum,
                                                                              indices     : Pointer(Void),
                                                                              prim_count  : Sizei,
                                                                              base_vertex : Int) : Void

  # Renders multiple instances of a set of primitives from array data with a per-element offset.
  fun draw_elements_instanced_base_vertex_base_instance = glDrawElementsInstancedBaseVertexBaseInstance(mode          : Enum,
                                                                                                        count         : Sizei,
                                                                                                        value_type    : Enum,
                                                                                                        indices       : Pointer(Void),
                                                                                                        prim_count    : Sizei,
                                                                                                        base_vertex   : Int,
                                                                                                        base_instance : UInt) : Void
                                                                                                      
  # Renders primitives from array data.
  fun draw_range_elements = glDrawRangeElements(mode        : Enum,
                                                min         : UInt,
                                                max         : UInt,
                                                count       : Sizei,
                                                value_type  : Enum,
                                                indices     : Pointer(Void)) : Void

  # Renders primitives from array data with a per-element offset.
  fun draw_range_elements_base_vertex = glDrawRangeElementsBaseVertex(mode        : Enum,
                                                                      min         : UInt,
                                                                      max         : UInt,
                                                                      count       : Sizei,
                                                                      value_type  : Enum,
                                                                      indices     : Pointer(Void),
                                                                      base_vertex : Int) : Void

  # Renders primitives using a count derived from a transform feedback object.
  fun draw_transform_feedback = glDrawTransformFeedback(mode  : Enum,
                                                        id    : UInt) : Void

  # Renders multiple instances of primitives using a count derived from a transform feedback object.
  fun draw_transform_feedback_instanced = glDrawTransformFeedbackInstanced( mode            : Enum,
                                                                            id              : UInt,
                                                                            instance_count  : Sizei) : Void

  # Renders primitives using a count derived from a specified stream of a transform feedback object.
  fun draw_transform_feedback_stream = glDrawTransformFeedbackStream( mode    : Enum,
                                                                      id      : UInt,
                                                                      stream  : UInt) : Void

  # Renders multiple instances of primitives using a count derived from a specified stream of a transform feedback object.
  fun draw_transform_feedback_stream_instanced = glDrawTransformFeedbackStreamInstanced(mode            : Enum,
                                                                                        id              : UInt,
                                                                                        stream          : UInt,
                                                                                        instance_count  : Sizei) : Void
end