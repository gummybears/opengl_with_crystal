require "lib_gl"
require "../shaders/program.cr"

class SkyBoxRenderer

  SKYBOX_SIZE = 500f32

  property settings   : Settings
  property shader     : SkyBoxShader
  property model      : Model
  property vertices   : Array(Float32)
  property filenames  : Array(String)
  property texture_id : UInt32 = 0

  def initialize(projection : GLM::Matrix, settings : Settings)

    @settings = settings
    @shader   = SkyBoxShader.new

    @vertices = [] of Float32
    load_cube_vertices()

    #
    # order of skybox image files is importants
    #
    @filenames = [] of String
    @filenames = [
        "res/skybox/right.png",
        "res/skybox/left.png",
        "res/skybox/top.png",
        "res/skybox/bottom.png",
        "res/skybox/back.png",
        "res/skybox/front.png"
    ]

    @model = Model.load(@vertices,3)

    #
    # load textures from the texture files
    #
    @texture_id = Texture.load_cube_map(@filenames)

    @shader.load_projection_matrix(projection)
  end

  def render(camera : Camera)

    #
    # load view matrix but disable any translation
    # coming from the camera
    # the sky needs to be at 'infinity'
    # so the player cannot cross it
    #
    view_matrix = camera.view_matrix()
    view_matrix[0,3] = 0f32
    view_matrix[1,3] = 0f32
    view_matrix[2,3] = 0f32

    @shader.load_view_matrix(view_matrix)

    @model.bind()

    LibGL.active_texture(LibGL::TEXTURE0)
    LibGL.bind_texture(LibGL::TEXTURE_CUBE_MAP, @texture_id)
    LibGL.draw_arrays(LibGL::TRIANGLES, 0, @model.nr_vertices)

    @model.unbind()

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

