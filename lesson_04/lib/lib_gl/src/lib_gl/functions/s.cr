lib LibGL
  # Specifies multisample coverage parameters.
  fun sample_coverage = glSampleCoverage( value   : Float,
                                          invert  : Boolean) : Void

  # Sets the value of a sub-word of the sample mask.
  fun sample_mask_i = glSampleMaski(mask_number : UInt,
                                    mask        : Bitfield) : Void

  # Sets sampler parameters.
  fun sampler_parameter_f = glSamplerParameterf(sampler : UInt,
                                                p_name  : Enum,
                                                param   : Float) : Void

  # Sets sampler parameters.
  fun sampler_parameter_i = glSamplerParameteri(sampler : UInt,
                                                p_name  : Enum,
                                                param   : Int) : Void

  # Sets sampler parameters.
  fun sampler_parameter_fv = glSamplerParameterfv(sampler : UInt,
                                                  p_name  : Enum,
                                                  params  : Pointer(Float)) : Void

  # Sets sampler parameters.
  fun sampler_parameter_iv = glSamplerParameteriv(sampler : UInt,
                                                  p_name  : Enum,
                                                  params  : Pointer(Int)) : Void

  # Sets sampler parameters.
  fun sampler_parameter_iiv = glSamplerParameterIiv(sampler : UInt,
                                                    p_name  : Enum,
                                                    params  : Pointer(Int)) : Void

  # Sets sampler parameters.
  fun sampler_parameter_iuiv = glSamplerParameterIuiv(sampler : UInt,
                                                      p_name  : Enum,
                                                      params  : Pointer(UInt)) : Void

  # Defines the scissor box.
  fun scissor = glScissor(x       : Int,
                          y       : Int,
                          width   : Sizei,
                          height  : Sizei) : Void

  # Defines the scissor box for multiple viewports.
  fun scissor_array_v = glScissorArrayv(first : UInt,
                                        count : Sizei,
                                        v     : Pointer(Int)) : Void

  # Defines the scissor box for a specific viewport.
  fun scissor_indexed = glScissorIndexed( index   : UInt,
                                          left    : Int,
                                          bottom  : Int,
                                          width   : Sizei,
                                          height  : Sizei) : Void

  # Defines the scissor box for a specific viewport.
  fun scissor_indexed_v = glScissorIndexedv(index : UInt,
                                            v     : Pointer(Int)) : Void

  # Loads pre-compiled shader binaries.
  fun shader_binary = glShaderBinary( count         : Sizei,
                                      shaders       : Pointer(UInt),
                                      binary_format : Enum,
                                      binary        : Pointer(Void),
                                      length        : Sizei) : Void

  # Replaces the source code in a shader object.
  fun shader_source = glShaderSource( shader  : UInt,
                                      count   : Sizei,
                                      string  : Pointer(Pointer(Char)),
                                      length  : Pointer(Int)) : Void

  # Changes an active shader storage block binding.
  fun shader_storage_block_binding = glShaderStorageBlockBinding( program               : UInt,
                                                                  storage_block_index   : UInt,
                                                                  storage_block_binding : UInt) : Void

  # Sets front and back function and reference value for stencil testing.
  fun stencil_func = glStencilFunc( func  : Enum,
                                    ref   : Int,
                                    mask  : UInt) : Void

  # Sets front and/or back function and references value for stencil testing.
  fun stencil_func_separate = glStencilFuncSeparate(face  : Enum,
                                                    func  : Enum,
                                                    ref   : Int,
                                                    mask  : UInt) : Void

  # Controls the front and back writing of individual bits in the stencil planes.
  fun stencil_mask = glStencilMask(mask : UInt) : Void

  # Controls the front and/or back writing of individual bits in the stencil planes.
  fun stencil_mask_separate = glStencilMaskSeparate(face  : Enum,
                                                    mask  : UInt) : Void

  # Sets front and back stencil test actions.
  fun stencil_op = glStencilOp( s_fail  : Enum,
                                dp_fail : Enum,
                                dp_pass : Enum) : Void

  # Sets front and/or back stencil test actions.
  fun stencil_op_separate = glStencilOpSeparate(face    : Enum,
                                                s_fail  : Enum,
                                                dp_fail : Enum,
                                                dp_pass : Enum) : Void
end