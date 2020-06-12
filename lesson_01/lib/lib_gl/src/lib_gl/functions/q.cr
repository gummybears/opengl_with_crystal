lib LibGL
  # Records the GL time into a query object after all previous commands have reached the GL server but have not yet necessarily executed.
  fun query_county = glQueryCounter(id      : UInt,
                                    target  : Enum) : Void
end