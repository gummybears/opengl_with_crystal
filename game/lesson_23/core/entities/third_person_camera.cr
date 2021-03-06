#require "./math/**"

MIN_ZOOM  = 1f32
MAX_ZOOM  = 100f32
MIN_PITCH = 0.1f32
MAX_PITCH = 89.99f32

class ThirdPersonCamera < Camera

  property player   : Player
  property distance_from_player : Float32 = 50.0f32
  property angle_around_player  : Float32 = 0.0f32
  #property prev_mouse_position  : GLM::Vector2

  def initialize(player : Player)
    position = GLM::Vector3.new(0f32,0f32,0f32)
    pitch    = 20.0f32
    yaw      = 0.0f32
    roll     = 0.0f32

    super(position,pitch,yaw,roll)

    @player   = player
    horizontal_distance  = calculate_horizontal_distance()
    vertical_distance    = calculate_vertical_distance()
    @position            = calculate_camera_position(horizontal_distance,vertical_distance)

  end

  def move(display : Display)

    calculate_zoom(display)
    calculate_pitch(display)
    calculate_angle_around_player(display)

    horizontal_distance = calculate_horizontal_distance()
    vertical_distance   = calculate_vertical_distance()
    @position           = calculate_camera_position(horizontal_distance,vertical_distance)

    # calculate new yaw angle
    @yaw = 180.0f32 - (@player.rotY - @angle_around_player)

  end

  def calculate_camera_position(horizontal_distance : Float32, vertical_distance : Float32) : GLM::Vector3

    theta      = @player.rotY + @angle_around_player
    offset_x   = horizontal_distance * Math.sin(GLM.radians(theta))
    offset_z   = horizontal_distance * Math.cos(GLM.radians(theta))

    position.x = @player.position.x - offset_x
    position.y = @player.position.y + vertical_distance
    position.z = @player.position.z - offset_z

    return position
  end

  def calculate_horizontal_distance()
    r = @distance_from_player * Math.cos(GLM.radians(@pitch))
    return r
  end

  def calculate_vertical_distance()
    r = @distance_from_player * Math.sin(GLM.radians(@pitch))
    return r
  end

  def calculate_zoom(display : Display)

    if display.scrolling == false
      return
    end

    offset     = display.scroll_offset
    zoom_level = offset.y.to_f32 * 0.2f32

    @distance_from_player = @distance_from_player - zoom_level
    if @distance_from_player < MIN_ZOOM
      @distance_from_player = MIN_ZOOM
    end

    if @distance_from_player > MAX_ZOOM
      @distance_from_player = MAX_ZOOM
    end

  end

  #
  # pitch is calculated when user presses right mouse button
  #
  def calculate_pitch(display : Display)

    #if display.pitching == false
    #  return
    #end

    if display.mouse_right == 1
      pitch_change = display.mouse_dy * 0.1f32
      @pitch = @pitch + pitch_change
    end

    if @pitch < MIN_PITCH
      @pitch = MIN_PITCH
    end

    if @pitch > MAX_PITCH
      @pitch = MAX_PITCH
    end
  end

  #
  # angle around player is calculated when user presses left mouse button
  #
  def calculate_angle_around_player(display : Display)

    if display.mouse_left == 1

      angle_change = display.mouse_dx * 0.3f32
      #if @angle_around_player <= -360f32 || @angle_around_player >= 360f32
      #  @angle_around_player = 0f32
      #end
      @angle_around_player = @angle_around_player + angle_change
    end
  end

  def view_matrix() : GLM::Matrix
    up  = GLM::Vector3.new(0f32, 1f32, 0f32)
    view_matrix = GLM.look_at(@position,@player.position,up)
    return view_matrix
  end

  ## calculates the front vector from the Camera's (updated) Euler Angles
  #def update_camera()
  #
  #  x = Math.cos(GLM.radians(@yaw)) * Math.cos(GLM.radians(@pitch))
  #  y = Math.sin(GLM.radians(@pitch))
  #  z = Math.sin(GLM.radians(@yaw)) * Math.cos(GLM.radians(@pitch))
  #  front = GLM::Vector3.new(x,y,z)
  #  front = front.normalize()
  #
  #  # normalize the vectors, because their length gets closer to 0 the more you look up or down which results in slower movement.
  #  #Right = glm::normalize(glm::cross(Front, WorldUp));
  #  #up  = GLMnormalize(cross(Right, Front));
  #  up  = GLM::Vector3.new(0f32, 1f32, 0f32)
  #  view_matrix = GLM.look_at(@position,@player.position,up)
  #
  #end
end
