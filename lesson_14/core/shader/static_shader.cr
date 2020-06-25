require "../math/**"
require "./program.cr"

class StaticShader < Program

  VERTEX_FILE   = "core/shader/uniform.vs"
  FRAGMENT_FILE = "core/shader/uniform.fs"

  def initialize()
    super(VERTEX_FILE,FRAGMENT_FILE)
  end

  #def load_light(light : Light)
  #  use do
  #    set_uniform_vector("light_position",light.position)
  #    set_uniform_vector("light_color",light.color)
  #  end
  #end
  #
  #def load_view(position : GLM::Vec3)
  #  use do
  #    view  = GLM.translate(position)
  #    set_uniform_matrix_4f("view", view)
  #  end
  #end
  #
  #def load_projection(projection : GLM::Mat4)
  #  use do
  #    set_uniform_matrix_4f("projection", projection)
  #  end
  #end
  #
  #def load_transformation(matrix : GLM::Mat4)
  #  use do
  #    set_uniform_matrix_4f("model", matrix)
  #  end
  #
  #end
end
