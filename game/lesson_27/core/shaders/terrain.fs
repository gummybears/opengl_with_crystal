#version 400 core

in  vec2          pass_textureCoords;
in  vec3          surface_normal;
in  vec3          to_light_source[4];
in  vec3          to_camera_vector;
in  float         visibility;

out vec4          out_color;

// multi texturing
uniform sampler2D background_texture;
uniform sampler2D r_texture;
uniform sampler2D g_texture;
uniform sampler2D b_texture;
uniform sampler2D blend_map;

uniform vec3      light_color[4];
uniform vec3      light_attenuation[4];

uniform float     shine_damper;
uniform float     reflectivity;
uniform vec3      sky_color;

void main(void){

  vec4 blend_map_color = texture(blend_map,pass_textureCoords);

  // calculate the amount for the background texture
  float back_texture_amount = 1 - (blend_map_color.r + blend_map_color.g + blend_map_color.b);
  vec2  tiled_coords = pass_textureCoords * 40.0;

  // sample the background texture at the tiled coordinates
  vec4  background_texture_color = texture(background_texture,tiled_coords) * back_texture_amount;
  vec4  r_texture_color          = texture(r_texture,tiled_coords) * blend_map_color.r;
  vec4  g_texture_color          = texture(g_texture,tiled_coords) * blend_map_color.g;
  vec4  b_texture_color          = texture(b_texture,tiled_coords) * blend_map_color.b;

  vec4  total_color              = background_texture_color + r_texture_color + g_texture_color + b_texture_color;

  // unit normal is the normal of the surface
  vec3  unit_normal       = normalize(surface_normal);
  vec3  unit_camera_vector = normalize(to_camera_vector);

  vec3  total_diffuse  = vec3(0.0);
  vec3  total_specular = vec3(0.0);

  for(int i = 0; i < 4; i++){
    //
    // distance to light source needed
    // to compute the attenuation factor
    //
    float distance          = length(to_light_source[i]);
    float attenuation_factor = light_attenuation[i].x + (light_attenuation[i].y * distance) + (light_attenuation[i].z * distance * distance);

    vec3  unit_light_vector = normalize(to_light_source[i]);
    float dot_value         = dot(unit_normal,unit_light_vector);

    float brightness = max(dot_value,0.1);

    vec3  light_direction    = - unit_light_vector;
    vec3  reflected_light_direction = reflect(light_direction, unit_normal);

    float specular_factor = dot(reflected_light_direction,unit_camera_vector);
    specular_factor       = max(specular_factor,0.0);

    float damped_factor   = pow(specular_factor,shine_damper);

    total_diffuse         = total_diffuse  + (brightness * light_color[i])/attenuation_factor;
    total_specular        = total_specular + (damped_factor * reflectivity * light_color[i])/attenuation_factor;

  }

  total_diffuse = max(total_diffuse,0.2);

  out_color = vec4(total_diffuse,1.0) * total_color + vec4(total_specular,1.0);

}
