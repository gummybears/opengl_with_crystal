#version 430 core

const int   MAX_STEPS    = 100;
const float MAX_DIST     = 100.0;
const float SURFACE_DIST = 0.001;

uniform int screen_width;
uniform int screen_height;
uniform float time;

out vec4 out_color;

// 2D rotation matrix
mat2 rotate(float a){
  float s = sin(a);
  float c = cos(a);
  return mat2(c,-s,s,c);
}

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

float sd_torus(vec3 p, vec2 r){

  // r.x is the bigger radius of the torus
  // r.y is the smaller radius of the torus

  float x = length(p.xz)- r.x;
  return length(vec2(x, p.y)) - r.y;
}

float sd_box(vec3 p, vec3 size){

  float d = length(max(abs(p) - size, 0));
  return d;
}

float smooth_minimum(float a, float b, float k){

  float h = clamp( 0.5 + 0.5 * (b - a)/k, 0.0, 1.0);
  return mix( b, a, h) - k * h * (1.0 - h);
}

float get_distance(in vec3 p){

  float pd  = sd_plane(p);

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

float get_light(vec3 p){

  // light is just above the sphere
  vec3 light_pos = vec3(0,5,6);

  // moving light
  light_pos.xz = light_pos.xz + vec2(sin(time), cos(time)) * 2.0;

  vec3 l = normalize(light_pos - p);
  vec3 n = get_normal(p);

  // diffuse lighting
  float diffuse = clamp(dot(n,l),0.0,1.0);

  // calculate shadow, raymarch from point 'p'
  // into the direction of the light
  // need to make sure we raise the point 'p'
  // otherwise the ray march will exit as
  // the point 'p' is already close to a surface
  // in this case the plane
  //
  // what we do is set p = p + some small vector
  // Example
  // p = p + n * SURFACE_DIST * 2.0
  //
  float d = ray_march(p + n * SURFACE_DIST * 2.0,l);

  // if the distance 'd' is smaller than light position and surface position
  // then we are in the shadow
  if( d < length(light_pos - p) ){

    // make the diffuse light in the shadow 10 percent bright
    // as outside the shadow

    diffuse = 0.1 * diffuse;
  }


  return diffuse;
}

void main(void){

  vec2 u_resolution = vec2(screen_width, screen_height);
  // make sure (0,0) is in the center of the screen
  vec2 uv = (gl_FragCoord.xy - 0.5*u_resolution.xy)/u_resolution.y;

  vec3 color = vec3(0.0);

  // camera
  vec3 ro    = vec3(0, 2, 0);
  vec3 rd    = normalize(vec3(uv.x,uv.y - 0.2,1));

  float d    = ray_march(ro, rd);

  vec3  p    = ro + d * rd;
  float diff = get_light(p);
  color      = vec3(diff);

  out_color  = vec4(color,1.0);
}
