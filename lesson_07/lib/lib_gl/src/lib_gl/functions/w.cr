lib LibGL
  # Instructs the GL server to block until the specified sync object becomes signaled.
  fun wait_sync = glWaitSync( sync    : Sync,
                              flags   : Bitfield,
                              timeout : ULong) : Void
end