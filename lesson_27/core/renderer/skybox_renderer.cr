require "lib_gl"
require "../shaders/program.cr"

class SkyBoxRenderer

  SKYBOX_SIZE = 500

  property settings   : Settings
  property shader     : SkyBoxShader
  property model      : Model
  property vertices   : Array(Float32)
  property filenames  : Array(String)

  # TODO
  property texture_id : UInt32

  def initialize(projection : GLM::Matrix, settings : Settings)

    @settings = settings
    @shader   = SkyBoxShader.new

    @vertices = [] of Float32
    load_cube_vertices()

    # order of skybox image files is importants
    @filenames = [] of String
    @filenames = [
        "res/skyb ox/right.png",
        "res/skybox/left.png",
        "res/skybox/top.png",
        "res/skybox/bottom.png",
        "res/skybox/back.png",
        "res/skybox/front.png"
    ]

    @model = Model.load(@vertices,3)

    # load textures from the texture files
    # TODO

    @shader.load_projection_matrix(projection)
  end

 def create_view_matrix(camera : Camera)
    r = GLM.translate(camera.position)
    return r
  end

  def render(camera : Camera)

    @shader.use do

      #
      # load view matrix
      #
      view_matrix = camera.view_matrix()
      @shader.load_view_matrix(view_matrix)

      @model.bind()

      LibGL.active_texture(LibGL::TEXTURE0)
      LibGL.bind_texture(LibGL::TEXTURE_CUBE_MAP, @texture_id)
      LibGL.draw_arrays(LibGL::TRIANGLES, 0, @model.nr_vertices)

      @model.unbind()
    end
  end

  def cleanup()
    @shader.cleanup()
  end


  def load_cube_vertices()
    @vertices = [
      -SIZE,  SIZE, -SIZE,
      -SIZE, -SIZE, -SIZE,
       SIZE, -SIZE, -SIZE,
       SIZE, -SIZE, -SIZE,
       SIZE,  SIZE, -SIZE,
      -SIZE,  SIZE, -SIZE,

      -SIZE, -SIZE,  SIZE,
      -SIZE, -SIZE, -SIZE,
      -SIZE,  SIZE, -SIZE,
      -SIZE,  SIZE, -SIZE,
      -SIZE,  SIZE,  SIZE,
      -SIZE, -SIZE,  SIZE,

       SIZE, -SIZE, -SIZE,
       SIZE, -SIZE,  SIZE,
       SIZE,  SIZE,  SIZE,
       SIZE,  SIZE,  SIZE,
       SIZE,  SIZE, -SIZE,
       SIZE, -SIZE, -SIZE,

      -SIZE, -SIZE,  SIZE,
      -SIZE,  SIZE,  SIZE,
       SIZE,  SIZE,  SIZE,
       SIZE,  SIZE,  SIZE,
       SIZE, -SIZE,  SIZE,
      -SIZE, -SIZE,  SIZE,

      -SIZE,  SIZE, -SIZE,
       SIZE,  SIZE, -SIZE,
       SIZE,  SIZE,  SIZE,
       SIZE,  SIZE,  SIZE,
      -SIZE,  SIZE,  SIZE,
      -SIZE,  SIZE, -SIZE,

      -SIZE, -SIZE, -SIZE,
      -SIZE, -SIZE,  SIZE,
       SIZE, -SIZE, -SIZE,
       SIZE, -SIZE, -SIZE,
      -SIZE, -SIZE,  SIZE,
       SIZE, -SIZE,  SIZE
      ]
  end
end

