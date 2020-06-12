require "./types"

@[Link("glfw3")]
lib LibGLFW

  # Initializes the GLFW library.
  #
  # Before most GLFW functions can be used, GLFW must be initialized, and before an application
  # terminates, GLFW should be terminated in order to free any resources allocated during or after
  # initialization.
  #
  # If this method fails, it calls `#terminate` before returning. If this method succeeds, `#terminate` 
  #  should be called manually before the application exits.
  #
  # Additional calls to this method after successful initialization but before termination will immediately
  # return `GLFW_TRUE`. 
  #
  # Returns `GLFW_TRUE` if initialization is successful and returns `GLFW_FALSE` otherwise.
  fun init = glfwInit : Int32

  # Terminates the GLFW Library.
  #
  # This method destroys all remaining windows and cursors, restores any modified gamma ramps and frees
  # any other allocated resources.  Once it is called, initialization via `#init` will be necessary to
  # begin using most GLFW functions again.
  #
  # If GLFW has been successfully initialized, this method should be called before the application exits.
  # If initialization fails, there is no need to call this method, because `#init` calls it implicity upon 
  # failure.
  fun terminate = glfwTerminate : Void

  # Retrieves the version of the GLFW library.
  #
  # This method retrieves the major, minor, and revision numbers of the GLFW library.
  #
  # It accepts the following arguments:
  # *major*, where to store the major version number.
  # *minor*, where to store the minor version number.
  # *rev*, where to store the revision version number.
  fun get_version = glfwGetVersion(major  : Pointer(Int32),
                                   minor  : Pointer(Int32),
                                   rev    : Pointer(Int32)) : Void

  # Returns the compile-time generated version string of the GLFW library binary.
  # 
  # This method describes the version, platform, compiler, and any platform-specific compile-time
  # options. The format of the string is as follows:
  # 
  # - The version of GLFW
  # - The name of the window system API
  # - The name of the context creation api
  # - Any additional options or APIs
  #
  # **The version string should not be used to parse the GLFW library version.** `#get_version` provides the 
  # version of the running library binary in numerical format.
  fun get_version_string = glfwGetVersionString : Pointer(UInt8)

  # Sets the error callback, which is called with an error code and a human-readable description each time a GLFW
  # error occurs.
  #
  # The error callback is called on the thread where the error occurred. If GLFW is being used from multiple
  # threads, then the error callback needs to be written accordingly.
  #
  # Because the description string may have been generated specifically for that error, it is not guaranteed
  # to be valid after the callback has returned.  A copy of the description string must be made if it is to
  # be used after the callback returns.
  #
  # Once set, the error callback remains set even after the library has been terminated.
  #
  # This method accepts the following arguments:
  # - *cbfun*, the new callback. If nil, the current callback is removed.
  #
  # Returns the previously set callback or *nil* if no callback was set.
  fun set_error_callback = glfwSetErrorCallback(cbfun : Errorfun) : Errorfun

  # Retrieves the currently connected monitors.
  #
  # This method retrieves an array of handles for all currently connected monitors. The primary monitor
  # is always first in the returned array. If no monitors are found, *nil* is returned.
  #
  # This method accepts the following arguments:
  # - *count*, where it stores the number of monitors in the returned array.
  #
  # *count* is set to zero if an error occurs.
  #
  # Returns an array of monitor handles, or *nil* if no monitors were found or if an error occurred.
  @[Raises]
  fun get_monitors = glfwGetMonitors(count : Pointer(Int32)) : Pointer(Pointer(Monitor))

  # Returns the primary monitor.
  #
  # This method returns the primary monitor. This is usually the monitor where elements like the task bar or
  # global menu bar are located.
  #
  # Returns the primary monitor handle or *nil* if no monitors were found or if an error occurred.
  @[Raises]
  fun get_primary_monitor = glfwGetPrimaryMonitor : Pointer(Monitor)

  # Retrieves the position of the monitor's viewport on the virtual screen.
  #
  # This method retrieves the position, in screen coordinates, of the upper-left corner of the specified
  # monitor.
  #
  # Any or all of the position arguments may be *nil*. If an error occurs, all non-*nil* position arguments
  # will be set to zero.
  #
  # This method accepts the following arguments:
  # - *monitor*, the monitor to query.
  # - *xpos*, where to store the monitor x-coordinate, or nil.
  # - *ypos*, where to store the monitor y-coordinate, or nil.
  @[Raises]
  fun get_monitor_pos = glfwGetMonitorPos(monitor : Pointer(Monitor), 
                                          xpos    : Pointer(Int32),
                                          ypos    : Pointer(Int32)) : Void

  # Returns the physical size of the monitor.
  # 
  # This method returns the size, in millimeters, of the display area of the specified monitor.
  #
  # Some systems do not provide accurate monitor size information, either because the monitor EDID data is
  # incorrect or because the driver does not report it accurately.
  #
  # Any or all of the size arguments may be *nil*. If an error occurs, all non-*nil* size arguments will be
  # set to zero.
  #
  # This method accepts the following arguments:
  # - *monitor*, the monitor to query.
  # - *widthMM*, where to store the width, in millimeters, of the monitor's display area, or *nil*.
  # - *heightMM*, where to store the height, in millimeters, of the monitor's display area, or *nil*.
  @[Raises]
  fun get_monitor_physical_size = glfwGetMonitorPhysicalSize(monitor  : Pointer(Monitor),
                                                             widthMM  : Pointer(Int32),
                                                             heightMM : Pointer(Int32)) : Void

  # Returns the name of the specified monitor.
  #
  # This method returns a human-readable name of the specified monitor. The name typically reflects the make
  # and model of the monitor and is not guaranteed to be unique among the connected monitors.
  #
  # This method accepts the following arguments:
  # - *monitor*, the monitor to query.
  #
  # Returns the name of the monitor, or *nil* if an error occurs.
  @[Raises]
  fun get_monitor_name = glfwGetMonitorName(monitor : Pointer(Monitor)) : Pointer(UInt8)

  # Sets the monitor configuration callback.
  #
  # This method sets the monitor configuration callback, or removes the currently set callback. This is called
  # when a monitor is connected to or disconnected from the system.
  #
  # This method accepts the following arguments:
  # - *cbfun*, the new callback, or *nil* to remove the currently set callback.
  #
  # Returns the previously set callback, or *nil* if no callback is set or the library has not been
  # initialized.
  @[Raises]
  fun set_monitor_callback = glfwSetMonitorCallback(cbfun : Monitorfun) : Monitorfun

  # Returns the available video modes for the specified monitor.
  # 
  # This method returns an array of all video modes supported by the monitor. The returned array is sorted in
  # ascending order, first by color bit depth (the sum of all channel depths) and then by resolution area (the
  # product of width and height).
  #
  # This method accepts the following arguments:
  # - *monitor*, the monitor to query.
  # - *count*, where to store the number of video modes in the returned array. This is set to zero if an error occurs.
  #
  # Returns an array of video modes, or *nil* if an error occurs.
  @[Raises]
  fun get_video_modes = glfwGetVideoModes(monitor : Pointer(Monitor),
                                          count   : Pointer(Int32)) : Pointer(Vidmode)

  # Returns the current mode of the specified monitor.
  #
  # This method returns the current video mode of the specified monitor. If a full screen window has been created for 
  # that monitor, the return value will depend on whether that window is iconified.
  #
  # This method accepts the following arguments:
  # - *monitor*, the monitor to query.
  #
  # Returns the current mode of the monitor, or *nil* if an error occurs.
  @[Raises]
  fun get_video_mode = glfwGetVideoMode(monitor : Pointer(Monitor)) : Pointer(Vidmode)

  # Generates a gamma ramp and sets it for the specified monitor.
  #
  # This method generates a 256-element gamma ramp from the specified exponent and then calls `#set_gamma_ramp` with it.
  # The value must be a finite number greater than zero.
  #
  # This method accepts the following arguments:
  # - *monitor*, the monitor whose gamma ramp to set.
  # - *gamma*, the desired exponent.
  @[Raises]
  fun set_gamma = glfwSetGamma(monitor  : Pointer(Monitor),
                               gamma    : Float32) : Void

  # Returns the current gamma ramp for the specified monitor.
  @[Raises]
  fun get_gamma_ramp = glfwGetGammaRamp(monitor : Pointer(Monitor)) : Pointer(Gammaramp)

  # Sets the current gamma ramp for the specified monitor.
  @[Raises]
  fun set_gamma_ramp = glfwSetGammaRamp(monitor : Pointer(Monitor),
                                        ramp    : Pointer(Gammaramp)) : Void

  # Resets all window hints to their default values.
  @[Raises]
  fun default_window_hints = glfwDefaultWindowHints : Void

  # Sets the specified window hint to the desired value.
  @[Raises]
  fun window_hint = glfwWindowHint(hint   : Int32,
                                   value  : Int32) : Void

  # Creates a window and its associated OpenGL or OpenGL ES context.
  @[Raises]
  fun create_window = glfwCreateWindow(width    : Int32,
                                       height   : Int32,
                                       title    : Pointer(UInt8),
                                       monitor  : Pointer(Monitor),
                                       share    : Pointer(Window)) : Pointer(Window)

  # Destroys the specified window and its context.
  @[Raises]
  fun destroy_window = glfwDestroyWindow(window : Pointer(Window)) : Void

  # Checks the close flag of the specified window.
  @[Raises]
  fun window_should_close = glfwWindowShouldClose(window : Pointer(Window)) : Int32

  # Sets the close flag of the specified window.
  @[Raises]
  fun set_window_should_close = glfwSetWindowShouldClose(window : Pointer(Window),
                                                         value  : Int32) : Void

  # Sets the title of the specified window.
  @[Raises]
  fun set_window_title = glfwSetWindowTitle(window  : Pointer(Window),
                                            title   : Pointer(UInt8)) : Void

  # Sets the icon for the specified window.
  @[Raises]
  fun set_window_icon = glfwSetWindowIcon(window  : Pointer(Window),
                                          count   : Int32,
                                          images  : Pointer(Image)) : Void

  # Retrieves the position of the client area of the specified window.
  @[Raises]
  fun get_window_pos = glfwGetWindowPos(window  : Pointer(Window),
                                        xpos    : Pointer(Int32),
                                        ypos    : Pointer(Int32)) : Void

  # Sets the position of the client area of the specified window.
  @[Raises]
  fun set_window_pos = glfwSetWindowPos(window  : Pointer(Window),
                                        xpos    : Int32,
                                        ypos    : Int32) : Void

  # Retrieves the size of the client area of the specified window.
  @[Raises]
  fun get_window_size = glfwGetWindowSize(window  : Pointer(Window),
                                          width   : Pointer(Int32),
                                          height  : Pointer(Int32)) : Void

  # Sets the size limits of the specified window.
  @[Raises]
  fun set_window_size_limits = glfwSetWindowSizeLimits(window     : Pointer(Window),
                                                       minwidth   : Int32,
                                                       minheight  : Int32,
                                                       maxwidth   : Int32,
                                                       maxheight  : Int32) : Void

  # Sets the aspect ratio of the specified window.
  @[Raises]
  fun set_window_aspect_ratio = glfwSetWindowAspectRatio(window : Pointer(Window),
                                                         numer  : Int32,
                                                         denom  : Int32) : Void

  # Sets the size of the client area of the specified window.
  @[Raises]
  fun set_window_size = glfwSetWindowSize(window  : Pointer(Window),
                                          width   : Int32,
                                          height  : Int32) : Void

  # Retrieves the size of the framebuffer of the specified window.
  @[Raises]
  fun get_framebuffer_size = glfwGetFramebufferSize(window  : Pointer(Window),
                                                    width   : Pointer(Int32),
                                                    height  : Pointer(Int32)) : Void

  # Retrieves the size of the frame of the window.
  @[Raises]
  fun get_window_frame_size = glfwGetWindowFrameSize(window : Pointer(Window),
                                                     left   : Pointer(Int32),
                                                     top    : Pointer(Int32),
                                                     right  : Pointer(Int32),
                                                     bottom : Pointer(Int32)) : Void

  # Iconifies the specified window.
  @[Raises]
  fun iconify_window = glfwIconifyWindow(window : Pointer(Window)) : Void

  # Restores the specified window.
  @[Raises]
  fun restore_window = glfwRestoreWindow(window : Pointer(Window)) : Void

  # Maximizes the specified window.
  @[Raises]
  fun maximize_window = glfwMaximizeWindow(window : Pointer(Window)) : Void

  # Makes the specified window visible.
  @[Raises]
  fun show_window = glfwShowWindow(window : Pointer(Window)) : Void

  # Hides the specified window.
  @[Raises]
  fun hide_window = glfwHideWindow(window : Pointer(Window)) : Void

  # Brings the specified window to front and sets input focus.
  @[Raises]
  fun focus_window = glfwFocusWindow(window : Pointer(Window)) : Void

  # Returns the monitor that the window uses for full screen mode.
  @[Raises]
  fun get_window_monitor = glfwGetWindowMonitor(window : Pointer(Window)) : Pointer(Monitor)

  # Sets the mode, monitor, video mode, and placement of a window.
  @[Raises]
  fun set_window_monitor = glfwSetWindowMonitor(window      : Pointer(Window),
                                                monitor     : Pointer(Monitor),
                                                xpos        : Int32,
                                                ypos        : Int32,
                                                width       : Int32,
                                                height      : Int32,
                                                refreshRate : Int32) : Void

  # Returns an attribute of the specified window.
  @[Raises]
  fun get_window_attrib = glfwGetWindowAttrib(window : Pointer(Window),
                                              attrib : Int32) : Int32

  # Sets the user pointer of the specified window.
  @[Raises]
  fun set_window_user_pointer = glfwSetWindowUserPointer(window   : Pointer(Window),
                                                         pointer  : Pointer(Void)) : Void

  # Returns the user pointer of the specified window.
  @[Raises]
  fun get_window_user_pointer = glfwGetWindowUserPointer(window : Pointer(Window)) : Pointer(Void)

  # Sets the position callback for the specified window.
  @[Raises]
  fun set_window_pos_callback = glfwSetWindowPosCallback(window : Pointer(Window),
                                                         cbfun  : Windowposfun) : Windowposfun

  # Sets the size callback for the specified window.
  @[Raises]
  fun set_window_size_callback = glfwSetWindowSizeCallback(window : Pointer(Window),
                                                           cbfun  : Windowsizefun) : Windowsizefun

  # Sets the close callback for the specified window.
  @[Raises]
  fun set_window_close_callback = glfwSetWindowCloseCallback(window : Pointer(Window),
                                                             cbfun  : Windowclosefun) : Windowclosefun

  # Sets the refresh callback for the specified window.
  @[Raises]
  fun set_window_refresh_callback = glfwSetWindowRefreshCallback(window : Pointer(Window),
                                                                 cbfun  : Windowrefreshfun) : Windowrefreshfun

  # Sets the focus callback for the specified window.
  @[Raises]
  fun set_window_focus_callback = glfwSetWindowFocusCallback(window : Pointer(Window),
                                                             cbfun  : Windowfocusfun) : Windowfocusfun

  # Sets the iconify callback for the specified window.
  @[Raises]
  fun set_window_iconify_callback = glfwSetWindowIconifyCallback(window : Pointer(Window),
                                                                 cbfun  : Windowiconifyfun) : Windowiconifyfun

  # Sets the framebuffer resize callback for the specified window.
  @[Raises]
  fun set_framebuffer_size_callback = glfwSetFramebufferSizeCallback(window : Pointer(Window),
                                                                     cbfun  : Framebuffersizefun) : Framebuffersizefun

  # Processes all pending events.
  @[Raises]
  fun poll_events = glfwPollEvents : Void

  # Waits until events are queued and processes them.
  @[Raises]
  fun wait_events = glfwWaitEvents : Void

  # Waits with timeout until events are queued and processes them.
  @[Raises]
  fun wait_events_timeout = glfwWaitEventsTimeout(timeout : Float64) : Void

  # Posts an empty event to the event queue.
  @[Raises]
  fun post_empty_event = glfwPostEmptyEvent : Void

  # Returns the value of an input option for the specified window.
  @[Raises]
  fun get_input_mode = glfwGetInputMode(window  : Pointer(Window),
                                        mode    : Int32) : Int32

  # Sets an input option for the specified window.
  @[Raises]
  fun set_input_mode = glfwSetInputMode(window  : Pointer(Window),
                                        mode    : Int32,
                                        value   : Int32) : Void

  # Returns the localized name of the specified printable key.
  @[Raises]
  fun get_key_name = glfwGetKeyName(key       : Int32,
                                    scancode  : Int32) : Pointer(UInt8)

  # Returns the last reported state of a keyboard key for the specified window.
  @[Raises]
  fun get_key = glfwGetKey(window : Pointer(Window),
                           key    : Int32) : Int32

  # Returns the last reported state of a mouse button for the specified window.
  @[Raises]
  fun get_mouse_button = glfwGetMouseButton(window : Pointer(Window),
                                            button : Int32) : Int32

  # Retrieves the position of the cursor relative to the client area of the window.
  @[Raises]
  fun get_cursor_pos = glfwGetCursorPos(window  : Pointer(Window),
                                        xpos    : Pointer(Float64),
                                        ypos    : Pointer(Float64)) : Void

  # Sets the position of the curosr, relative to the client area of the window.
  @[Raises]
  fun set_cursor_pos = glfwSetCursorPos(window  : Pointer(Window),
                                        xpos    : Float64,
                                        ypose   : Float64) : Void

  # Creates a custom cursor.
  @[Raises]
  fun create_cursor = glfwCreateCursor(image  : Pointer(Image),
                                       xhot   : Int32,
                                       yhot   : Int32) : Pointer(Cursor)

  # Creates a cursor with a standard shape.
  @[Raises]
  fun create_standard_cursor = glfwCreateStandardCursor(shape : Int32) : Pointer(Cursor)

  # Destroys a cursor
  @[Raises]
  fun destroy_cursor = glfwDestroyCursor(cursor : Pointer(Cursor)) : Void

  # Sets the cursor for the window.
  @[Raises]
  fun set_cursor = glfwSetCursor(window : Pointer(Window),
                                 cursor : Pointer(Cursor)) : Void

  # Sets the key callback.
  @[Raises]
  fun set_key_callback = glfwSetKeyCallback(window  : Pointer(Window),
                                            cbfun   : Keyfun) : Keyfun

  # Sets the Unicode character callback.
  @[Raises]
  fun set_char_callback = glfwSetCharCallback(window  : Pointer(Window),
                                              cbfun   : Charfun) : Charfun

  # Sets the Unicode character with modifiers callback.
  @[Raises]
  fun set_char_mods_callback = glfwSetCharModsCallback(window : Pointer(Window),
                                                       cbfun  : Charmodsfun) : Charmodsfun

  # Sets the mouse button callback.
  @[Raises]
  fun set_mouse_button_callback = glfwSetMouseButtonCallback(window : Pointer(Window),
                                                             cbfun  : Mousebuttonfun) : Mousebuttonfun

  # Sets the cursor position callback.
  @[Raises]
  fun set_cursor_pos_callback = glfwSetCursorPosCallback(window : Pointer(Window),
                                                         cbfun  : Cursorposfun) : Cursorposfun

  # Sets the cursor enter/exit callback.
  @[Raises]
  fun set_cursor_enter_callback = glfwSetCursorEnterCallback(window : Pointer(Window),
                                                             cbfun  : Cursorenterfun) : Cursorenterfun

  # Sets the scroll callback.
  @[Raises]
  fun set_scroll_callback = glfwSetScrollCallback(window  : Pointer(Window),
                                                  cbfun   : Scrollfun) : Scrollfun

  # Sets the file drop callback.
  @[Raises]
  fun set_drop_callback = glfwSetDropCallback(window  : Pointer(Window),
                                              cbfun   : Dropfun) : Dropfun

  # Returns whether the specified joystick is present.
  @[Raises]
  fun joystick_present = glfwJoystickPresent(joy : Int32) : Int32

  # Returns the values of all axes of the specified joystick.
  @[Raises]
  fun get_joystick_axes = glfwGetJoystickAxes(joy   : Int32,
                                              count : Pointer(Int32)) : Pointer(Float32)

  # Returns the state of all button of the specified joystick.
  @[Raises]
  fun get_joystick_buttons = glfwGetJoystickButtons(joy   : Int32,
                                                    count : Pointer(Int32)) : Pointer(UInt8)

  # Returns the name of the specified joystick.
  @[Raises]
  fun get_joystick_name = glfwGetJoystickName(joy : Int32) : Pointer(UInt8)

  # Sets the joystick configuration callback.
  @[Raises]
  fun set_joystick_callback = glfwSetJoystickCallback(cbfun : Joystickfun) : Joystickfun

  # Sets the clipboard to the specified string.
  @[Raises]
  fun set_clipboard_string = glfwSetClipboardString(window : Pointer(Window),
                                                    string : Pointer(UInt8)) : Void

  # Returns the contents of the clipboard as a string.
  @[Raises]
  fun get_clipboard_string = glfwGetClipboardString(window : Pointer(Window)) : Pointer(UInt8)

  # Returns the value of the GLFW timer.
  @[Raises]
  fun get_time = glfwGetTime : Float64

  # Sets the GLFW timer.
  @[Raises]
  fun set_time = glfwSetTime(time : Float64) : Void

  # Returns the current value of the raw timer.
  @[Raises]
  fun get_timer_value = glfwGetTimerValue : UInt64

  # Returns the frequency, in Hz, of the raw timer.
  @[Raises]
  fun get_timer_frequency = glfwGetTimerFrequency : UInt64

  # Makes the context of the specified window current for the calling thread.
  @[Raises]
  fun make_context_current = glfwMakeContextCurrent(window : Pointer(Window)) : Void

  # Returns the window whose context is current on the calling thread.
  @[Raises]
  fun get_current_context = glfwGetCurrentContext : Pointer(Window)

  # Swaps the front and back buffers of the specified window.
  @[Raises]
  fun swap_buffers = glfwSwapBuffers(window : Pointer(Window)) : Void

  # Sets the swap interval for the current context.
  @[Raises]
  fun swap_interval = glfwSwapInterval(interval : Int32) : Void

  # Returns whether the specified extension is available.
  @[Raises]
  fun extension_supported = glfwExtensionSupported(extension : Pointer(UInt8)) : Int32

  # Returns the address of the specified function for the current context
  @[Raises]
  fun get_proc_address = glfwGetProcAddress(procname : Pointer(UInt8)) : GlProc

  # Returns whether the Vulkan loader has been found.
  @[Raises]
  fun vulkan_supported = glfwVulkanSupported : Int32

  # Returns the Vulkan instance extensions required by GLFW.
  @[Raises]
  fun get_required_instance_extensions = glfwGetRequiredInstanceExtensions(count : Pointer(UInt32)) : Pointer(Pointer(UInt8))
  
  # Returns the address of the specified Vulkan instance function.
  @[Raises]
  fun get_instance_proc_address = glfwGetInstanceProcAddress(instance : Pointer(VkInstance),
                                                             procname : Pointer(UInt8)) : VkProc

  # Returns whether the specified queue family can present images.
  @[Raises]
  fun get_physical_device_presentation_support = glfwGetPhysicalDevicePresentationSupport(instance    : Pointer(VkInstance),
                                                                                          device      : Pointer(VkPhysicalDevice),
                                                                                          queuefamily : UInt32) : Int32

  # Creates a Vulkan surface for the specified window
  @[Raises]
  fun create_window_surface = glfwCreateWindowSurface(instance  : Pointer(VkInstance),
                                                      window    : Pointer(Window),
                                                      allocator : Pointer(VkAllocationCallbacks),
                                                      surface   : Pointer(VkSurfaceKHR)) : Pointer(VkResult)

end
