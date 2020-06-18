lib LibGL

  fun vertex3f = glVertex3f(x : Float,
                            y : Float,
                            z : Float) : Void

  fun vertex2f = glVertex2f(x : Float,
                            y : Float) : Void

  # Validates a program object.
  fun validate_program = glValidateProgram(program : UInt) : Void

  # Validates a program pipeline object against current GL State.
  fun validate_program_pipeline = glValidateProgramPipeline(pipeline : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_1f = glVertexAttrib1f(index : UInt,
                                          v0    : Float) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_2f = glVertexAttrib2f(index : UInt,
                                          v0    : Float,
                                          v1    : Float) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_3f = glVertexAttrib3f(index : UInt,
                                          v0    : Float,
                                          v1    : Float,
                                          v2    : Float) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4f = glVertexAttrib4f(index : UInt,
                                          v0    : Float,
                                          v1    : Float,
                                          v2    : Float,
                                          v3    : Float) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_1s = glVertexAttrib1s(index : UInt,
                                          v0    : Short) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_2s = glVertexAttrib2s(index : UInt,
                                          v0    : Short,
                                          v1    : Short) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_3s = glVertexAttrib3s(index : UInt,
                                          v0    : Short,
                                          v1    : Short,
                                          v2    : Short) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4s = glVertexAttrib4s(index : UInt,
                                          v0    : Short,
                                          v1    : Short,
                                          v2    : Short,
                                          v3    : Short) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_1d = glVertexAttrib1d(index : UInt,
                                          v0    : Double) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_2d = glVertexAttrib2d(index : UInt,
                                          v0    : Double,
                                          v1    : Double) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_3d = glVertexAttrib3d(index : UInt,
                                          v0    : Double,
                                          v1    : Double,
                                          v2    : Double) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4d = glVertexAttrib4d(index : UInt,
                                          v0    : Double,
                                          v1    : Double,
                                          v2    : Double,
                                          v3    : Double) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i1i = glVertexAttribI1i(index : UInt,
                                            v0    : Int) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i2i = glVertexAttribI2i(index : UInt,
                                            v0    : Int,
                                            v1    : Int) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i3i = glVertexAttribI3i(index : UInt,
                                            v0    : Int,
                                            v1    : Int,
                                            v2    : Int) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i4i = glVertexAttribI4i(index : UInt,
                                            v0    : Int,
                                            v1    : Int,
                                            v2    : Int,
                                            v3    : Int) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i1ui = glVertexAttribI1ui(index : UInt,
                                              v0    : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i2ui = glVertexAttribI2ui(index : UInt,
                                              v0    : UInt,
                                              v1    : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i3ui = glVertexAttribI3ui(index : UInt,
                                              v0    : UInt,
                                              v1    : UInt,
                                              v2    : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i4ui = glVertexAttribI4ui(index : UInt,
                                              v0    : UInt,
                                              v1    : UInt,
                                              v2    : UInt,
                                              v3    : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_l1d = glVertexAttribL1d(index : UInt,
                                            v0    : Double) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_l2d = glVertexAttribL2d(index : UInt,
                                            v0    : Double,
                                            v1    : Double) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_l3d = glVertexAttribL3d(index : UInt,
                                            v0    : Double,
                                            v1    : Double,
                                            v2    : Double) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_l4d = glVertexAttribL4d(index : UInt,
                                            v0    : Double,
                                            v1    : Double,
                                            v2    : Double,
                                            v3    : Double) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4nub = glVertexAttrib4Nub(index : UInt,
                                              v0    : UByte,
                                              v1    : UByte,
                                              v2    : UByte,
                                              v3    : UByte) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_1fv = glVertexAttrib1fv(index : UInt,
                                            v     : Pointer(Float)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_2fv = glVertexAttrib2fv(index : UInt,
                                            v     : Pointer(Float)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_3fv = glVertexAttrib3fv(index : UInt,
                                            v     : Pointer(Float)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4fv = glVertexAttrib4fv(index : UInt,
                                            v     : Pointer(Float)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_1sv = glVertexAttrib1sv(index : UInt,
                                            v     : Pointer(Short)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_2sv = glVertexAttrib2sv(index : UInt,
                                            v     : Pointer(Short)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_3sv = glVertexAttrib3sv(index : UInt,
                                            v     : Pointer(Short)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4sv = glVertexAttrib4sv(index : UInt,
                                            v     : Pointer(Short)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_1dv = glVertexAttrib1dv(index : UInt,
                                            v     : Pointer(Double)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_2dv = glVertexAttrib2dv(index : UInt,
                                            v     : Pointer(Double)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_3dv = glVertexAttrib3dv(index : UInt,
                                            v     : Pointer(Double)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4dv = glVertexAttrib4dv(index : UInt,
                                            v     : Pointer(Double)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i1iv = glVertexAttribI1iv(index : UInt,
                                              v     : Pointer(Int)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i2iv = glVertexAttribI2iv(index : UInt,
                                              v     : Pointer(Int)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i3iv = glVertexAttribI3iv(index : UInt,
                                              v     : Pointer(Int)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i4iv = glVertexAttribI4iv(index : UInt,
                                              v     : Pointer(Int)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i1uiv = glVertexAttribI1uiv(index : UInt,
                                                v     : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i2uiv = glVertexAttribI2uiv(index : UInt,
                                                v     : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i3uiv = glVertexAttribI3uiv(index : UInt,
                                                v     : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i4uiv = glVertexAttribI4uiv(index : UInt,
                                                v     : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_l1dv = glVertexAttribL1dv(index : UInt,
                                              v     : Pointer(Double)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_l2dv = glVertexAttribL2dv(index : UInt,
                                              v     : Pointer(Double)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_l3dv = glVertexAttribL3dv(index : UInt,
                                              v     : Pointer(Double)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_l4dv = glVertexAttribL4dv(index : UInt,
                                              v     : Pointer(Double)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4iv = glVertexAttrib4iv(index : UInt,
                                            v     : Pointer(Int)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4bv = glVertexAttrib4bv(index : UInt,
                                            v     : Pointer(Byte)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4ubv = glVertexAttrib4ubv(index : UInt,
                                              v     : Pointer(UByte)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4usv = glVertexAttrib4usv(index : UInt,
                                              v     : Pointer(UShort)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4uiv = glVertexAttrib4uiv(index : UInt,
                                              v     : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4nbv = glVertexAttrib4nbv(index : UInt,
                                              v     : Pointer(Byte)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4nsv = glVertexAttrib4nsv(index : UInt,
                                              v     : Pointer(Short)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4niv = glVertexAttrib4niv(index : UInt,
                                              v     : Pointer(Int)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4nubv = glVertexAttrib4nubv(index : UInt,
                                                v     : Pointer(UByte)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4nusv = glVertexAttrib4nusv(index : UInt,
                                                v     : Pointer(UShort)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_4nuiv = glVertexAttrib4nuiv(index : UInt,
                                                v     : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i4bv = glVertexAttribI4bv(index : UInt,
                                              v     : Pointer(Int8)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i4ubv = glVertexAttribI4ubv(index : UInt,
                                                v     : Pointer(UByte)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i4sv = glVertexAttribI4sv(index : UInt,
                                              v     : Pointer(Short)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_i4usv = glVertexAttribI4usv(index : UInt,
                                                v     : Pointer(UShort)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_p1ui = glVertexAttribP1ui(index         : UInt,
                                              packing_type  : UInt,
                                              normalized    : Boolean,
                                              value         : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_p2ui = glVertexAttribP2ui(index         : UInt,
                                              packing_type  : UInt,
                                              normalized    : Boolean,
                                              value         : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_p3ui = glVertexAttribP3ui(index         : UInt,
                                              packing_type  : UInt,
                                              normalized    : Boolean,
                                              value         : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_p4ui = glVertexAttribP4ui(index         : UInt,
                                              packing_type  : UInt,
                                              normalized    : Boolean,
                                              value         : UInt) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_p1uiv = glVertexAttribP1uiv(index         : UInt,
                                                packing_type  : UInt,
                                                normalized    : Boolean,
                                                value         : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_p2uiv = glVertexAttribP2uiv(index         : UInt,
                                                packing_type  : UInt,
                                                normalized    : Boolean,
                                                value         : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_p3uiv = glVertexAttribP3uiv(index         : UInt,
                                                packing_type  : UInt,
                                                normalized    : Boolean,
                                                value         : Pointer(UInt)) : Void

  # Specifies the value of a generic vertex attribute.
  fun vertex_attrib_p4uiv = glVertexAttribP4uiv(index         : UInt,
                                                packing_type  : UInt,
                                                normalized    : Boolean,
                                                value         : Pointer(UInt)) : Void

  # Associates a vertex attribute and a vertex buffer binding.
  fun vertex_attrib_binding = glVertexAttribBinding(attrib_index  : UInt,
                                                    binding_index : UInt) : Void

  # Modifies the rate at which generic vertex attributes advance during instanced rendering.
  fun vertex_attrib_divisor = glVertexAttribDivisor(index   : UInt,
                                                    divisor : UInt) : Void

  # Specifies the organization of vertex arrays.
  fun vertex_attrib_format = glVertexAttribFormat(attrib_index    : UInt,
                                                  size            : Int,
                                                  data_type       : Enum,
                                                  normalized      : Boolean,
                                                  relative_offset : UInt) : Void

  # Specifies the organization of vertex arrays.
  fun vertex_attrib_i_format = glVertexAttribIFormat( attrib_index    : UInt,
                                                      size            : Int,
                                                      data_type       : Enum,
                                                      relative_offset : UInt) : Void

  # Specifies the organization of vertex arrays.
  fun vertex_attrib_l_format = glVertexAttribLFormat( attrib_index    : UInt,
                                                      size            : Int,
                                                      data_type       : Enum,
                                                      relative_offset : UInt) : Void

  # Defines an array of generic vertex attribute data.
  fun vertex_attrib_pointer = glVertexAttribPointer(index       : UInt,
                                                    size        : Int,
                                                    data_type   : Enum,
                                                    normalized  : Boolean,
                                                    stride      : Sizei,
                                                    pointer     : Pointer(Void)) : Void

  # Defines an array of generic vertex attribute data.
  fun vertex_attrib_i_pointer = glVertexAttribIPointer( index       : UInt,
                                                        size        : Int,
                                                        data_type   : Enum,
                                                        stride      : Sizei,
                                                        pointer     : Pointer(Void)) : Void

  # Defines an array of generic vertex attribute data.
  fun vertex_attrib_l_pointer = glVertexAttribLPointer( index       : UInt,
                                                        size        : Int,
                                                        data_type   : Enum,
                                                        stride      : Sizei,
                                                        pointer     : Pointer(Void)) : Void

  # Modifies the rate at which generic vertex attributes advance.
  fun vertex_binding_divisor = glVertexBindingDivisor(binding_index : UInt,
                                                      divisor       : UInt) : Void

  # Sets the viewport.
  fun viewport = glViewport(x       : Int,
                            y       : Int,
                            width   : Sizei,
                            height  : Sizei) : Void

  # Sets multiple viewports.
  fun viewport_array_v = glViewportArrayv(first : UInt,
                                          count : Sizei,
                                          v     : Pointer(Float)) : Void

  # Sets a specified viewport.
  fun viewport_indexed_f = glViewportIndexedf(index : UInt,
                                              x     : Float,
                                              y     : Float,
                                              w     : Float,
                                              h     : Float) : Void

  # Sets a specified viewport.
  fun viewport_indexed_fv = glViewportIndexedfv(index : UInt,
                                                v     : Pointer(Float)) : Void
end
