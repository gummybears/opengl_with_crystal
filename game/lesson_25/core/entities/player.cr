class Player < Entity

  # run speed in units per second
  property run_speed          : Float32

  # turn speed in degrees per second
  property turn_speed         : Float32
  property current_speed      : Float32
  property current_turn_speed : Float32

  property gravity            : Float32
  property jump_power         : Float32
  property upwards_speed      : Float32
  #property terrain_height     : Float32

  property is_in_air          : Bool = false

  # not used property offset_y           : Float32

  def initialize(model : TextureModel, position : GLM::Vector3, rotation : GLM::Vector3, scale : GLM::Vector3) #, angle : Float32 = 0.0f32)
    super(model,position,rotation,scale) #,angle)

    @run_speed          = 30f32
    @turn_speed         = 160f32
    @current_speed      = 0f32
    @current_turn_speed = 0f32
    @gravity            = -50f32
    @jump_power         = 30f32
    @upwards_speed      = 0f32
    # not used @terrain_height     = 0f32
    # not used @offset_y           = 5f32
  end

  def move(game : Game, terrain : Terrain)

    check_inputs(game.window)

    #
    # get the number of seconds elapsed since the last frame
    #
    seconds = game.elapsed
    increaseRotation(0f32, @current_turn_speed * seconds , 0f32)

    distance = @current_speed * seconds

    dx = distance * Math.sin(GLM.radians(@rotY))
    dz = distance * Math.cos(GLM.radians(@rotY))

    increasePosition(dx,0f32,dz)

    @upwards_speed = @upwards_speed + @gravity * seconds
    dy             = @upwards_speed * seconds
    increasePosition(0f32,dy,0f32)

    #
    # collision detection
    # need to find the height of our terrain
    # at player's position
    #
    terrain_height = terrain.get_height_of_terrain(@position.x,@position.z)
    if @position.y < 0f32
      @position.y = 0f32
    end

    if @position.y < terrain_height
      @upwards_speed = 0f32
      @position.y    = terrain_height
      @is_in_air     = false
    end
  end

  #
  # we are not allowed to jump when in air
  #
  def jump()
    if @is_in_air == false
      @upwards_speed = @jump_power
      @is_in_air = true
    end
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

    # jump
    if window.key_pressed?(Key::Space)
      jump()
    end

  end
end
