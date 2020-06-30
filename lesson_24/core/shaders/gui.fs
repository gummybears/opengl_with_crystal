#version 400 core

in vec2  textureCoords;
out vec4 out_color;

uniform sampler2D gui_texture;

void main(void){
  out_color = texture(gui_texture,textureCoords);
}
