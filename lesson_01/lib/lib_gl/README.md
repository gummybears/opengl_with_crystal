# LibGL

OpenGL bindings written in Crystal.

LibGL offers Crystal bindings for modern, shader-based OpenGL. These bindings are relatively "raw" - with a few notable exceptions,
names of functions, constants, and types remain unchanged.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  lib_gl:
    github: calebuharrison/LibGL
    branch: master
```

Install your dependencies:

```sh
shards install
```

## Usage

Using [CrystGLFW](https://github.com/calebuharrison/CrystGLFW) for context creation:

```crystal
require "lib_gl"
require "crystglfw"

include CrystGLFW

CrystGLFW.run do

  # Request a specific version of OpenGL in core profile mode with forward compatibility.
  hints = {
    :context_version_major => 3,
    :context_version_minor => 3,
    :opengl_forward_compat => true,
    :opengl_profile => :opengl_core_profile
  }

  # Create a new window.
  window = Window.new(title: "LibGL Rocks!", hints: hints)

  # Make the window the current OpenGL context.
  window.make_context_current

  until window.should_close?
    CrystGLFW.poll_events

    # Use the timer to generate color values.
    time_value = CrystGLFW.time
    red_value = Math.sin(time_value).abs
    green_value = Math.cos(time_value).abs
    blue_value = Math.tan(time_value).abs

    # Clear the window with the generated color.
    LibGL.clear_color(red_value, green_value, blue_value, 1.0)
    LibGL.clear(LibGL::COLOR_BUFFER_BIT)

    window.swap_buffers
  end

  window.destroy
end
```

## Differences From the C API
LibGL differs from the standard OpenGL API in only a few, simple ways. Each of these differences only exists to make the API fit the [style guide](https://crystal-lang.org/docs/conventions/coding_style.html) of the Crystal language.

### Functions/Methods

Method names in LibGL do not have the "gl" prefix that is present in the C API. Additionally, underscores are used to separate words rather than camel case. LibGL methods are all called as class methods of the LibGL lib:

```crystal
shader_program = LibGL.create_program
LibGL.link_program(shader_program)  
LibGL.use_program(shader_program)
```

### Constants

Prefixes have also been removed from constants, which are accessed directly from the lib:

```crystal
LibGL::COLOR_BUFFER_BIT
LibGL::STATIC_DRAW
LibGL::ARRAY_BUFFER
LibGL::TRUE
```

## Contributing

1. Fork it ( https://github.com/calebuharrison/LibGL/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [calebuharrison](https://github.com/calebuharrison) Caleb Uriah Harrison - creator, maintainer
