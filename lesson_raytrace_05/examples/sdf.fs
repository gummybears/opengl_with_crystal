float sd_plane(vec3 p){
  return p.y;
}

float sd_sphere(vec3 p, vec3 c, float r) {
  return length(p - c) - r;
}

float sd_capsule(vec3 p, vec3 a, vec3 b, float r){

  vec3 ab = b - a;
  vec3 ap = p - a;

  float t = dot(ab,ap)/dot(ab,ab);
  t = clamp(t,0.0,1.0);

  vec3 c = a + t * ab;
  return length(p - c) - r;
}

float sd_cylinder(vec3 p, vec3 a, vec3 b, float r){

  vec3 ab = b - a;
  vec3 ap = p - a;

  float t = dot(ab,ap)/dot(ab,ab);

  vec3  c = a + t * ab;

  float x = length(p - c) - r;
  float y = (abs(t - 0.5) - 0.5) * length(ab);
  float e = length(max(vec2(x,y), 0));
  float i = min(max(x,y),0);

  return e + i;
}

// r.x is the bigger radius of the torus
// r.y is the smaller radius of the torus
float sd_torus(vec3 p, vec2 r){

  float x = length(p.xz)- r.x;
  return length(vec2(x, p.y)) - r.y;
}

float sd_box(vec3 p, vec3 size){
  float d = length(max(abs(p) - size, 0));
  return d;
}

// Link - exact
float sd_link(vec3 p,float le,float r1,float r2) {
  vec3 q = vec3(p.x,max(abs(p.y)-le,0.),p.z);
  return length(vec2(length(q.xy)-r1,q.z)) - r2;
}

// Octahedron - exact
float sd_octahedron(vec3 p,float s) {
  vec3 q;

  p=abs(p);
  float m = p.x + p.y + p.z - s;

  if(3.*p.x<m){
    q = p.xyz;
  } else if(3.*p.y<m) {
    q = p.yzx;
  } else if(3.*p.z<m) {
    q = p.zxy;
  } else {
    return m*0.57735027;
  }

  float k = clamp(.5*(q.z-q.y+s),0.,s);
  return length(vec3(q.x,q.y-s+k,q.z-k));
}

float smooth_minimum(float a, float b, float k){

  float h = clamp( 0.5 + 0.5 * (b - a)/k, 0.0, 1.0);
  return mix( b, a, h) - k * h * (1.0 - h);
}
