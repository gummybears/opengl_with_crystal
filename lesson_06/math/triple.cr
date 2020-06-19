#
# triple.cr
#
#
require "./aliastype.cr"
require "./errors.cr"
require "./angle.cr"

#
# returns a normalized vector ie length equals 1
#
def unit(v : ASY::Triple)  : ASY::Triple

  scale = v.length()
  if scale == 0.0
    return v
  end

  scale = 1.0/scale
  return ASY::Triple.new(v.x*scale, v.y*scale, v.z*scale)
end

module ASY
  class Triple
    property x : Float32
    property y : Float32
    property z : Float32

    def initialize
      @x = 0.0f32
      @y = 0.0f32
      @z = 0.0f32
    end

    def initialize(x : Int32, y : Int32, z : Int32 )
      @x = 1.0f32 * x.to_f32
      @y = 1.0f32 * y.to_f32
      @z = 1.0f32 * z.to_f32
    end

    def initialize(x : Float32, y : Float32, z : Float32 )
      @x = x
      @y = y
      @z = z
    end

    def abs()
      ::Math.sqrt(@x * @x + @y * @y + @z * @z)
    end

    def length()
      abs()
    end

    def abs2()
      (@x * @x + @y * @y + @z * @z)
    end

    def polar()

      r = length()
      if r == 0.0
        report_error("taking polar angle of (0,0,0)")
      end

      return acos(@z/r)
    end

    def azimuth()
      return ::ASY.angle(@x, @y)
    end

    # returns true if triple A < B
    def <(other : Triple)
      return @x < other.x || (@x == other.x && @y < other.y) || (@x == other.x && @y == other.y && @z < other.z)
    end

    # returns true if triple A <= B
    def <=(other : Triple)
      flag1 = self < other
      flag2 = self == other
      return flag1 || flag2
    end

    # returns true if triple A >= B
    def >=(other : Triple)
      flag1 = self > other
      flag2 = self == other
      return flag1 || flag2
    end

    # returns true if triple A > B
    def >(other : Triple)
      flag = !(self <= other)
      return flag
    end

    #
    # returns
    #- 1 if abs(self) < abs(other)
    #  0 if abs(self) == abs(other)
    #  1 if abs(self) >  abs(other)
    #
    def <=>(other : Triple)
      #return @x <=> other.x || @y <=> other.y || @z <=> other.z
      if abs(self) < abs(other)
        return -1
      end

      if abs(self) == abs(other)
        return 0
      end

      return 1
    end

    # returns true when self == other
    def ==(other)
      flag = (@x == other.x && @y == other.y && @z == other.z)
      return flag
    end

    # returns true when self != other
    def !=(other)
      return (@x != other.x || @y != other.y || @z != other.z)
    end

    #
    # adds two triples A and B
    #
    def +(other) : Triple
      return Triple.new(@x + other.x,@y + other.y, @z + other.z)
    end

    #
    # subtracts two triples A and B
    #
    def -(other) : Triple
      return Triple.new(@x - other.x,@y - other.y, @z - other.z)
    end

    #
    # multiplies two triples A and B
    #
    def *(other) : Triple
      return Triple.new(@x * other.x,@y * other.y, @z * other.z)
    end

    #
    # right multiplies a real r with a triple
    #
    def *(r : Real) : Triple
      return Triple.new(r * @x,r * @y,r * @z)
    end

    # method used by to_s and to_s_trimmed
    private def fabs(r : Real) : Real
      return r.abs
    end

    # returns the string representation of a Triple
    def to_s(precision = 15,truncate = false) : String
      lx = @x
      ly = @y
      lz = @z

      precision_x = precision
      precision_y = precision
      precision_z = precision
      format_x    = "%.#{precision_x}f"
      format_y    = "%.#{precision_y}f"
      format_z    = "%.#{precision_z}f"

      if truncate
        if fabs(lx) <= 1.0E-15
          precision_x = 1
          #format_x    = "%.#{precision_x}f"
          format_x    = "%.1g"
          lx = 0.0
        else
          format_x    = "%.#{precision_x}g"
        end

        if fabs(ly) <= 1.0E-15
          precision_y = 1
          #format_y    = "%.#{precision_y}f"
          format_y    = "%.1g"
          ly = 0.0
        else
          format_y    = "%.#{precision_y}g"
        end

        if fabs(lz) <= 1.0E-15
          precision_z = 1
          #format_z    = "%.#{precision_z}f"
          format_z    = "%.1g"
          lz = 0.0
        else
          format_z    = "%.#{precision_z}g"
        end

      end

      if precision == 0
        return sprintf("(%g,%g,%g)",lx,ly,lz)
      end

      return sprintf("(#{format_x},#{format_y},#{format_z})",lx,ly,lz)
    end

    def to_STL(precision = 15) : String
      if precision == 0
        return sprintf("(%g,%g,%g)",@x,@y,@z)
      end
      return sprintf("%.#{precision}f %.#{precision}f %.#{precision}f",@x,@y,@z)
    end

    #
    # return a pair instead of triple
    # the z component is used as depth
    # perhaps useful in Z-buffering, Painter's algorithm
    #
    def to_pair : Pair
      r = Pair.new(@x,@y,@z)
      return r
    end

    #
    # clones a triple
    #
    def clone() : ASY::Triple
      r = ASY::Triple.new(@x,@y,@z)
      return r
    end
  end

end

# operator Int32 * ASY::Triple
struct Int32
  def *(other : ASY::Triple) : ASY::Triple
    x = self * other.x
    y = self * other.y
    z = self * other.z
    return ASY::Triple.new(x,y,z)
  end
end

struct Float32
  def *(other : ASY::Triple) : ASY::Triple
    x = self * other.x
    y = self * other.y
    z = self * other.z
    return ASY::Triple.new(x,y,z)
  end
end
