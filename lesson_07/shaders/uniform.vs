#version 400 core

in  vec3 position;
in  vec2 textureCoords;
out vec2 pass_textureCoords;

uniform mat4 m_model;
uniform mat4 m_projection;
uniform mat4 m_view;

void main(void) {
  gl_Position = m_projection * m_view * m_model * vec4(position, 1.0);
  pass_textureCoords = textureCoords;
}
