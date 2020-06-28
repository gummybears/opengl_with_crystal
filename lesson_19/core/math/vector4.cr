module GLM
  struct TVector4(T)
    @buffer : T*

    def self.zero
      new(T.zero, T.zero, T.zero)
    end

    def initialize(x, y, z, w)
      @buffer = Pointer(T).malloc(4)
      @buffer[0] = x
      @buffer[1] = y
      @buffer[2] = z
      @buffer[3] = w
    end

    def initialize(x : Int32, y : Int32, z : Int32, w : Int32)
      @buffer = Pointer(T).malloc(4)
      @buffer[0] = x.to_f32
      @buffer[1] = y.to_f32
      @buffer[2] = z.to_f32
      @buffer[3] = w.to_f32
    end

    def [](i : Int32)
      raise IndexError.new if i > 3 || i < 0
      @buffer[i]
    end

    def []=(i : Int32, value)
      raise IndexError.new if i > 3 || i < 0
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

    def w
      @buffer[3]
    end

    def w=(value)
      @buffer[3] = value
    end

    def +(v : TVector4(T))
      TVector4(T).new(x + v.x, y + v.y, z + v.z, w + v.w)
    end

    def -(v : TVector4(T))
      TVector4(T).new(x - v.x, y - v.y, z - v.z, w - v.w)
    end

    def *(a)
      TVector4(T).new(x * a, y * a, z * a, w * a)
    end

    def /(a)
      TVector4(T).new(x / a, y / a, z / a, w / a)
    end

    def length
      Math.sqrt(x * x + y * y + z * z + w * w)
    end

    def normalize
      self / length
    end

    def dot(v : TVector4(T))
      x * v.x + y * v.y + z * v.z + w * v.w
    end

    def to_s()
      return sprintf("(%f,%f,%f,%f)",x,y,z,w)
    end

  end
end
