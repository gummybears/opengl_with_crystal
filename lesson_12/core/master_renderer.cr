require "./shader/program.cr"
require "./light.cr"
require "./camera.cr"
require "./renderer.cr"

class MasterRenderer
  property shader   : Program
  property renderer : Renderer

  ## for now use string as key ??
  #property entities : Hash(String,Entity)

  def initialize(shader : Program, renderer : Renderer)
    @shader = shader
    @renderer = renderer
  end

  def render(sun : Light, camera : Camera)
    @renderer.prepare()

    @shader.use do

      # light
      @shader.set_uniform_vector("light_position",@light.position)
      @shader.set_uniform_vector("light_color",@light.color)

      # projection matrix
      view  = GLM.translate(@camera.position)
      @shader.set_uniform_matrix_4f("view", view)

    end

    # clear the hash map
    @entities.clear()
  end

  def cleanup()
    shader.cleanup()
  end
end
