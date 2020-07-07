class Light
  property position    : GLM::Vector3
  property color       : GLM::Vector3
  property attenuation : GLM::Vector3

  def initialize(position : GLM::Vector3, color : GLM::Vector3)
    @position    = position
    @color       = color
    @attenuation = GLM::Vector3.new(1f32,0f32,0f32)
  end

  def initialize(position : GLM::Vector3, color : GLM::Vector3, attenuation : GLM::Vector3)
    @position    = position
    @color       = color
    @attenuation = attenuation
  end

end
