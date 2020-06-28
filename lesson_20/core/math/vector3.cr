module GLM
  struct TVector3(T)
    @buffer : T*

    def self.zero
      new(T.zero, T.zero, T.zero)
    end

    def initialize(x : Real, y : Real, z : Real)
      @buffer = Pointer(T).malloc(3)
      @buffer[0] = x.to_f32
      @buffer[1] = y.to_f32
      @buffer[2] = z.to_f32
    end

    def initialize(x : Int32, y : Int32, z : Int32)
      @buffer = Pointer(T).malloc(3)
      @buffer[0] = x.to_f32
      @buffer[1] = y.to_f32
      @buffer[2] = z.to_f32
    end

    def initialize(x : Float64, y : Float64, z : Float64)
      @buffer = Pointer(T).malloc(3)
      @buffer[0] = x.to_f32
      @buffer[1] = y.to_f32
      @buffer[2] = z.to_f32
    end

    def [](i : Int32)
      raise IndexError.new if i >= 3 || i < 0
      @buffer[i]
    end

    def []=(i : Int32, value)
      raise IndexError.new if i >= 3 || i < 0
      @buffer[i] = value
    end

    def buffer
      @buffer
    end

    def x
      @buffer[0]
    end

    def x=(value)
      @buffer[0] = value
    end

    def y
      @buffer[1]
    end

    def y=(value)
      @buffer[1] = value
    end

    def z
      @buffer[2]
    end

    def z=(value)
      @buffer[2] = value
    end

    def +(v : TVector3(T))
      TVector3(T).new(x + v.x, y + v.y, z + v.z)
    end

    def -(v : TVector3(T))
      TVector3(T).new(x - v.x, y - v.y, z - v.z)
    end

    def *(a)
      TVector3(T).new(x * a, y * a, z * a)
    end

    def /(a)
      TVector3(T).new(x / a, y / a, z / a)
    end

    def length
      Math.sqrt(x * x + y * y + z * z)
    end

    def normalize()
      self / length
    end

    # returns a new normalized vector.
    def to_normalized
      length = length()
      return Vector3f.new(x / length, y / length, z / length)
    end

    def cross(v : TVector3(T))
      TVector3(T).new(
        y * v.z - v.y * z,
        z * v.x - v.z * x,
        x * v.y - v.x * y
      )
    end

    def dot(v : TVector3(T))
      x * v.x + y * v.y + z * v.z
    end

    def to_s()
      return sprintf("(%f,%f,%f)",x,y,z)
    end
  end
end

#
# operator Float32 * GLM::Vector3
#
struct Float32

  # multiplies matrix other with a Float32
  def *(other : GLM::Vector3) : GLM::Vector3

    r = GLM::Vector3.new(0,0,0)

    r.x = self * other.x
    r.y = self * other.y
    r.z = self * other.z

    return r
  end
end
