class MousePicker

  property current_ray : GLM::Vector3
  property view        : GLM::Matrix
  property projection  : GLM::Matrix
  #property camera      : Camera
  property game        : Game

  def initialize(game : Game, camera : Camera, projection : GLM::Matrix)
    @game        = game
    #@camera      = camera
    @projection  = projection

    #@view        = create_view_matrix(camera)
    @view = camera.view_matrix()
    @current_ray = GLM::Vector3.new(0,0,0)
  end

  #def create_view_matrix(camera : Camera)
  #  r = GLM.translate(camera.position)
  #  return r
  #end

  # called every frame
  def update(camera : Camera)
    #@view        = create_view_matrix(camera)
    @view = camera.view_matrix()
    @current_ray = calculate_mouse_ray()

    puts "ray #{@current_ray.to_s}"
  end

  def calculate_mouse_ray() : GLM::Vector3

    mouse_x = @game.mouse_x
    mouse_y = @game.mouse_y

    normalized_coords = get_normalized_device_coords(mouse_x,mouse_y)

    z            = -1f32
    w            =  1f32
    clip_coords  =  GLM::Vector4.new(normalized_coords.x,normalized_coords.y,z,w)
    eye_coords   =  to_eye_coords(clip_coords)
    world_coords =  to_world_coords(eye_coords)
    return world_coords

  end

  def to_eye_coords(clip_coords : GLM::Vector4) : GLM::Vector4

    inverted_projection = @projection.inverse()
    eye_coords = inverted_projection * clip_coords

    z = -1f32
    w =  0f32
    r =  GLM::Vector4.new(eye_coords.x,eye_coords.y,z,w)
    return r
  end

  def to_world_coords(eye_coords : GLM::Vector4) : GLM::Vector3

    inverted_view = @view.inverse()
    world_coords = inverted_view * eye_coords

    r = GLM::Vector3.new(world_coords.x,world_coords.y,world_coords.z)
    r = r.normalize()
    return r
  end

  def get_normalized_device_coords(mouse_x : Float32, mouse_y : Float32) : GLM::Vector2
    x = (2f32 * mouse_x)/(@game.config.settings.width - 1)
    y = (2f32 * mouse_y)/(@game.config.settings.height - 1)

    # the point (0,0) is in the upper/lower corner ?
    # if upper corner y -> -y
    # check
    r = GLM::Vector2.new(x,-y)
  end

end
