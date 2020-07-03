module GLM
  struct TVector2(T)
    @buffer : T*

    def self.zero
      new(T.zero, T.zero)
    end

    def initialize(x : Real, y : Real)
      @buffer = Pointer(T).malloc(2)
      @buffer[0] = x.to_f32
      @buffer[1] = y.to_f32
    end

    def initialize(x : Int32, y : Int32)
      @buffer = Pointer(T).malloc(2)
      @buffer[0] = x.to_f32
      @buffer[1] = y.to_f32
    end

    def [](i : Int32)
      raise IndexError.new if i >= 2 || i < 0
      @buffer[i]
    end

    def []=(i : Int32, value)
      raise IndexError.new if i >= 2 || i < 0
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

    def +(v : TVector2(T))
      TVector2(T).new(x + v.x, y + v.y)
    end

    def -(v : TVector2(T))
      TVector2(T).new(x - v.x, y - v.y)
    end

    def *(a)
      TVector2(T).new(x * a, y * a)
    end

    def /(a)
      TVector2(T).new(x / a, y / a)
    end

    def length
      Math.sqrt(x * x + y * y)
    end

    def normalize
      self / length
    end

    def dot(v : TVector2(T))
      x * v.x + y * v.y
    end

    def to_s()
      return sprintf("(%f,%f)",x,y)
    end
  end
end
