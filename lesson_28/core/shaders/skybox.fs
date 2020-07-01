#version 400 core

in vec3  textureCoords;
out vec4 out_color;

//
// two cube maps to simulate day and night
//
uniform samplerCube cube_map1;
uniform samplerCube cube_map2;

//
// blend factor will determine how much
// of each texture is rendered
//
// 0 means cube_map1 will be only rendered
// 1 means cube_map2 will be only rendered
// between (0,1) a fractional amount of each texture will be rendered
//
uniform float       blend_factor;
uniform vec3        fog_color;

const float         lower_limit = 0.0;
const float         upper_limit = 30.0;


void main(void){

  vec4 texture1    = texture(cube_map1,textureCoords);
  vec4 texture2    = texture(cube_map2,textureCoords);
  //
  // mix the two textures together given the blend factor
  //
  vec4 final_color = mix(texture1,texture2,blend_factor);

  // calculate the visibility of the skybox (fog related)
  // a factor of 0 means the fragment is below the lower limit
  // and should just be the fog color
  // and a factor of 1 means the fragment is above
  // the upper limit and should be the color of the skybox
  //
  float factor = (textureCoords.y - lower_limit)/(upper_limit - lower_limit);
  factor       = clamp(factor,0.0,1.0);
  out_color    = mix(vec4(fog_color,1.0), final_color, factor);
}
