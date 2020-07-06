#version 430 core

// include examples/includes/define.fs
// include examples/includes/math.fs
// include examples/includes/sdf.fs
// include examples/includes/operations.fs
// include examples/scene.fs
// include examples/includes/raymarch.fs
// include examples/includes/normal.fs
// include examples/includes/shadow.fs
// include examples/includes/lights.fs

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
  float d    = ray_march(ro, rd);

  // determine the lighting for this distance 'd'
  vec3  p    = ro + d * rd;
  float diff = get_light(p);
  color      = vec3(diff);

  out_color  = vec4(color,1.0);
}
