
struct Color
  property red     : Float32
  property green   : Float32
  property blue    : Float32
  property opacity : Float32

  def initialize(red : Float32, green : Float32, blue : Float32, opacity : Float32)
    @red     = red
    @green   = green
    @blue    = blue
    @opacity = opacity
  end

end
