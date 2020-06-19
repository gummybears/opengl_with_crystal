class Camera
  property position : ASY::Triple
  property pitch    : Float32
  property yaw      : Float32
  property roll     : Float32

  def initialize(position : ASY::Triple, pitch : Float32, yaw : Float32, roll : Float32)
    @position = position
    @pitch    = pitch
    @yaw      = yaw
    @roll     = roll
  end

  def initialize()
    @position = ASY::Triple.new(0,0,0)
    @pitch    = 0.0f32
    @yaw      = 0.0f32
    @roll     = 0.0f32
  end

  def move_w()
    @position.z = @position.z - 0.02f32
  end

  def move_u()
    @position.z = @position.z + 0.02f32
  end

  def move_d()
    @position.x = @position.x + 0.02f32
  end

  def move_a()
    @position.x = @position.x - 0.02f32
  end
end
