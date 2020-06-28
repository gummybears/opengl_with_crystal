struct Settings

  property title        : String
  property width        : Float32
  property height       : Float32
  property fov          : Float32
  property near         : Float32
  property far          : Float32
  property aspect_ratio : Float32
  property camera       : GLM::Vector3
  property bg           : Color
  property fog_density  : Float32
  property fog_gradient : Float32

  def initialize(title : String, width : Float32, height : Float32, fov : Float32, near : Float32, far :  Float32, camera : GLM::Vector3, bg : Color, fog_density : Float32, fog_gradient : Float32)
    @title        = title
    @width        = width
    @height       = height
    @fov          = fov
    @near         = near
    @far          = far
    @aspect_ratio = (@width/@height).to_f32

    @camera       = camera
    @bg           = bg
    @fog_density  = fog_density
    @fog_gradient = fog_gradient
  end
end

