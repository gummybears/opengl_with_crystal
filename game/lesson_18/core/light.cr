class Light
  property position : GLM::Vec3
  property color    : GLM::Vec3

  def initialize(position : GLM::Vec3, color : GLM::Vec3)
    @position = position
    @color    = color
  end
end
