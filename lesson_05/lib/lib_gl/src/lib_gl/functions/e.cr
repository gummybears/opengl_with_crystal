lib LibGL

  fun end = glEnd() : Void

  # Enables server-side capabilities.
  fun enable = glEnable(cap : Enum) : Void

  # Enables server-side capabilities.
  fun enable_i = glEnablei( cap   : Enum,
                            index : UInt) : Void

  # Enables a generic vertex attribute array.
  fun enable_vertex_attrib_array = glEnableVertexAttribArray(index : UInt) : Void

  # Ends conditional rendering.
  fun end_conditional_render = glEndConditionalRender : Void

  # Ends a query object.
  fun end_query = glEndQuery(target : Enum) : Void

  # Ends an indexed query object.
  fun end_query_indexed = glEndQueryIndexed(target  : Enum,
                                            index   : UInt) : Void

  # Ends transform feedback operation.
  fun end_transform_feedback = glEndTransformFeedback : Void
end
