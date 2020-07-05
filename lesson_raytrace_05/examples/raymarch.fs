float ray_march(in vec3 ro, in vec3 rd){

  float dzero = 0.0;
  float dS    = 0.0;
  vec3  p     = vec3(0.0,0.0,0.0);

  for(int i = 0; i < MAX_STEPS; i++){

    p     = ro + dzero * rd;
    dS    = get_distance(p);
    dzero = dzero + dS;

    if( dS < SURFACE_DIST ){
      break;
    }

    if( dzero > MAX_DIST ){
      break;
    }
  }

  return dzero;
}
