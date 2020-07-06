//
// Boolean Operators
//
vec4 sdf_intersect(vec4 a, vec4 b) {
  return a.w > b.w ? a : b;
}

vec4 sdf_union(vec4 a, vec4 b) {
  return a.w < b.w? a : b;
}

vec4 sdf_difference(vec4 a, vec4 b) {
  return a.w > -b.w? a : vec4(b.rgb,-b.w);
}
