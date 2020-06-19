#
# pair.cr
#
#
require "./errors.cr"
require "./aliastype.cr"
require "./angle.cr"

module ASY
  class Pair
    # Sets/gets the x coordinate of a Pair
    property x     : Float32
    # Sets/gets the y coordinate of a Pair
    property y     : Float32

    # used by project in api/projection.cr
    # to store the z component of the projected Triple
    #
    property depth : Real

    # Initialize a Pair object with a (x,y) coordinate of (0,0)
    def initialize
      @x     = 0.0
      @y     = 0.0
      @depth = 0.0
    end

    # Initialize a Pair object given a (x,y) coordinate
    def initialize(x : Float32, y : Float32 )
      @x     = 1.0 * x
      @y     = 1.0 * y
      @depth = 0.0
    end

    # Initialize a Pair object given a (x,y) coordinate
    def initialize(x : Number, y : Number)
      @x     = 1.0 * x
      @y     = 1.0 * y
      @depth = 0.0
    end

    # Initialize a Pair object given a (x,y,z) coordinate
    def initialize(x : Number, y : Number, z : Number)
      @x     = 1.0 * x
      @y     = 1.0 * y
      @depth = 1.0 * z
    end

    # returns the length of a Pair
    def abs()
      Math.sqrt(@x * @x + @y * @y)
    end

    # returns the length of a Pair
    def length()
      abs()
    end

    # returns the length of a Pair squared
    def abs2()
      (@x * @x + @y * @y)
    end

    # returns the angle of a Pair (radians)
    def angle()
      return ::ASY.angle(x, y)
    end

    # returns the angle of a Pair (degrees)
    def degrees()
      return ::ASY.degrees(::ASY.angle(x, y))
    end

    # returns true if @x != 0 and @y != 0
    def non_zero?() : Bool
      return @x != 0.0 || @y != 0.0
    end

    # returns true if pair A < B
    def <(other : Pair)
      return @x < other.x || (@x == other.x && @y < other.y)
    end

    # returns true if pair A == B
    def ==(other : Pair)
      return (@x == other.x && @y == other.y)
    end

    # returns true if pair A != B
    def !=(other : Pair)
      return (@x != other.x || @y != other.y)
    end

    # returns true if pair A <= B
    def <=(other : Pair)
      flag1 = self < other
      flag2 = self == other
      return flag1 || flag2
    end

    # returns true if pair A >= B
    def >=(other : Pair)
      flag1 = self > other
      flag2 = self == other
      return flag1 || flag2
    end

    # returns true if pair A > B
    def >(other : Pair)
      flag = !(self <= other)
      return flag
    end

    #
    # returns
    #- 1 if abs(self) < abs(other)
    #  0 if abs(self) == abs(other)
    #  1 if abs(self) >  abs(other)
    #
    def <=>(other : Pair)
      #return (@x <=> other.x && @y <=> other.y)
      if abs(self) < abs(other)
        return -1
      end

      if abs(self) == abs(other)
        return 0
      end

      return 1
    end

    #
    # adds two pairs A and B
    #
    def +(other : Pair) : Pair
      return Pair.new(@x + other.x,@y + other.y)
    end

    #
    # subtracts two pairs A and B
    #
    def -(other : Pair) : Pair
      return Pair.new(@x - other.x,@y - other.y)
    end

    #
    # multiplies two pairs A and B
    # complex multiplication
    #
    def *(other : Pair) : Pair
      return Pair.new( @x * other.x - @y * other.y, @x * other.y + other.x * @y)
    end

    #
    # divides two pairs A and B
    #
    def /(other : Pair) : Pair

      if other.non_zero?() == false
        report_error("division by pair (0,0)")
      end

      zx = @x
      zy = @y
      w  = other
      t  = 1.0 / (w.x * w.x + w.y * w.y)

      new_x = t * (zx * w.x + zy * w.y)
      new_y = t * (-1.0 * zx * w.y + w.x * zy)
      p     = Pair.new(new_x,new_y)
      return p
    end

    #
    # multiplies two pairs A and B
    #
    def *(other : Real) : Pair
      return Pair.new(@x * other,@y * other)
    end

    #
    # returns the conjutive of a Pair
    #
    def conj() : Pair
      return Pair.new(@x, -1.0 * @y)
    end

    # method used by to_s and to_s_trimmed
    private def fabs(r : Real) : Real
      return r.abs
    end

    # returns the string representation of a Pair
    def to_s(precision = 15,truncate = false) : String
      lx = @x
      ly = @y

      precision_x = precision
      precision_y = precision
      format_x    = "%.#{precision_x}f"
      format_y    = "%.#{precision_y}f"

      if truncate
        if fabs(x) <= 1.0E-15
          precision_x = 1
          #format_x    = "%.#{precision_x}f"
          format_x    = "%.1g"
          lx = 0.0
        else
          format_x    = "%.#{precision_x}g"
        end

        if fabs(y) <= 1.0E-15
          precision_y = 1
          #format_y    = "%.#{precision_y}f"
          format_y    = "%.1g"
          ly = 0.0
        else
          format_y    = "%.#{precision_y}g"
        end
      end

      if precision == 0
        return sprintf("(%g,%g)",lx,ly)
      end

      #return sprintf("(%.#{precision}f,%.#{precision}f)",x,y)
      return sprintf("(#{format_x},#{format_y})",lx,ly)
    end

    #
    # returns a triple from a pair
    #
    def to_triple() : Triple
      t = Triple.new(@x,@y,0.0)
      return t
    end

    #
    # clones a pair
    #
    def clone() : ASY::Pair
      r = ASY::Pair.new(@x,@y)
      r.depth = @depth
      return r
    end

  end
end
#
#
## operator Int32 * ASY::Pair
#struct Int32
#
#  def *(other : ASY::Pair) : ASY::Pair
#    x = self * other.x
#    y = self * other.y
#    return ASY::Pair.new(x,y)
#  end
#end
#
## operator Float32 * ASY::Pair
#struct Float32
#
#  def *(other : ASY::Pair) : ASY::Pair
#    x = self * other.x
#    y = self * other.y
#    return ASY::Pair.new(x,y)
#  end
#end
#
