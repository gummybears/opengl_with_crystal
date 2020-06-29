#version 400 core

in  vec3      position;
in  vec3      normal;
in  vec2      textureCoords;

out vec2      pass_textureCoords;
out vec3      surface_normal;
out vec3      to_light_source;
out vec3      to_camera_vector;
out float     visibility;

uniform mat4  model;
uniform mat4  projection;
uniform mat4  view;
uniform vec3  light_position;

uniform float use_fake_lighting;
uniform float density;
uniform float gradient;

// uniforms needed to use texture atlases
uniform float number_of_rows;
uniform vec2  offset;

void main(void) {

  vec3 actual_normal  = normal;
  if( use_fake_lighting > 0.5 ) {
    actual_normal = vec3(0.0,1.0,0.0);
  }

  vec4 world_position              = model * vec4(position, 1.0);
  vec4 position_relative_to_camera = view * world_position;

  gl_Position         = projection * position_relative_to_camera;

  // scale down the texture coordinates
  pass_textureCoords = (textureCoords/number_of_rows) + offset;


  surface_normal   = (model * vec4(actual_normal,0.0)).xyz;
  to_light_source  = light_position - world_position.xyz;

  // the negative camera position is present in the view matrix
  to_camera_vector = (inverse(view) * vec4(0.0,0.0,0.0,1.0)).xyz - world_position.xyz;

  // distance of current vertex to camera
  float distance = length(position_relative_to_camera.xyz);
  visibility     = exp(-pow((distance * density), gradient));
  visibility     = clamp(visibility,0.0,1.0);
}
