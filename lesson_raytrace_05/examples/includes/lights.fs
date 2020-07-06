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
