struct Settings

  property title  : String
  property width  : Float32
  property height : Float32
  property fov    : Float32
  property near   : Float32
  property far    : Float32
  property camera : GLM::Vec3
  property bg     : Color

  def initialize(title : String, width : Float32, height : Float32, fov : Float32, near : Float32, far :  Float32, camera : GLM::Vec3, bg : Color)
    @title  = title
    @width  = width
    @height = height
    @fov    = fov
    @near   = near
    @far    = far
    @camera = camera
    @bg     = bg
  end
end

