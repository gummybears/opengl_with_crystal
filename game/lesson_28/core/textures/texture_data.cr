class TextureData

  property width    : Int32 #Float32 #Int32
  property height   : Int32 #Float32 #Int32
  property pixels   : Array(UInt8)

  def initialize(pixels : Array(UInt8), width : Int32, height : Int32)
    @pixels = pixels.dup
    @width  = width
    @height = height
  end

end
