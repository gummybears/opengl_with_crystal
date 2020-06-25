module GLM

  alias Real = Int32|Float32

  def self.radians(theta : Float32) : Float32
    r = theta * Math::PI/180.0
    return r.to_f32
  end

  def self.degrees(theta : Float32) : Float32
    r = theta * 180.0/Math::PI
    return r.to_f32
  end

  # old code def self.deg_to_rad(d)
  # old code   d / 180.0 * Math::PI
  # old code end

  struct TVec2(T)
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

    def +(v : TVec2(T))
      TVec2(T).new(x + v.x, y + v.y)
    end

    def -(v : TVec2(T))
      TVec2(T).new(x - v.x, y - v.y)
    end

    def *(a)
      TVec2(T).new(x * a, y * a)
    end

    def /(a)
      TVec2(T).new(x / a, y / a)
    end

    def length
      Math.sqrt(x * x + y * y)
    end

    def normalize
      self / length
    end

    def dot(v : TVec2(T))
      x * v.x + y * v.y
    end

    def to_s()
      return sprintf("(%f,%f)",x,y)
    end
  end

  struct TVec3(T)
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

    def to_s()
      return sprintf("(%f,%f,%f)",x,y,z)
    end
  end

  struct TVec4(T)
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

    def +(v : TVec4(T))
      TVec4(T).new(x + v.x, y + v.y, z + v.z, w + v.w)
    end

    def -(v : TVec4(T))
      TVec4(T).new(x - v.x, y - v.y, z - v.z, w - v.w)
    end

    def *(a)
      TVec4(T).new(x * a, y * a, z * a, w * a)
    end

    def /(a)
      TVec4(T).new(x / a, y / a, z / a, w / a)
    end

    def length
      Math.sqrt(x * x + y * y + z * z + w * w)
    end

    def normalize
      self / length
    end

    def dot(v : TVec4(T))
      x * v.x + y * v.y + z * v.z + w * v.w
    end

    def to_s()
      return sprintf("(%f,%f,%f,%f)",x,y,z,w)
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

    def *(v : GLM::Vec4) : GLM::Vec4
      r = self
      x = r[0,0] * v.x + r[0,1] * v.y + r[0,2] * v.z + r[0,3] * v.w
      y = r[1,0] * v.x + r[1,1] * v.y + r[1,2] * v.z + r[1,3] * v.w
      z = r[2,0] * v.x + r[2,1] * v.y + r[2,2] * v.z + r[2,3] * v.w
      w = r[3,0] * v.x + r[3,1] * v.y + r[3,2] * v.z + r[3,3] * v.w

      v = GLM::Vec4.new(x,y,z,w)
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

  alias Vec2 = TVec2(Float32)
  alias Vec3 = TVec3(Float32)
  alias Vec4 = TVec4(Float32)
  alias Mat4 = TMat4(Float32)

  def self.vec2(x, y, z)
    Vec2.new(x.to_f32, y.to_f32)
  end

  def self.vec3(x, y, z)
    Vec3.new(x.to_f32, y.to_f32, z.to_f32)
  end

  def self.vec4(x, y, z, w)
    Vec4.new(x.to_f32, y.to_f32, z.to_f32, w.to_f32)
  end

  def self.translate(vec : GLM::Vec3)
    translate(Mat4.identity, vec)
  end

  def self.translate(other : GLM::Mat4, vec : GLM::Vec3)
    result = Mat4.identity
    result[0, 3] = vec.x
    result[1, 3] = vec.y
    result[2, 3] = vec.z
    r = other * result
    return r
  end

  def self.scale(other : GLM::Mat4, vec : GLM::Vec3)
    result = Mat4.identity
    if vec.x == 0
      vec.x = 1.0f32
    end

    if vec.y == 0
      vec.y = 1.0f32
    end

    if vec.z == 0
      vec.z = 1.0f32
    end

    result[0, 0] = vec.x
    result[1, 1] = vec.y
    result[2, 2] = vec.z
    other * result
  end

  def self.rotate(angle, vec)
    rotate(Mat4.identity, angle, vec)
  end

  def self.rotate(other : GLM::Mat4, angle : Float32, vec : GLM::Vec3 )

    c    = Math.cos(angle).to_f32
    s    = Math.sin(angle).to_f32
    r    = Mat4.identity
    axis = vec.normalize

    r[0, 0] = c + (1 - c) * axis.x * axis.x
    r[0, 1] = (1 - c) * axis.x * axis.y + s * axis.z
    r[0, 2] = (1 - c) * axis.x * axis.z - s * axis.y

    r[1, 0] = (1 - c) * axis.y * axis.x - s * axis.z
    r[1, 1] = c + (1 - c) * axis.y * axis.y
    r[1, 2] = (1 - c) * axis.y * axis.z + s * axis.x

    r[2, 0] = (1 - c) * axis.z * axis.x + s * axis.y
    r[2, 1] = (1 - c) * axis.z * axis.y - s * axis.x
    r[2, 2] = c + (1 - c) * axis.z * axis.z

    other * r
  end

  #
  # don't tranpose this matrix
  #
  # in the Java tutorial the matrix is transposed
  # and is wrong
  #
  def self.perspective(fov, aspect, near, far)
    #
    # aspect ratio is 0 or the near plane equals the far plane
    #
    if aspect == 0
      report_error("aspect ratio is 0")
    end

    if near == far
      report_error("the near and far plane are equal")
    end

    rad          = GLM.radians(fov)
    tan_half_fov = Math.tan(rad/2.0)
    frustrum_length = far - near

    m = Mat4.zero
    m[0, 0] = 1.0f32 / (aspect * tan_half_fov).to_f32
    m[1, 1] = 1.0f32 / tan_half_fov.to_f32
    m[2, 2] = -(far + near).to_f32 / (frustrum_length).to_f32
    m[3, 3] = 0.0f32

    m[2, 3] = -(2.0f32 * far * near) / (frustrum_length).to_f32
    m[3, 2] = -1.0f32
    m
  end

  def self.orthographic(left, right, bottom, top, near, far)
    m = Mat4.zero
    m[0, 0] = 2 / (right - left)
    m[1, 1] = 2 / (top - bottom)
    m[2, 2] = -2 / (far - near)
    m[3, 3] = 1.0

    m[0, 3] = - (right + left)/(right - left)
    m[1, 3] = - (top + bottom)/(top - bottom)
    m[2, 3] = - (far + near)/(far - near)
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

    if vec.x == 0.0
      vec.x = 1.0f32
    end

    if vec.y == 0.0
      vec.y = 1.0f32
    end

    if vec.z == 0.0
      vec.z = 1.0f32
    end

    r[0,0] = vec.x.to_f32
    r[1,1] = vec.y.to_f32
    r[2,2] = vec.z.to_f32
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


#
# operator Float32 * ASY::Matrix
#
struct Float32

  # multiplies matrix other with a Float64
  def *(other : GLM::Vec3) : GLM::Vec3

    r = GLM::Vec3.new(0,0,0)

    r.x = self * other.x
    r.y = self * other.y
    r.z = self * other.z

    return r
  end

end


