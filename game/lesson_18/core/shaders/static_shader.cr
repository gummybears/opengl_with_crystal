require "../math/**"
require "./program.cr"

class StaticShader < Program

  VERTEX_FILE   = "core/shaders/uniform.vs"
  FRAGMENT_FILE = "core/shaders/uniform.fs"

  def initialize()
    super(VERTEX_FILE,FRAGMENT_FILE)
  end
end
