float calculate_shadow(vec3 p, vec3 normal, vec3 light_pos) {

  float shadow_factor = 1.0;

  vec3  l = normalize(light_pos - p);
  float d = ray_march(p + normal * SURFACE_DIST * 2.0,l, sd_color);

  if( d < length(light_pos - p) ){

    // make the diffuse light in the shadow 10 percent bright
    // as outside the shadow

    shadow_factor = 0.1;
  }

  return shadow_factor;
}
