class Camera
  property position : GLM::Vector3
  property pitch    : Float32
  property yaw      : Float32
  property roll     : Float32


  def initialize(position : GLM::Vector3, pitch : Float32, yaw : Float32, roll : Float32)
     @position = position
     @pitch    = pitch
     @yaw      = yaw
     @roll     = roll
  end

  def initialize(position : GLM::Vector3)
    @position = position
    @pitch    = 0.0f32
    @yaw      = 0.0f32
    @roll     = 0.0f32
  end

  def initialize()
    @position = GLM::Vector3.new(0f32,0f32,0f32)
    @pitch    = 0.0f32
    @yaw      = 0.0f32
    @roll     = 0.0f32
  end

  def move(display : Display)
  end

end
