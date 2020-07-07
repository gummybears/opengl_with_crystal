vec3 get_normal(vec3 p){

  float d = get_distance(p);
  vec2  e = vec2(0.01,0);

  vec3  n = d - vec3(
    get_distance(p - e.xyy),
    get_distance(p - e.yxy),
    get_distance(p - e.yyx)
  );

  return normalize(n);
}
