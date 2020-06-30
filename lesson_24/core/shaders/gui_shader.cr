require "./program.cr"

class GuiShader < Program

  VERTEX_FILE   = "core/shaders/gui.vs"
  FRAGMENT_FILE = "core/shaders/gui.fs"

  def initialize()
    super(VERTEX_FILE,FRAGMENT_FILE)
  end
end
