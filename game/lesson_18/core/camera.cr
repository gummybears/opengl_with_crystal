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
    @position.z = @position.z - 0.1f32
  end

  def move_out()
    @position.z = @position.z + 0.1f32
  end

  def move_right()
    @position.x = @position.x + 0.5f32
  end

  def move_left()
    @position.x = @position.x - 0.5f32
  end

  def move_down()
    @position.y = @position.y - 0.015f32
  end

  def move_up()
    @position.y = @position.y + 0.015f32
  end

  def move(display : Display)

    window = display.window
    # move negative z
    if window.key_pressed?(Key::I)
      move_in()
    end

    # move positive z
    if window.key_pressed?(Key::J)
      move_out()
    end

    # move negative x
    if window.key_pressed?(Key::L)
      move_left()
    end

    # move positive x
    if window.key_pressed?(Key::M)
      move_right()
    end

    # move negative y
    if window.key_pressed?(Key::N)
      move_down()
    end

    # move positive y
    if window.key_pressed?(Key::O)
      move_up()
    end
  end
end