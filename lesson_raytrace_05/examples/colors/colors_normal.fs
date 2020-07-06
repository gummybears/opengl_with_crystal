vec3 get_normal(vec3 p){

  float d = get_distance(p).w;
  vec2  e = vec2(0.01,0);

  vec3  n = d - vec3(
    get_distance(p - e.xyy).w,
    get_distance(p - e.yxy).w,
    get_distance(p - e.yyx).w
  );

  return normalize(n);
}
