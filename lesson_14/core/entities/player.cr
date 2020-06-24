class Player < Entity

  # units per second
  property run_speed  : Float32 = 20f32
  # degrees per second
  property turn_speed : Float32 = 160f32

  property current_speed : Float32 = 0f32
  property current_turn_speed : Float32 = 0f32

  def move(display : Display)

    check_inputs(display.window)
    seconds = display.get_delta().total_seconds
    increaseRotation(0f32, @current_turn_speed * seconds , 0f32)

    distance = @current_speed * seconds

    dx = distance * Math.sin(GLM.radians(@rotY))
    dz = distance * Math.cos(GLM.radians(@rotY))

    #puts "dx #{dx} dz #{dz} seconds #{seconds}"

    increasePosition(dx,0f32,dz)
  end

  def check_inputs(window : Window)

    if window.key_pressed?(Key::W)
      # move forwards
      @current_speed = @run_speed
    elsif window.key_pressed?(Key::S)
      # move backwards
      @current_speed = -@run_speed
    else
      # player stays still
      @current_speed = 0f32
    end

    if window.key_pressed?(Key::D)
      # rotate clockwise
      @current_turn_speed = -@turn_speed
    elsif window.key_pressed?(Key::A)
      @current_turn_speed = @turn_speed
    else
      @current_turn_speed = 0f32
    end

  end
end
