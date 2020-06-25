require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./core/**"
require "./models/twotriangles.cr"

def lesson(title : String = "OpenGL lesson 6, Uniforms", width : Float32 = 1080f32, height : Float32 = 810f32)

  vertexshader   = "shaders/test_transform.vs"
  fragmentshader = "shaders/test_transform.fs"
  texture_file   = "res/bricks.png"

  vertices, indices, textures = twotriangles()
  bg = Color.new(0.2,0.3,0.3,1.0)

  position = GLM::Vec3.new(0.0f32, 0.0f32, 0.0f32)
  rotation = GLM::Vec3.new(0.0f32, 0.0f32, 0.0f32)
  scale    = GLM::Vec3.new(0.0f32, 0.0f32, 0.0f32)

  fov          = 45.0f32
  z_near       = 0.1f32
  z_far        = 100.0f32
  aspect_ratio = (width/height).to_f32
  camerapos    = GLM::Vec3.new(0.0f32,0.0f32,-2.0f32)

  CrystGLFW.run do

    display = Display.new(title, width, height, fov, z_near, z_far, bg)

    # plain model
    model = Model.load(vertices,indices,textures)
    # with a texture
    static_model = TextureModel.new(model,texture_file)

    entity        = Entity.new(static_model,position,rotation,scale)
    camera        = Camera.new(camerapos)
    shaderprogram = ShaderProgram.new(vertexshader,fragmentshader)
    display.render(entity,shaderprogram,camera)
  end
end

lesson()
