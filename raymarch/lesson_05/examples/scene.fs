
float get_distance(in vec3 p){

  float pd  = sdPlane(p);

  // union of two sphere
  float sda = length(p-vec3(0,1,7)) - 1.0;
  float sdb = length(p-vec3(1,1,7)) - 1.0;
  float sd1 = smooth_minimum(sda,sdb, 0.2);

  // subtract one sphere from the other sphere
  float sdc = length(p-vec3(-2,1,7)) - 1.0;
  float sdd = length(p-vec3(-3,1,7)) - 1.0;
  float sd2 = max(-sdc,sdd);

  // intersection of one sphere with another sphere
  float sde = length(p-vec3(3,1,7)) - 1.0;
  float sdf = length(p-vec3(4,1,7)) - 1.0;
  float sd3 = max(sde,sdf);

  float d = min(sd1,pd);
  d = min(d,sd2);
  d = min(d,sd3);

  return d;
}
