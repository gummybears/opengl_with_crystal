Raymarching tutorial

Based on Youtube channel The Art of Code,
see https://www.youtube.com/watch?v=PGtv-dBi2wE

Implementing boolean operators (union, subtract, intersect) with smooth minimum.

Added a configuration file to set values for
- the position of the camera
- the position of the main light source
- the vertex shader and fragment shader

It is possible to recompile the vertex- and fragment
shader dynamically by pressing the R key.

Added a simple preprocessor, to include shader files.

Resizing of the window also works by calling LibGL.viewport
with the new width and height of the window.

Taking a screenshot of the window is possible by pressing the
S key.

