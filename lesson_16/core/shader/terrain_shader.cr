require "../math/**"
require "./program.cr"

class TerrainShader < Program

  VERTEX_FILE   = "core/shader/terrain.vs"
  FRAGMENT_FILE = "core/shader/terrain.fs"

  def initialize()
    super(VERTEX_FILE,FRAGMENT_FILE)
  end
end
