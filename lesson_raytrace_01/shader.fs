#version 430 core

out vec4 out_color;

float distance_from_sphere(in vec3 p, in vec3 c, float r) {
  return length(p - c) - r;
}

vec2 obj_union(in vec2 obj0, in vec2 obj1){
  if (obj0.x < obj1.x){
    return obj0;
  } else {
    return obj1;
  }
}

float map_the_world(in vec3 p){
  float sphere_0 = distance_from_sphere(p, vec3(0.0), 1.0);
  float sphere_1 = distance_from_sphere(p, vec3(0.0,2.0,5.0), 1.0);

  // Later we might have sphere_1, sphere_2, cube_3, etc...
  return sphere_1; //sphere_1;
}

vec3 calculate_normal(in vec3 p) {
  const vec3 small_step = vec3(0.001, 0.0, 0.0);

  float gradient_x = map_the_world(p + small_step.xyy) - map_the_world(p - small_step.xyy);
  float gradient_y = map_the_world(p + small_step.yxy) - map_the_world(p - small_step.yxy);
  float gradient_z = map_the_world(p + small_step.yyx) - map_the_world(p - small_step.yyx);

  vec3 normal = vec3(gradient_x, gradient_y, gradient_z);
  return normalize(normal);
}

vec3 ray_march(in vec3 ro, in vec3 rd){
  float total_distance_traveled = 0.0;
  const int NUMBER_OF_STEPS = 32;
  const float MINIMUM_HIT_DISTANCE = 0.001;
  const float MAXIMUM_TRACE_DISTANCE = 1000.0;

  for(int i = 0; i < NUMBER_OF_STEPS; i++){
    vec3 current_position = ro + total_distance_traveled * rd;

    float distance_to_closest = map_the_world(current_position);

    if (distance_to_closest < MINIMUM_HIT_DISTANCE) {

      vec3 normal = calculate_normal(current_position);
      // For now, hard-code the light's position in our scene
      vec3 light_position = vec3(2.0, -5.0, 3.0);

      // Calculate the unit direction vector that points from
      // the point of intersection to the light source
      vec3 direction_to_light = normalize(current_position - light_position);

      float diffuse_intensity = max(0.0, dot(normal, direction_to_light));

      return vec3(1.0, 0.0, 0.0) * diffuse_intensity;
    }

    if (total_distance_traveled > MAXIMUM_TRACE_DISTANCE){
      break;
    }

    total_distance_traveled += distance_to_closest;
  }
  return vec3(0.0);
}

void main(void){

    vec2 u_resolution = vec2(1920,1080);
    vec2 uv = (gl_FragCoord.xy - 0.5*u_resolution.xy)/u_resolution.y;

    vec3 camera_position = vec3(0.0, 0.0, -5.0);
    vec3 ro = camera_position;
    vec3 rd = vec3(uv, 1.0);

    vec3 shaded_color = ray_march(ro, rd);
    out_color = vec4(shaded_color, 1.0);
}
