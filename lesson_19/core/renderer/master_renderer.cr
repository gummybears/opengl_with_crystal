require "../shaders/static_shader.cr"
require "../shaders/terrain_shader.cr"
require "../light.cr"
require "../camera.cr"

require "./entity_renderer.cr"
require "./terrain_renderer.cr"

require "../entities/terrain.cr"

class MasterRenderer
  property settings   : Settings
  property shader     : StaticShader
  property renderer   : EntityRenderer
  property entities   : Hash(TextureModel,Array(Entity))
  property projection : GLM::Mat4

  property terrain_renderer : TerrainRenderer
  property terrain_shader   : TerrainShader
  property terrains         : Array(Terrain)

  def initialize(settings : Settings)

    @settings       = settings

    @terrains       = [] of Terrain

    @shader         = StaticShader.new()
    @terrain_shader = TerrainShader.new()

    #
    # cull all faces which are invisible for the camera
    #
    enable_culling()

    #
    # create projection matrix
    #
    @projection       = create_projection_matrix(settings.fov,settings.aspect_ratio,settings.near,settings.far)

    @renderer         = EntityRenderer.new(@shader,@projection,settings)
    @terrain_renderer = TerrainRenderer.new(@terrain_shader,@projection,settings)

    @entities         = Hash(TextureModel,Array(Entity)).new

  end

  # enable/disable back face culling
  def enable_culling()
    LibGL.enable(LibGL::CULL_FACE)
    LibGL.cull_face(LibGL::BACK)
  end

  def disable_culling()
    LibGL.disable(LibGL::CULL_FACE)
  end

  def prepare()
    LibGL.enable(LibGL::DEPTH_TEST)
    LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
    LibGL.clear_color(@settings.bg.red, @settings.bg.green, @settings.bg.blue, @settings.bg.opacity)
  end

  #
  # create projection matrix (perspective projection)
  #
  def create_projection_matrix(fov : Float32, aspect_ratio : Float32, near : Float32, far : Float32)
    GLM.perspective(fov,aspect_ratio,near, far)
  end

  #
  # new view matrix, old matrix is wrong
  #
  def org_create_view_matrix(camera : Camera)
    camera.position.y = -1.0f32 * camera.position.y
    GLM.translation(camera.position)
  end

  def create_view_matrix(camera : Camera)
    matrix = GLM::Mat4.identity()
    x_axis = GLM::Vec3.new(1,0,0)
    y_axis = GLM::Vec3.new(0,1,0)
    pitch  = camera.pitch
    yaw    = camera.yaw

    pitch_radians = GLM.radians(pitch)
    yaw_radians   = GLM.radians(yaw)

    #
    # rotate the matrix matrix 'pitch' radians around the x axis
    #
    matrix = GLM.rotate(matrix, pitch_radians, x_axis)

    #
    # rotate the matrix matrix 'yaw' radians around the x axis
    #
    matrix = GLM.rotate(matrix, yaw_radians, y_axis)

    negative_camera_pos = GLM::Vec3.new(-1.0f32 * camera.position.x, -1.0f32 * camera.position.y, -1.0f32 * camera.position.z)
    matrix = GLM.translate(matrix, negative_camera_pos)

    return matrix
  end

  def render(light : Light, camera : Camera)

    prepare()
    # old code view_matrix = create_view_matrix(camera.position)

    #puts "master renderer camera pos #{camera.position.to_s}"
    view_matrix = create_view_matrix(camera)

    @shader.use do

      # load sky color
      @shader.load_sky_color(@settings.bg.red,@settings.bg.green,@settings.bg.blue)
      # light
      @shader.load_light(light)
      # load view matrix
      #@shader.load_view_matrix(camera.position)
      @shader.load_view_matrix(view_matrix)

      @renderer.render(@entities)
    end

    @terrain_shader.use do
      # load sky color
      @terrain_shader.load_sky_color(@settings.bg.red,@settings.bg.green,@settings.bg.blue)
      # light
      @terrain_shader.load_light(light)
      # load view matrix
      #@terrain_shader.load_view_matrix(camera.position)
      @terrain_shader.load_view_matrix(view_matrix)

      # render terrains
      @terrain_renderer.render(@terrains)
    end

    #
    # Important
    # clear the hash map
    # otherwise the hash map accumulate entities
    # each frame
    #
    @entities = Hash(TextureModel,Array(Entity)).new
    @terrains = [] of Terrain
  end

  def process_terrain(terrain : Terrain)
    @terrains << terrain
  end

  def process_terrains(terrains : Array(Terrain))
    if terrains.size > 0
      @terrains = terrains.dup
    end
  end

  #
  # add entities per Texture model
  #
  def process_entity(entity : Entity)

    # get model per entity
    model = entity.model

    # is the model present in our hash ?
    if @entities.has_key?(model)

      list = @entities[model]
      if list.size > 0
        #
        # add entity to the list
        #
        list << entity

      else
        #
        # no list found
        #
        list = [] of Entity
        list << entity

        @entities[model] = list
      end
    end

    #
    # model is not present
    #
    if @entities.has_key?(model) == false

      list = [] of Entity
      list << entity
      @entities[model] = list
    end

  end

  def cleanup()
    @shader.cleanup()
    @terrain_shader.cleanup()
  end

end
