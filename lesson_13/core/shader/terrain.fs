#version 400 core

in  vec2 pass_textureCoords;
in  vec3 surface_normal;
in  vec3 to_light_source;
in  vec3 to_camera_vector;

out vec4 out_color;

uniform sampler2D texture_sampler;
uniform vec3      light_color;

uniform float     shine_damper;
uniform float     reflectivity;

void main(void){

  // unit normal is the normal of the surface
  vec3  unit_normal       = normalize(surface_normal);
  vec3  unit_light_vector = normalize(to_light_source);

  float dot_value  = dot(unit_normal,unit_light_vector);

  // adjust the minimum so each pixels receives a bit of light
  // this is called ambient lighting
  float brightness = max(dot_value,0.2);
  vec3  diffuse    = brightness * light_color;

  vec3  unit_camera_vector = normalize(to_camera_vector);
  vec3  light_direction    = - unit_light_vector;
  vec3  reflected_light_direction = reflect(light_direction, unit_normal);

  float specular_factor = dot(reflected_light_direction,unit_camera_vector);
  specular_factor       = max(specular_factor,0.0);

  float damped_factor   = pow(specular_factor,shine_damper);
  vec3  final_specular  = damped_factor * reflectivity * light_color;

  out_color = vec4(diffuse,1.0) * texture(texture_sampler,pass_textureCoords) + vec4(final_specular,1.0);;
}
