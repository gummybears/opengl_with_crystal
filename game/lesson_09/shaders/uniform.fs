#version 400 core

in  vec2 pass_textureCoords;
in  vec3 surface_normal;
in  vec3 to_light_source;

out vec4 out_color;

uniform sampler2D texture_sampler;
uniform vec3 light_color;

void main(void){

  vec3 unit_normal       = normalize(surface_normal);
  vec3 unit_light_vector = normalize(to_light_source);

  float dot_value  = dot(unit_normal,unit_light_vector);
  float brightness = max(dot_value,0.0);
  vec3  diffuse    = brightness * light_color;

  out_color = vec4(diffuse,1.0) * texture(texture_sampler,pass_textureCoords);
}
