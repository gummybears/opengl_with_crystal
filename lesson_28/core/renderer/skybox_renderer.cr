require "lib_gl"
require "../shaders/program.cr"

class SkyBoxRenderer

  SKYBOX_SIZE = 500f32
  #
  # rotation of the sky is 1 degree per second
  #
  # Note:
  # In the Java tutorial, lesson 28,
  # the rotation is calculated
  # in the skybox shader
  #
  ROTATE_SPEED = 1f32

  property settings    : Settings
  property shader      : SkyBoxShader
  property model       : Model
  property vertices    : Array(Float32)

  # old code property filenames  : Array(String)

  property texture_id1 : UInt32 = 0
  property texture_id2 : UInt32 = 0
  property rotation    : Float32 = 0f32

  def initialize(projection : GLM::Matrix, settings : Settings)

    @settings = settings
    @shader   = SkyBoxShader.new

    @vertices = [] of Float32
    load_cube_vertices()

    #
    # order of skybox image files is importants
    #
    filenames = [
        "res/skybox/right.png",
        "res/skybox/left.png",
        "res/skybox/top.png",
        "res/skybox/bottom.png",
        "res/skybox/back.png",
        "res/skybox/front.png"
    ]
    #
    # load textures from the texture files
    #
    @texture_id1 = Texture.load_cube_map(filenames)

    #
    # order of skybox image files is importants
    #
    filenames = [
        "res/skybox/right.png",
        "res/skybox/left.png",
        "res/skybox/top.png",
        "res/skybox/bottom.png",
        "res/skybox/back.png",
        "res/skybox/front.png"
    ]
    #
    # load textures from the texture files
    #
    @texture_id1 = Texture.load_cube_map(filenames)

    #
    # order of night skybox image files is importants
    #
    filenames = [
        "res/skybox/nightRight.png",
        "res/skybox/nightLeft.png",
        "res/skybox/nightTop.png",
        "res/skybox/nightBottom.png",
        "res/skybox/nightBack.png",
        "res/skybox/nightFront.png"
    ]
    #
    # load textures from the texture files
    #
    @texture_id2 = Texture.load_cube_map(filenames)

    @model = Model.load(@vertices,3)
    @shader.load_projection_matrix(projection)
  end

  # old code #
  # old code # load view matrix but disable any translation
  # old code # coming from the camera
  # old code # the sky needs to be at 'infinity'
  # old code # so the player cannot walk into the sky box
  # old code #
  # old code def create_view_matrix(camera : Camera)
  # old code   view_matrix = camera.view_matrix()
  # old code   view_matrix[0,3] = 0f32
  # old code   view_matrix[1,3] = 0f32
  # old code   view_matrix[2,3] = 0f32
  # old code
  # old code end

  def render(camera : Camera, color : Color) # old code red : UInt8, green : UInt8, blue : UInt8)

    #
    # load view matrix but disable any translation
    # coming from the camera
    # the sky needs to be at 'infinity'
    # so the player cannot walk into the sky box
    #
    seconds     = Game.elapsed
    @rotation   = @rotation + ROTATE_SPEED * seconds

    view_matrix = camera.view_matrix()

    #
    # disable the translation
    #
    view_matrix[0,3] = 0f32
    view_matrix[1,3] = 0f32
    view_matrix[2,3] = 0f32

    #
    # apply the rotation to the view matrix
    # to simulate a rotating skybox
    #
    y_axis = GLM::Vector3.new(0,1,0)
    #
    # either clockwise (+) or counter-clockwise (-) rotation
    # here counter clock wise rotation
    #
    angle_radians = -GLM.radians(@rotation)
    view_matrix   = GLM.rotate(view_matrix, angle_radians, y_axis)

    @shader.connect_skybox_units()
    @shader.load_view_matrix(view_matrix)
    @shader.load_fogcolor(color) # old code red,green,blue)

    @model.bind()

    # old code LibGL.active_texture(LibGL::TEXTURE0)
    # old code LibGL.bind_texture(LibGL::TEXTURE_CUBE_MAP, @texture_id1)

    bind_textures()
    LibGL.draw_arrays(LibGL::TRIANGLES, 0, @model.nr_vertices)

    @model.unbind()

  end

  #
  # bind the two texture cube maps
  #
  def bind_textures()

    LibGL.active_texture(LibGL::TEXTURE0)
    LibGL.bind_texture(LibGL::TEXTURE_CUBE_MAP, @texture_id1)

    LibGL.active_texture(LibGL::TEXTURE1)
    LibGL.bind_texture(LibGL::TEXTURE_CUBE_MAP, @texture_id2)

    @shader.load_blendfactor(0.5f32)
  end

  def cleanup()
    @shader.cleanup()
  end

  def load_cube_vertices()
    @vertices = [
      -SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,
      -SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,
       SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,
       SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,
      -SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,

      -SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE,
      -SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,
      -SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,
      -SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,
      -SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
      -SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE,

       SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,
       SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,
       SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,

      -SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE,
      -SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE,
      -SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE,

      -SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
      -SKYBOX_SIZE,  SKYBOX_SIZE,  SKYBOX_SIZE,
      -SKYBOX_SIZE,  SKYBOX_SIZE, -SKYBOX_SIZE,

      -SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,
      -SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,
       SKYBOX_SIZE, -SKYBOX_SIZE, -SKYBOX_SIZE,
      -SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE,
       SKYBOX_SIZE, -SKYBOX_SIZE,  SKYBOX_SIZE
      ]
  end
end

