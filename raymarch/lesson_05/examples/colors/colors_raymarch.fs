float ray_march(in vec3 ro, in vec3 rd, inout vec3 diff_color){

  float dzero = 0.0;
  vec4  ds    = vec4(0.0);
  vec3  p     = vec3(0.0,0.0,0.0);

  for(int i = 0; i < MAX_STEPS; i++){

    p     = ro + dzero * rd;
    ds    = get_distance(p);

    if( ds.w < SURFACE_DIST ){
      diff_color = ds.rgb;
      break;
    }

    if( dzero > MAX_DIST ){
      break;
    }

    dzero = dzero + ds.w;

  }

  return dzero;
}
