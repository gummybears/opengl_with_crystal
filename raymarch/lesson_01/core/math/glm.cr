require "./angle.cr"
require "./vector2.cr"
require "./vector3.cr"
require "./vector4.cr"
require "./matrix.cr"
require "./transformation.cr"

module GLM

  alias Vector2 = TVector2(Float32)
  alias Vector3 = TVector3(Float32)
  alias Vector4 = TVector4(Float32)
  #alias Matrix  = TMatrix(Float32)

  #
  # perspective matrix
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

    m = Matrix.zero(4)
    m[0, 0] = 1.0f32 / (aspect * tan_half_fov).to_f32
    m[1, 1] = 1.0f32 / tan_half_fov.to_f32
    m[2, 2] = -(far + near).to_f32 / (frustrum_length).to_f32
    m[3, 3] = 0.0f32

    m[2, 3] = -(2.0f32 * far * near) / (frustrum_length).to_f32
    m[3, 2] = -1.0f32
    m[3, 3] = 0.0f32
    m
  end

  def self.orthographic(left, right, bottom, top, near, far)
    m = Matrix.zero(4)
    m[0, 0] = 2 / (right - left)
    m[1, 1] = 2 / (top - bottom)
    m[2, 2] = -2 / (far - near)
    m[3, 3] = 1.0

    m[0, 3] = - (right + left)/(right - left)
    m[1, 3] = - (top + bottom)/(top - bottom)
    m[2, 3] = - (far + near)/(far - near)
  end

  #
  # position is the position of the camera
  # target is where the camera is pointing at
  # up is the up direction of the camera
  #
  def self.look_at(position : Vector3, target : Vector3, up : Vector3)
    f = (target - position).normalize
    s = f.cross(up).normalize
    u = s.cross(f)

    m = Matrix.identity
    m[0, 0] =  s.x
    m[0, 1] =  s.y
    m[0, 2] =  s.z
    m[1, 0] =  u.x
    m[1, 1] =  u.y
    m[1, 2] =  u.z
    m[2, 0] = -f.x
    m[2, 1] = -f.y
    m[2, 2] = -f.z
    m[0, 3] = -s.dot(position)
    m[1, 3] = -u.dot(position)
    m[2, 3] =  f.dot(position)
    m
  end
end
