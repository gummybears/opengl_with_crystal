lib LibGL
  # Labels a named object identified within a namespace.
  fun object_label = glObjectLabel( identifier  : Enum,
                                    name        : UInt,
                                    length      : Sizei,
                                    label       : Pointer(Char)) : Void

  # Labels a sync object identified by a pointer.
  fun object_ptr_label = glObjectPtrLabel(ptr     : Pointer(Void),
                                          length  : Sizei,
                                          label   : Pointer(Char)) : Void
  # Ortho Transformation
  fun ortho = glOrtho(left     : Double,
                      right    : Double,
                      bottom   : Double,
                      top      : Double,
                      near_val : Double,
                      far_val  : Double) : Void
end
