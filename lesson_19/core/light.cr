class Light
  property position : GLM::Vector3
  property color    : GLM::Vector3

  def initialize(position : GLM::Vector3, color : GLM::Vector3)
    @position = position
    @color    = color
  end
end
