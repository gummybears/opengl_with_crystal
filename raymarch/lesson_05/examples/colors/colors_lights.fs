vec3 get_light(vec3 p, vec3 c) {
  // Diffuse Color
  vec3 color = c.rgb * color_intensity;

  // Directional light
  vec3 light_pos = primary_light;

  // moving light
  light_pos.xz = light_pos.xz + vec2(sin(time), cos(time)) * 2.0;

  // light Vector
  vec3 l = normalize(light_pos-p);

  // Normal Vector
  vec3 n = get_normal(p);

  // Diffuse light
  float dif = dot(n,l);

  // Clamp so it doesnt go below 0
  dif = clamp(dif,0.,1.);

  // Shadows
  float d = ray_march(p + n * SURFACE_DIST*2.0,l,diffuse_color);

  if( d<length(light_pos-p) ){
    dif *= 0.1;
  }
  return color * dif;
}
