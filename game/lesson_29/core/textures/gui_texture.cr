class GuiTexture

  property id       : UInt32
  property position : GLM::Vector2
  property scale    : GLM::Vector2

  def initialize(id : UInt32, position : GLM::Vector2, scale : GLM::Vector2)
    @id       = id
    @position = position
    @scale    = scale
  end

end
