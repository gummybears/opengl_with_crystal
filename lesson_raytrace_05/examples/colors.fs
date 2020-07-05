#version 430 core

// include examples/define.fs
// include examples/math.fs
// include examples/sdf.fs
// include examples/operations.fs

const vec4 ground_color     = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 octahedron_color = vec4(1,0,0,1);
const vec4 link_color       = vec4(0,1,0,1);
const vec4 box_color        = vec4(0,0,1,1);
vec3 sd_color               = vec3(1.0, 1.0, 1.0);

// include examples/colors_scene.fs

float ray_march(in vec3 ro, in vec3 rd, inout vec3 sd_color){

  float dO = 0.0;
  vec4  dS = vec4(0.0);
  vec3  p  = vec3(0.0,0.0,0.0);

  for(int i = 0; i < MAX_STEPS; i++){

    p     = ro + dO * rd;
    dS    = get_distance(p);

    if( dS.w < SURFACE_DIST ){
      sd_color = dS.rgb;
      break;
    }

    if( dO > MAX_DIST ){
      break;
    }

    dO = dO + dS.w;

  }

  return dO;
}

float get_light(vec3 p){

  vec3 light_pos = primary_light;

  // moving light
  light_pos.xz = light_pos.xz + vec2(sin(time), cos(time)) * 2.0;

  vec3 l = normalize(light_pos - p);
  vec3 n = get_normal(p);

  // diffuse lighting
  float diffuse       = clamp(dot(n,l),0.0,1.0);
  float shadow_factor = calculate_shadow(p,n,light_pos);
  diffuse = shadow_factor * diffuse;

  return diffuse;
}

// include examples/normal.fs
// include examples/shadow.fs

void main(void){

  vec2 u_resolution = vec2(screen_width, screen_height);
  // make sure (0,0) is in the center of the screen
  vec2 uv = (gl_FragCoord.xy - 0.5*u_resolution.xy)/u_resolution.y;

  vec3 color = vec3(0.0);

  // camera
  vec3 ro    = camera;
  vec3 rd    = normalize(vec3(uv.x,uv.y - 0.2,1));

  // moving camera
  ro.xz = ro.xz + vec2(sin(time), cos(time)) * 0.5;

  // ray march for this uv point
  float d    = ray_march(ro, rd, sd_color);

  // determine the lighting for this distance 'd'
  vec3  p    = ro + d * rd;
  float diff = get_light(p);
  color      = vec3(diff);

  out_color  = vec4(color,1.0);
}
