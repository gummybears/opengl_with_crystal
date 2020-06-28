#
# vector4.cr
#

require "./angle.cr"

module GLM
  class Vector4
    property x : Float32
    property y : Float32
    property z : Float32
    property w : Float32

    def initialize
      @x = 0.0
      @y = 0.0
      @z = 0.0
      @w = 0.0
    end

    def initialize(x : Int32, y : Int32, z : Int32, w : Int32 )
      @x = 1f32 * x
      @y = 1f32 * y
      @z = 1f32 * z
      @w = 1f32 * w
    end

    def initialize(x : Float32, y : Float32, z : Float32, w : Float32 )
      @x = x
      @y = y
      @z = z
      @w = w
    end

    def initialize(arr : Array(Float32))
      @x = 1f32 * arr[0]
      @y = 1f32 * arr[1]
      @z = 1f32 * arr[2]
      @w = 1f32 * arr[3]
    end

  end
end

# operator Int32 * GLM::Triple
struct Int32
  def *(other : GLM::Quad) : GLM::Quad
    x = self * other.x
    y = self * other.y
    z = self * other.z
    w = self * other.w
    return GLM::Quad.new(x,y,z,w)
  end
end

struct Float32
  def *(other : GLM::Quad) : GLM::Quad
    x = self * other.x
    y = self * other.y
    z = self * other.z
    w = self * other.w
    return GLM::Quad.new(x,y,z,w)
  end
end
