// 2D rotation matrix
mat2 rotate(float a){
  float s = sin(a);
  float c = cos(a);
  return mat2(c,-s,s,c);
}

//
// returns a transformation matrix that will transform a ray from view space
// to world coordinates, given the eye point, the camera target, and an up vector.
//
// This assumes that the center of the camera is aligned with the negative z axis in
// view space when calculating the ray marching direction.
//
mat4 view_matrix(vec3 camera, vec3 center, vec3 up) {
  vec3 f = normalize(center - camera);
  vec3 s = normalize(cross(f, up));
  vec3 u = cross(s, f);
  return mat4(
    vec4(s, 0.0),
    vec4(u, 0.0),
    vec4(-f, 0.0),
    vec4(0.0, 0.0, 0.0, 1)
  );
}

