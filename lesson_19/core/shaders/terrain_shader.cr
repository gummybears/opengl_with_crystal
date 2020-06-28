require "./program.cr"

class TerrainShader < Program

  VERTEX_FILE   = "core/shaders/terrain.vs"
  FRAGMENT_FILE = "core/shaders/terrain.fs"

  def initialize()
    super(VERTEX_FILE,FRAGMENT_FILE)
  end
end
