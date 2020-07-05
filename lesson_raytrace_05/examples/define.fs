const int   MAX_STEPS    = 100;
const float MAX_DIST     = 100.0;
const float SURFACE_DIST = 0.001;

uniform vec3  camera;
uniform vec3  primary_light;
uniform int   screen_width;
uniform int   screen_height;
uniform float time;

out vec4 out_color;
