lib LibGLFW

  #-- Structs --#
    
    # Describes a single video mode.
    struct Vidmode

      # The width, in screen coordinates, of the video mode.
      width       : Int32

      # The height, in screen coordinates, of the video mode.
      height      : Int32

      # The bit depth of the red channel of the video mode.
      redBits     : Int32

      # The bit depth of the green channel of the video mode.
      greenBits   : Int32

      # The bit depth of the blue channel of the video mode.
      blueBits    : Int32

      # The refresh rate, in Hz, of the video mode.
      refreshRate : Int32
    end 

    # Describes the gamma ramp for a monitor.
    struct Gammaramp
      
      # An array of values describing the response of the red channel.
      red   : Pointer(UInt16)

      # An array of values describing the response of the green channel.
      green : Pointer(UInt16)

      # An array of values describing the response of the blue channel.
      blue  : Pointer(UInt16)

      # The number of elements in each array.
      size  : UInt32
    end 

    # Describes an image.
    struct Image

      # The width, in pixels, of this image.
      width   : Int32

      # The height, in pixels, of this image.
      height  : Int32

      # The pixel data of this image, arranged left-to-right, top-to-bottom.
      pixels  : Pointer(UInt8)
    end


  #-- Type Declarations --#

    # Client API function pointer type
    type GlProc                 = (Void -> Void)

    # Vulkan API function pointer type.
    type VkProc                 = (Void -> Void)

    # Opaque monitor object.
    type Monitor                = Void

    # Opaque window object.
    type Window                 = Void

    # Opaque cursor object.
    type Cursor                 = Void

    # Opaque VkInstance object.
    type VkInstance             = Void

    # Opaque VkPhysicalDevice object.
    type VkPhysicalDevice       = Void

    # Opaque VkAllocationCallbacks object.
    type VkAllocationCallbacks  = Void

    # Opaque VkSurfaceKHR object.
    type VkSurfaceKHR           = Void

    # Opaque VkResult object.
    type VkResult               = Void

    # The function signature for error callbacks.
    alias Errorfun           = (Int32, Pointer(UInt8) -> Void)

    # The function signature for window position callbacks.
    alias Windowposfun       = (Pointer(Window), Int32, Int32 -> Void)

    # The function signature for window resize callbacks.
    alias Windowsizefun      = (Pointer(Window), Int32, Int32 -> Void)

    # The function signature for window close callbacks.
    alias Windowclosefun     = (Pointer(Window) -> Void)

    # The function signature for window content refresh callbacks.
    alias Windowrefreshfun   = (Pointer(Window) -> Void)

    # The function signature for window focus/defocus callbacks.
    alias Windowfocusfun     = (Pointer(Window), Int32 -> Void)

    # The function signature for window iconify/restore callbacks.
    alias Windowiconifyfun   = (Pointer(Window), Int32 -> Void)

    # The function signature for framebuffer resize callbacks.
    alias Framebuffersizefun = (Pointer(Window), Int32, Int32 -> Void)

    # The function signature for mouse button callbacks.
    alias Mousebuttonfun     = (Pointer(Window), Int32, Int32, Int32 -> Void)

    # The function signature for cursor position callbacks.
    alias Cursorposfun       = (Pointer(Window), Float64, Float64 -> Void)

    # The function signature for cursor enter/leave callbacks.
    alias Cursorenterfun     = (Pointer(Window), Int32 -> Void)

    # The function signature for scroll callbacks.
    alias Scrollfun          = (Pointer(Window), Float64, Float64 -> Void)

    # The function signature for keyboard key calbacks.
    alias Keyfun             = (Pointer(Window), Int32, Int32, Int32, Int32 -> Void)

    # The function signature for Unicode character callbacks.
    alias Charfun            = (Pointer(Window), UInt32 -> Void)

    # The function signature for Unicode character with modifiers callbacks.
    alias Charmodsfun        = (Pointer(Window), UInt32, Int32 -> Void)

    # The function signature for file drop callbacks.
    alias Dropfun            = (Pointer(Window), Int32, Pointer(Pointer(UInt8)) -> Void)

    # The function signature for monitor configuration callbacks.
    alias Monitorfun         = (Pointer(Monitor), Int32 -> Void)

    # The function signature for joystick configuration callbacks.
    alias Joystickfun        = (Int32, Int32 -> Void)

end
