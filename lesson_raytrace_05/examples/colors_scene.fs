vec4 get_distance(in vec3 p){

  // Octahedron
  vec3 op = vec3(-3,1,7);
  op = p - op;
  // rotate on one axis
  op.xy *= rotate(-u_time);
  op.xz *= rotate(-u_time);
  vec4 o0 = vec4(octahedron_color.rgb,sd_octahedron(op,1.));

  // Link
  vec3 lp = vec3(0,1,6);
  lp = p - lp;
  lp.xz *= rotate(-u_time);
  lp.xy *= rotate(-u_time);
  vec4 l0 = vec4(link_color.rgb,sd_link(lp,.2,.5,.2));

  // Box
  vec3 b0p = vec3(3,1,7);
  b0p = p - b0p;
  b0p.xy *= rotate(u_time);
  b0p.xz *= rotate(u_time);
  vec4 b0 = vec4(box_color.rgb,sd_roundbox(b0p,vec3(.5,.5,.5),.1));

  // Plane
  vec4 p0 = vec4(ground_color.rgb,sd_plane(p,vec4(0,1,0,0)));

  // Scene
  vec4 scene = vec4(0);
  scene = sd_union(l0,o0);
  scene = sd_union(scene,b0);
  scene = sd_union(scene,p0);

  return scene;
}
