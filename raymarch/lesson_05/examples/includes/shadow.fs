
//
// calculate shadow, raymarch from point 'p'
// into the direction of the light
// need to make sure we raise the point 'p'
// otherwise the ray march will exit as
// the point 'p' is already close to a surface
// in this case the plane
//
// what we do is set p = p + some small vector
// Example
// p = p + n * SURFACE_DIST * 2.0
//
float calculate_shadow(vec3 p, vec3 normal, vec3 light_pos) {

  float shadow_factor = 1.0;

  vec3  l = normalize(light_pos - p);
  float d = ray_march(p + normal * SURFACE_DIST * 2.0,l);

  //
  // if the distance 'd' is smaller than light position and surface position
  // then we are in the shadow
  //
  if( d < length(light_pos - p) ){

    // make the diffuse light in the shadow 10 percent bright
    // as outside the shadow

    shadow_factor = 0.1;
  }

  return shadow_factor;
}
