lib LibGL
  # Maps a buffer object's data store.
  fun map_buffer = glMapBuffer( target  : Enum,
                                access  : Enum) : Pointer(Void)

  # Maps a section of a buffer object's data store.
  fun map_buffer_range = glMapBufferRange(target  : Enum,
                                          offset  : IntPtr,
                                          length  : SizeiPtr,
                                          access  : Bitfield) : Pointer(Void)

  # Defines a barrier ordering memory transactions.
  fun memory_barrier = glMemoryBarrier(barriers : Bitfield) : Void

  # Specifies minimum rate at which sample shading takes place.
  fun min_sample_shading = glMinSampleShading(value : Float) : Void

  # Renders multiple sets of primitives from array data.
  fun multi_draw_arrays = glMultiDrawArrays(mode        : Enum,
                                            first       : Pointer(Int),
                                            count       : Pointer(Sizei),
                                            draw_count  : Sizei) : Void

  # Renders multiple sets of primitives from array data, taking parameters from memory.
  fun multi_draw_arrays_indirect = glMultiDrawArraysIndirect( mode        : Enum,
                                                              indirect    : Pointer(Void),
                                                              draw_count  : Sizei,
                                                              stride      : Sizei) : Void

  # Renders multiple sets of primitives by specifying indices of array data elements.
  fun multi_draw_elements = glMultiDrawElements(mode        : Enum,
                                                count       : Pointer(Sizei),
                                                value_type  : Enum,
                                                indices     : Pointer(Pointer(Void)),
                                                draw_count  : Sizei) : Void

  # Renders multiple sets of primitives by specifying indices of array data elements and an index to apply to each index.
  fun multi_draw_elements_base_vertex = glMultiDrawElementsBaseVertex(mode        : Enum,
                                                                      count       : Pointer(Sizei),
                                                                      value_type  : Enum,
                                                                      indices     : Pointer(Pointer(Void)),
                                                                      draw_count  : Sizei,
                                                                      base_vertex : Pointer(Int)) : Void

  # Renders indexed primitives from array data, taking parameters from memory.
  fun multi_draw_elements_indirect = glMultiDrawElementsIndirect( mode        : Enum,
                                                                  data_type   : Enum,
                                                                  indirect    : Pointer(Void),
                                                                  draw_count  : Sizei,
                                                                  stride      : Sizei) : Void
end