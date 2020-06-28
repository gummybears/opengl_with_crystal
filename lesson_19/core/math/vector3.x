#
# vector3.cr
#
require "./alias.cr"
require "../misc/errors.cr"
require "./angle.cr"

module GLM

  class Vector3
    property buffer : Float32*
    #property x : Float32
    #property y : Float32
    #property z : Float32

    def initialize
      @buffer = Pointer(Float32).malloc(3)
      @buffer[0] = 0f32
      @buffer[1] = 0f32
      @buffer[2] = 0f32
    end

    def initialize(x : Int32, y : Int32, z : Int32 )
      @buffer = Pointer(Float32).malloc(3)
      @buffer[0] = 1f32 * x
      @buffer[1] = 1f32 * y
      @buffer[2] = 1f32 * z
    end

    def initialize(x : Float32, y : Float32, z : Float32 )
      @buffer = Pointer(Float32).malloc(3)
      @buffer[0] = x
      @buffer[1] = y
      @buffer[2] = z
    end

    def initialize(x : Number, y : Number, z : Number )
      @buffer = Pointer(Float32).malloc(3)
      @buffer[0] = 1f32 * x
      @buffer[1] = 1f32 * y
      @buffer[2] = 1f32 * z
    end

    def x : Float32
      @buffer[0]
    end

    def y : Float32
      @buffer[1]
    end

    def z : Float32
      @buffer[2]
    end

    def x=(value)
      @buffer[0] = value
    end

    def y=(value)
      @buffer[1] = value
    end

    def z=(value)
      @buffer[2] = value
    end

    def abs()
      ::Math.sqrt(x() * x() + y() * y() + z() * z())
    end

    def length()
      abs()
    end

    def abs2()
      (x() * x() + y() * y() + z() * z())
    end

    def polar()

      r = length()
      if r == 0.0
        report_error("taking polar angle of (0,0,0)")
      end

      return acos(z()/r)
    end

    def azimuth()
      return ::ASY.angle(x(), y())
    end

    def colatitude(warn : Bool = false)
      if (x() == 0.0 && y() == 0.0 && z() == 0.0)
        if warn
          report_warning("taking colatitude of (0,0,0)")
        end
        return 0.0
      end

      return ::ASY.degrees(polar())
    end

    # returns the latitude of self
    def latitude(warn : Bool = false)
      if (x() == 0.0 && y() == 0.0 && z() == 0.0)
        if warn
          report_warning("taking latitude of (0,0,0)")
        end

        return 0
      end

      return 90.0 - ::ASY.degrees(polar())

    end

    # returns the longitude of self in [0,360).
    def longitude(warn : Bool = false)
      if (x() == 0.0 && y() == 0.0 && z() == 0.0)
        if warn
          report_warning("taking longitude of (0,0,0)")
        end
        return 0.0
      end

      return ::ASY.principal_branch( ::ASY.degrees(azimuth() ) )
    end

    #
    # returns true if x() != 0 and y() != 0 and z() != 0
    #
    def non_zero?() : Bool
      return x() != 0.0 || y() != 0.0 || z() != 0.0
    end

    # returns true if vector3 A < B
    def <(other : Vector3)
      return x() < other.x || (x() == other.x && y() < other.y) || (x() == other.x && y() == other.y && z() < other.z)
    end

    # returns true if vector3 A <= B
    def <=(other : Vector3)
      flag1 = self < other
      flag2 = self == other
      return flag1 || flag2
    end

    # returns true if vector3 A >= B
    def >=(other : Vector3)
      flag1 = self > other
      flag2 = self == other
      return flag1 || flag2
    end

    # returns true if vector3 A > B
    def >(other : Vector3)
      flag = !(self <= other)
      return flag
    end

    #
    # returns
    #- 1 if abs(self) < abs(other)
    #  0 if abs(self) == abs(other)
    #  1 if abs(self) >  abs(other)
    #
    def <=>(other : Vector3)
      #return x() <=> other.x || y() <=> other.y || z() <=> other.z
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
      flag = (x() == other.x && y() == other.y && z() == other.z)
      return flag
    end

    # returns true when self != other
    def !=(other)
      return (x() != other.x || y() != other.y || z() != other.z)
    end

    #
    # adds two vector3s A and B
    #
    def +(other) : Vector3
      return Vector3.new(x() + other.x,y() + other.y, z() + other.z)
    end

    #
    # subtracts two vector3s A and B
    #
    def -(other) : Vector3
      return Vector3.new(x() - other.x,y() - other.y, z() - other.z)
    end

    #
    # multiplies two vector3s A and B
    #
    def *(other) : Vector3
      return Vector3.new(x() * other.x,y() * other.y, z() * other.z)
    end

    #
    # right multiplies a real r with a vector3
    #
    def *(r : Real) : Vector3
      return Vector3.new(r * x(),r * y(),r * z())
    end

    # method used by to_s and to_s_trimmed
    private def fabs(r : Real) : Real
      return r.abs
    end

    # returns the string representation of a Vector3
    def to_s(precision = 15,truncate = false) : String
      lx = x()
      ly = y()
      lz = z()

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

    #
    # clones a vector3
    #
    def clone() : GLM::Vector3
      r = GLM::Vector3.new(x(),y(),z())
      return r
    end
  end

end

# operator Int32 * GLM::Vector3
struct Int32
  def *(other : GLM::Vector3) : GLM::Vector3
    x = self * other.x
    y = self * other.y
    z = self * other.z
    return GLM::Vector3.new(x,y,z)
  end
end

struct Float32
  def *(other : GLM::Vector3) : GLM::Vector3
    x = self * other.x
    y = self * other.y
    z = self * other.z
    return GLM::Vector3.new(x,y,z)
  end
end
