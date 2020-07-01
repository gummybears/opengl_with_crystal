#version 400 core

in  vec3      position;
out vec3      textureCoords;

uniform mat4  projection;
uniform mat4  model;

void main(void) {

  gl_Position   = projection * model * vec4(position, 1.0);
  textureCoords = position;
}
