#version 400 core

in  vec3 position;
in  vec3 normal;
in  vec2 textureCoords;

out vec2 pass_textureCoords;
out vec3 surface_normal;
out vec3 to_light_source;
out vec3 to_camera_vector;

uniform mat4 model;
uniform mat4 projection;
uniform mat4 view;
uniform vec3 light_position;

void main(void) {

  vec4 world_position = model * vec4(position, 1.0);

  gl_Position = projection * view * world_position;
  pass_textureCoords = textureCoords * 16;

  surface_normal   = (model * vec4(normal,0.0)).xyz;
  to_light_source  = light_position - world_position.xyz;

  // the negative camera position is present in the view matrix
  to_camera_vector = (inverse(view) * vec4(0.0,0.0,0.0,1.0)).xyz - world_position.xyz;
}