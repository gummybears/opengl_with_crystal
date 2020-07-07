module GLM

  struct TMatrix(T)
    @buffer : T*

    def self.zero
      TMatrix(T).new { T.zero }
    end

    def self.identity
      m = zero
      m[0] = m[5] = m[10] = m[15] = T.new(1)
      m
    end

    def self.new(&block : Int32 -> T)
      m = TMatrix(T).new
      p = m.buffer
      (0..15).each do |i|
        p[i] = yield i
      end
      m
    end

    def self.new_with_row_col(&block : (Int32, Int32) -> T)
      m = TMatrix(T).new
      p = m.buffer
      (0..3).each do |i|
        (0..3).each do |j|
          p[i + 4 * j] = yield i, j
        end
      end
      m
    end

    def initialize
      @buffer = Pointer(T).malloc(16)
    end

    def ==(m : TMatrix(T))
      (0..15).each do |i|
        return false if @buffer[i] != m.buffer[i]
      end
      true
    end

    def !=(m : TMatrix(T))
      !(self == m)
    end

    def *(v)
      m = TMatrix(T).new
      (0..15).each do |i|
        m.buffer[i] = @buffer[i] * v
      end
      m
    end

    def *(m : TMatrix(T))
      r = TMatrix(T).new_with_row_col do |i, j|
        p1 = @buffer + i
        p2 = m.buffer + 4 * j
        p1[0] * p2[0] + p1[4] * p2[1] + p1[8] * p2[2] + p1[12] * p2[3]
      end
      r
    end

    def *(v : GLM::Vector4) : GLM::Vector4
      r = self
      x = r[0,0] * v.x + r[0,1] * v.y + r[0,2] * v.z + r[0,3] * v.w
      y = r[1,0] * v.x + r[1,1] * v.y + r[1,2] * v.z + r[1,3] * v.w
      z = r[2,0] * v.x + r[2,1] * v.y + r[2,2] * v.z + r[2,3] * v.w
      w = r[3,0] * v.x + r[3,1] * v.y + r[3,2] * v.z + r[3,3] * v.w

      v = GLM::Vector4.new(x,y,z,w)
    end


    def buffer
      @buffer
    end

    def to_unsafe
      @buffer
    end

    def [](i)
      raise IndexError.new if i < 0 || i >= 16
      @buffer[i]
    end

    def [](row, col)
      self[row + col * 4]
    end

    def []=(i, value : T)
      raise IndexError.new if i < 0 || i >= 16
      @buffer[i] = value
    end

    def []=(row, col, value : T)
      self[row + col * 4] = value
    end

    def to_s : String
      s = [] of String
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[0,0],self[0,1],self[0,2],self[0,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[1,0],self[1,1],self[1,2],self[1,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[2,0],self[2,1],self[2,2],self[2,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[3,0],self[3,1],self[3,2],self[3,3])

      r = s.join("\n")
      return r
    end
  end
end
