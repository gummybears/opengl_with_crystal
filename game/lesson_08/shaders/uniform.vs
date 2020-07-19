#version 400 core

in  vec3 position;
in  vec2 textureCoords;
out vec2 pass_textureCoords;

uniform mat4 model;
uniform mat4 projection;
uniform mat4 view;

void main(void) {
  gl_Position = projection * view * model * vec4(position, 1.0);
  pass_textureCoords = textureCoords;
}