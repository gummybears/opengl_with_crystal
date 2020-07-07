vec4 get_distance(vec3 p){
  // Octahedron

  // Position
  vec3 o0p = vec3(-3,1,7);
  o0p = p - o0p;

  // rotate on one axis
  o0p.xy *= rotate(-time);
  o0p.xz *= rotate(-time);
  vec4 o0 = vec4(octahedron_color.rgb,sdOctahedron(o0p,1.0));

  // Link
  vec3 l0p = vec3(0,1,6);
  l0p      = p-l0p;
  l0p.xz  *= rotate(-time);
  l0p.xy  *= rotate(-time);
  vec4 l0  = vec4(link_color.rgb,sdLink(l0p,.2,.5,.2));

  // Box
  vec3 b0p = vec3(3,1,7);
  b0p      = p - b0p;
  b0p.xy  *= rotate(time);
  b0p.xz  *= rotate(time);
  vec4 b0  = vec4(box_color.rgb,sdRoundBox(b0p,vec3(.5,.5,.5),.1));

  // Plane
  vec4 p0 = vec4(ground_color.rgb,sdPlaneNormal(p,vec4(0,1,0,0)));

  // Scene
  vec4 scene = vec4(0);
  scene      = sdf_union(l0,o0);
  scene      = sdf_union(scene,b0);
  scene      = sdf_union(scene,p0);

  return scene;
}
