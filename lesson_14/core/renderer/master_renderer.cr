require "../shader/static_shader.cr"
require "../shader/terrain_shader.cr"
require "../light.cr"
require "../camera.cr"

require "./entity_renderer.cr"
require "./terrain_renderer.cr"

require "../entities/terrain.cr"

class MasterRenderer
  property settings   : Settings
  property shader     : StaticShader
  property renderer   : EntityRenderer
  property entities   : Hash(Model,Array(Entity))
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
    MasterRenderer.enable_culling()

    #
    # create projection matrix
    #
    @projection       = create_projection(settings.fov,settings.aspect_ratio,settings.near,settings.far)

    @renderer         = EntityRenderer.new(@shader,@projection,settings)
    @terrain_renderer = TerrainRenderer.new(@terrain_shader,@projection,settings)

    @entities         = Hash(Model,Array(Entity)).new

  end

  # enable/disable back face culling
  def self.enable_culling()
    LibGL.enable(LibGL::CULL_FACE)
    LibGL.cull_face(LibGL::BACK)
  end

  def self.disable_culling()
    LibGL.disable(LibGL::CULL_FACE)
  end

  #
  # create perspective matrix
  #
  def create_projection(fov : Float32, aspect_ratio : Float32, near : Float32, far : Float32)
    GLM.perspective(fov,aspect_ratio,near, far)
  end

  def render(light : Light, camera : Camera)

    # @renderer.prepare()
    prepare()
    @shader.use do

      # light
      @shader.load_light(light)

      # load view matrix
      @shader.load_view(camera.position)

      @renderer.render(entities)
    end

    @terrain_shader.use do

      # light
      @terrain_shader.load_light(light)

      # load view matrix
      @terrain_shader.load_view(camera.position)

      # render terrains
      @terrain_renderer.render(terrains)
    end

    #
    # Important
    # clear the hash map
    # otherwise the hash map accumulate entities
    # each frame
    #
    @entities = Hash(Model,Array(Entity)).new
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

  def prepare()
    LibGL.enable(LibGL::DEPTH_TEST)
    LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
    LibGL.clear_color(@settings.bg.red, @settings.bg.green, @settings.bg.blue, @settings.bg.opacity)
  end

end
