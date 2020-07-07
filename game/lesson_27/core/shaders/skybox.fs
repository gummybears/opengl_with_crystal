#version 400 core

in vec3  textureCoords;
out vec4 out_color;

uniform samplerCube cube_map;

void main(void){
  out_color = texture(cube_map,textureCoords);
}
