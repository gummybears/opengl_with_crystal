require "../shader/program.cr"
require "../light.cr"
require "../camera.cr"
require "./renderer.cr"

class MasterRenderer
  property shader   : Program
  property renderer : Renderer

  #property entities : Hash(TextureModel,Array(Entity))
  property entities : Hash(Model,Array(Entity))

  def initialize(shader : Program, fov : Float32, aspect_ratio : Float32, near : Float32, far : Float32, bg : Color)
    @shader  = shader
    @renderer = Renderer.new(shader,fov,aspect_ratio,near,far,bg)
    #@entities = Hash(TextureModel,Array(Entity)).new
    @entities = Hash(Model,Array(Entity)).new
  end

  def render(light : Light, camera : Camera)
    @renderer.prepare()

    @shader.use do

      # light
      @shader.set_uniform_vector("light_position",light.position)
      @shader.set_uniform_vector("light_color",light.color)

      # load view matrix
      view  = GLM.translate(camera.position)
      @shader.set_uniform_matrix_4f("view", view)

      @renderer.render(entities)

    end

    # clear the hash map
    #@entities = Hash(TextureModel,Array(Entity)).new
    @entities = Hash(Model,Array(Entity)).new
  end

  #
  # add entities per Texture model
  #
  def process_entity(entity : Entity)

    # get model per entity
    model = entity.model
    if @entities.has_key?(model)

      list = @entities[model]
      if list.size > 0
        #
        # add entity to the list
        #
        list << entity

      else
        # no list found
        list = [] of Entity
        list << entity

        @entities[model] = list
      end
    end

    if @entities.has_key?(model) == false

      list = [] of Entity
      list << entity

      @entities[model] = list

    end

  end

  def cleanup()
    shader.cleanup()
  end
end
