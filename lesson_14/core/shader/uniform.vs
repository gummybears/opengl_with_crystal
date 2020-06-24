#version 400 core

in  vec3 position;
in  vec3 normal;
in  vec2 textureCoords;

out vec2 pass_textureCoords;
out vec3 surface_normal;
out vec3 to_light_source;
out vec3 to_camera_vector;

uniform mat4  model;
uniform mat4  projection;
uniform mat4  view;
uniform vec3  light_position;
uniform float use_fake_lighting = 0.0;

void main(void) {

  vec4 world_position = model * vec4(position, 1.0);

  gl_Position         = projection * view * world_position;
  pass_textureCoords  = textureCoords;

  vec3 actual_normal  = normal;
  if( use_fake_lighting > 0.5 ) {
    actual_normal = vec3(0.0,1.0,0.0);
  }

  surface_normal   = (model * vec4(actual_normal,0.0)).xyz;
  to_light_source  = light_position - world_position.xyz;

  // the negative camera position is present in the view matrix
  to_camera_vector = (inverse(view) * vec4(0.0,0.0,0.0,1.0)).xyz - world_position.xyz;
}
