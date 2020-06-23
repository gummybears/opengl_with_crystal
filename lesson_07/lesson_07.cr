require "lib_gl"
require "crystglfw"
include CrystGLFW

require "./core/**"
require "./models/cube.cr"

def lesson_07(title : String = "OpenGL lesson 7, multiple cubes", width : Float32 = 1080f32, height : Float32 = 810f32)

  vertexshader   = "shaders/test_transform.vs"
  fragmentshader = "shaders/test_transform.fs"
  texture_file   = "res/bricks.png"

  vertices, indices, textures = cube()
  bg = Color.new(0.2,0.3,0.3,1.0)

  positions = [] of GLM::Vec3
  rotations = [] of GLM::Vec3
  scales    = [] of GLM::Vec3

  positions << GLM::Vec3.new(0, 0, -20)
  rotations << GLM::Vec3.new(0, 0, 0)
  scales    << GLM::Vec3.new(0, 0, 0)

  positions << GLM::Vec3.new(3, 0, -20)
  rotations << GLM::Vec3.new(0, 45, 0)
  scales    << GLM::Vec3.new(0, 0,  0)

  positions << GLM::Vec3.new(1, 0, -10)
  rotations << GLM::Vec3.new(45, 45, 0)
  scales    << GLM::Vec3.new(0, 0, 0)

  positions << GLM::Vec3.new(2, 0, -20)
  rotations << GLM::Vec3.new(0, 45, 45)
  scales    << GLM::Vec3.new(0, 0,  0)

  fov          = 45.0f32
  z_near       = 0.1f32
  z_far        = 100.0f32
  aspect_ratio = (width/height).to_f32
  camerapos    = GLM::Vec3.new(0,0,0)

  entities = [] of Entity

  CrystGLFW.run do

    display = Display.new(title, width, height, fov, z_near, z_far, bg)

    # plain model
    model = Model.load(vertices,indices,textures)
    # with a texture
    static_model = TextureModel.new(model,texture_file)

    positions.each_with_index do |pos,i|
      entities << Entity.new(static_model,pos,rotations[i],scales[i])
    end

    camera        = Camera.new(camerapos)
    shaderprogram = ShaderProgram.new(vertexshader,fragmentshader)
    display.render(entities,shaderprogram,camera)
  end
end

lesson_07()
