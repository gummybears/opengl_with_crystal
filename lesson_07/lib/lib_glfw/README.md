# LibGLFW

Complete GLFW bindings written in Crystal.

LibGLFW offers Crystal bindings for the [full GLFW specification](http://www.glfw.org/docs/latest/glfw3_8h.html). These
bindings are relatively "raw" - with a few notable exceptions, names of functions, constants, and types remain unchanged.


## Installation

First, make sure you've got GLFW3:

```sh
brew install glfw3
```

Add this to your application's `shard.yml`:

```yaml
dependencies:
  lib_glfw:
    github: calebuharrison/LibGLFW
    branch: master
```

Install your dependencies:

```sh
shards install
```

## Usage

```crystal
require "lib_glfw"

# Initialize GLFW
LibGLFW.init

width, height, title, monitor, share = 640, 480, "My First Window!", nil, nil

# Create a window and its associated OpenGL context.
window_handle = LibGLFW.create_window(width, height, title, monitor, share)

# Render new frames until the window should close.
until LibGLFW.window_should_close(window_handle)
  LibGLFW.swap_buffers(window_handle)
end

# Destroy the window along with its context.
LibGLFW.destroy_window(window_handle)

# Terminate GLFW
LibGLFW.terminate
```

## Differences From the C API

LibGLFW differs from the standard GLFW API in only a few, simple ways. Each of these differences only exists to make the
API fit the [style guide](https://crystal-lang.org/docs/conventions/coding_style.html) of the Crystal language.

### Functions/Methods

Method names in LibGLFW do not have the "glfw" prefix that is present in the C API. Additionally, underscores are used to separate words
rather than camel case. LibGLFW methods are all called as class methods of the LibGLFW lib.

In C:
```c
  // Get and print the current version of GLFW
  int major, minor, rev;
  glfwGetVersion(&major, &minor, &rev);
  printf("Current version of GLFW is %d.%d.%d\n", major, minor, rev);
```

In Crystal:
```crystal
# Get and print the current version of GLFW
LibGLFW.get_version(out major, out minor, out rev)
puts "Current version of GLFW is #{major}.#{minor}.#{rev}"
```

### Constants

Prefixes have also been removed from constants, which are accessed directly from the lib.

In C:
```c
// Check to see if the joystick is present and complain if it isn't.
if (!glfwJoystickPresent(GLFW_JOYSTICK_9)) {
  printf("Nooooooooooooooo!!!!!!\n");
}
```

In Crystal:
```crystal
# Check to see if the joystick is present and complain if it isn't.
puts "Noooooooooooo!!!!!!" unless LibGLFW.joystick_present(LibGLFW::JOYSTICK_9)
```

## Contributing

1. Fork it ( https://github.com/calebuharrison/LibGLFW/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [calebuharrison](https://github.com/calebuharrison) Caleb Uriah Harrison - creator, maintainer
