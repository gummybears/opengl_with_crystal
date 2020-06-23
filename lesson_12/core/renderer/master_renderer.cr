require "../shader/static_shader.cr"
require "../light.cr"
require "../camera.cr"
require "./renderer.cr"

class MasterRenderer
  property shader    : StaticShader
  property renderer  : Renderer
  property entities   : Hash(Model,Array(Entity))

  def initialize(settings : Settings)
    @shader   = StaticShader.new()
    @renderer = Renderer.new(shader,settings)
    @entities = Hash(Model,Array(Entity)).new
  end

  def render(light : Light, camera : Camera)

    @renderer.prepare()
    @shader.use do

      # light
      shader.load_light(light)

      # load view matrix
      shader.load_view(camera.position)

      @renderer.render(entities)
    end

    #
    # Important
    # clear the hash map
    # otherwise the hash map accumulate entities
    # each frame
    #
    @entities = Hash(Model,Array(Entity)).new
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
  end
end
