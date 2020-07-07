vec4 get_distance(vec3 p){
  // rotate the whole scene
  p.xz *= rotate(time * 0.5);

  // Box
  vec3 b0s = vec3(.75,.75,.75);
  vec3 b0p = vec3(0,1,0);
  b0p      = p - b0p;
  vec4 b0  = vec4(box_color.rgb,sdBox(b0p,b0s));

  // Sphere
  vec3 s0p = vec3(0,1,0);
  s0p = p - s0p;
  vec4 s0 = vec4(sphere_color.rgb,sdSphere(s0p,1.05));

  // Cylinders
  float c0h = 1.0;
  float c0r = 0.55;
  vec3 c0p  = p - vec3(0,1,0);
  vec4 c0   = vec4(cylinder_color.rgb,sdCappedCylinder(c0p,c0h,c0r));

  float c1h = 1.,c1r = .55;
  vec3 c1p  = p - vec3(0,1,0);
  c1p.xy   *= rotate(PI*.5);
  vec4 c1   = vec4(cylinder_color.rgb,sdCappedCylinder(c1p,c1h,c1r));

  float c2h = 1.,c2r = .55;
  vec3 c2p  = p - vec3(0,1,0);
  c2p.xy   *= rotate(PI*.5);
  c2p.yz   *= rotate(PI*.5);
  vec4 c2   = vec4(cylinder_color.rgb,sdCappedCylinder(c2p,c2h,c2r));

  // Plane
  vec4 p0 = vec4(ground_color.rgb,sdPlaneNormal(p,vec4(0,1,0,0)));

  vec4 scene = vec4(0), csg0 = vec4(0), csg1 = vec4(0);

  // Intersect box with sphere creating a CSG object.
  csg0 = sdf_intersect(b0,s0);
  csg1 = sdf_union(c0,c1);
  csg1 = sdf_union(csg1,c2);

  // Subtract cylinders from boxsphere
  csg0 = sdf_difference(csg0,csg1);

  // Use Union(min) on the CSG and the ground plane
  scene = sdf_union(csg0,p0);

  //scene = vec4(1,0,1,0.5);
  return scene;
}
