require "./math/**"

class Camera
  property position : GLM::Vec3
  property pitch    : Float32
  property yaw      : Float32
  property roll     : Float32

  def initialize(position : GLM::Vec3, pitch : Float32, yaw : Float32, roll : Float32)
    @position = position
    @pitch    = pitch
    @yaw      = yaw
    @roll     = roll
  end

  def initialize(position : GLM::Vec3)
    @position = position
    @pitch    = 0.0f32
    @yaw      = 0.0f32
    @roll     = 0.0f32
  end

  def initialize()
    @position = GLM::Vec3.new(0f32,0f32,0f32)
    @pitch    = 0.0f32
    @yaw      = 0.0f32
    @roll     = 0.0f32
  end

  def move_in()
    @position.z = @position.z - 0.025f32
  end

  def move_out()
    @position.z = @position.z + 0.025f32
  end

  def move_right()
    @position.x = @position.x + 0.015f32
  end

  def move_left()
    @position.x = @position.x - 0.015f32
  end

  def move_down()
    @position.y = @position.y - 0.015f32
  end

  def move_up()
    @position.y = @position.y + 0.015f32
  end

end
