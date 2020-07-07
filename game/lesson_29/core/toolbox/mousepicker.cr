class MousePicker

  property current_ray : GLM::Vector3
  property view        : GLM::Matrix
  property projection  : GLM::Matrix
  property game        : Game

  def initialize(game : Game, camera : Camera, projection : GLM::Matrix)
    @game        = game
    @projection  = projection

    @view = camera.view_matrix()
    @current_ray = GLM::Vector3.new(0,0,0)
  end

  #
  # method update is called every frame
  #
  def update(camera : Camera)
    @view = camera.view_matrix()
    @current_ray = calculate_mouse_ray()
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

    w = @game.config.settings.width
    h = @game.config.settings.height

    x = (2.0 * mouse_x)/w - 1.0
    y = 1.0 - (2.0 * mouse_y)/h

    r = GLM::Vector2.new(x.to_f32,y.to_f32)
  end
end
