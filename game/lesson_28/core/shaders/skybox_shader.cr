require "./program.cr"

class SkyBoxShader < Program

  VERTEX_FILE   = "core/shaders/skybox.vs"
  FRAGMENT_FILE = "core/shaders/skybox.fs"

  def initialize()
    super(VERTEX_FILE,FRAGMENT_FILE)
  end

  def bind_attributes()
    bind_attribute(0,"position")
  end

end
