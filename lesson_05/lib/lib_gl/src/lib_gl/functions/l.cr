lib LibGL
  # Specifies the width of rasterized lines.
  fun line_width = glLineWidth(width : Float) : Void

  # Links a program object.
  fun link_program = glLinkProgram(program : UInt) : Void

  # Specifies a logical pixel operation for rendering.
  fun logic_op = glLogicOp(op_code : Enum) : Void
end