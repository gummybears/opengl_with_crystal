module GLM


  def self.radians(theta : Float32) : Float32
    r = theta * Math::PI/180.0
    return r.to_f32
  end

  def self.degrees(theta : Float32) : Float32
    r = theta * 180.0/Math::PI
    return r.to_f32
  end


  def self.deg_to_rad(d)
    d / 180.0 * Math::PI
  end

  struct TVec3(T)
    @buffer : T*

    def self.zero
      new(T.zero, T.zero, T.zero)
    end

    def initialize(x, y, z)
      @buffer = Pointer(T).malloc(3)
      @buffer[0] = x
      @buffer[1] = y
      @buffer[2] = z
    end

    def initialize(x : Int32, y : Int32, z : Int32)
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

    def +(v : TVec3(T))
      TVec3(T).new(x + v.x, y + v.y, z + v.z)
    end

    def -(v : TVec3(T))
      TVec3(T).new(x - v.x, y - v.y, z - v.z)
    end

    def *(a)
      TVec3(T).new(x * a, y * a, z * a)
    end

    def /(a)
      TVec3(T).new(x / a, y / a, z / a)
    end

    def length
      Math.sqrt(x * x + y * y + z * z)
    end

    def normalize
      self / length
    end

    def cross(v : TVec3(T))
      TVec3(T).new(
        y * v.z - v.y * z,
        z * v.x - v.z * x,
        x * v.y - v.x * y
      )
    end

    def dot(v : TVec3(T))
      x * v.x + y * v.y + z * v.z
    end
  end

  struct TMat4(T)
    @buffer : T*

    def self.zero
      TMat4(T).new { T.zero }
    end

    def self.identity
      m = zero
      m[0] = m[5] = m[10] = m[15] = T.new(1)
      m
    end

    def self.new(&block : Int32 -> T)
      m = TMat4(T).new
      p = m.buffer
      (0..15).each do |i|
        p[i] = yield i
      end
      m
    end

    def self.new_with_row_col(&block : (Int32, Int32) -> T)
      m = TMat4(T).new
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

    def ==(m : TMat4(T))
      (0..15).each do |i|
        return false if @buffer[i] != m.buffer[i]
      end
      true
    end

    def !=(m : TMat4(T))
      !(self == m)
    end

    def *(v)
      m = TMat4(T).new
      (0..15).each do |i|
        m.buffer[i] = @buffer[i] * v
      end
      m
    end

    def *(m : TMat4(T))
      r = TMat4(T).new_with_row_col do |i, j|
        p1 = @buffer + i
        p2 = m.buffer + 4 * j
        p1[0] * p2[0] + p1[4] * p2[1] + p1[8] * p2[2] + p1[12] * p2[3]
      end
      r
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
  end

  alias Mat4 = TMat4(Float32)
  alias Vec3 = TVec3(Float32)

  def self.vec3(x, y, z)
    Vec3.new(x.to_f32, y.to_f32, z.to_f32)
  end

  def self.translate(vec)
    translate(Mat4.identity, vec)
  end

  def self.translate(other, vec)
    result = Mat4.identity
    result[0, 3] = vec.x
    result[1, 3] = vec.y
    result[2, 3] = vec.z
    other * result
  end

  def self.scale(other, vec)
    result = Mat4.identity
    result[0, 0] = vec.x
    result[1, 1] = vec.y
    result[2, 2] = vec.z
    other * result
  end

  def self.rotate(angle, vec)
    rotate(Mat4.identity, angle, vec)
  end

  def self.rotate(other, angle, vec)
    c = Math.cos(angle).to_f32
    s = Math.sin(angle).to_f32
    result = Mat4.identity
    axis = vec.normalize

    result[0, 0] = c + (1 - c) * axis.x * axis.x
    result[0, 1] = (1 - c) * axis.x * axis.y + s * axis.z
    result[0, 2] = (1 - c) * axis.x * axis.z - s * axis.y

    result[1, 0] = (1 - c) * axis.y * axis.x - s * axis.z
    result[1, 1] = c + (1 - c) * axis.y * axis.y
    result[1, 2] = (1 - c) * axis.y * axis.z + s * axis.x

    result[2, 0] = (1 - c) * axis.z * axis.x + s * axis.y
    result[2, 1] = (1 - c) * axis.z * axis.y - s * axis.x
    result[2, 2] = c + (1 - c) * axis.z * axis.z

    other * result
  end

  def self.perspective(fov_y, aspect, near, far)
    raise ArgumentError.new if aspect == 0 || near == far
    rad = GLM.deg_to_rad(fov_y)
    tan_half_fov = Math.tan(rad / 2)

    m = Mat4.zero
    m[0, 0] = 1 / (aspect * tan_half_fov).to_f32
    m[1, 1] = 1 / tan_half_fov.to_f32
    m[2, 2] = -(far + near).to_f32 / (far - near).to_f32
    m[3, 2] = -1_f32
    m[2, 3] = -(2_f32 * far * near) / (far - near)
    m
  end

  def self.translation(vec : Vec3)
    r = Mat4.identity()
    r[0,3] = vec.x
    r[1,3] = vec.y
    r[2,3] = vec.z
    return r
  end

  def self.scale(vec : Vec3)
    r = Mat4.identity()
    r[0,0] = vec.x
    r[1,1] = vec.y
    r[2,2] = vec.z
    return r
  end

  def self.rotation(vec : Vec3)
    rx       = Mat4.identity()
    ry       = Mat4.identity()
    rz       = Mat4.identity()

    xrad     = self.radians(vec.x)
    yrad     = self.radians(vec.y)
    zrad     = self.radians(vec.z)

    rx[1, 1] =  Math.cos(xrad)
    rx[2, 2] =  Math.cos(xrad)
    rx[1, 2] = -Math.sin(xrad)
    rx[2, 1] =  Math.sin(xrad)

    ry[0, 0] =  Math.cos(yrad)
    ry[2, 2] =  Math.cos(yrad)
    ry[0, 2] =  Math.sin(yrad)
    ry[2, 0] = -Math.sin(yrad)

    rz[0, 0] =  Math.cos(zrad)
    rz[1, 1] =  Math.cos(zrad)
    rz[0, 1] = -Math.sin(zrad)
    rz[1, 0] =  Math.sin(zrad)

    r = rx * ry * rz
    return r
  end

  def self.look_at(eye : Vec3, center : Vec3, up : Vec3)
    f = (center - eye).normalize
    s = f.cross(up).normalize
    u = s.cross(f)

    m = Mat4.identity
    m[0, 0] = s.x
    m[0, 1] = s.y
    m[0, 2] = s.z
    m[1, 0] = u.x
    m[1, 1] = u.y
    m[1, 2] = u.z
    m[2, 0] = -f.x
    m[2, 1] = -f.y
    m[2, 2] = -f.z
    m[0, 3] = -s.dot(eye)
    m[1, 3] = -u.dot(eye)
    m[2, 3] = f.dot(eye)
    m
  end
end
