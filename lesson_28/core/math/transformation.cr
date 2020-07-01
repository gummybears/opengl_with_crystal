module GLM

  def self.translate(vec : GLM::Vector3)
    translate(Matrix.identity, vec)
  end

  def self.translate(other : GLM::Matrix, vec : GLM::Vector3) : GLM::Matrix
    result = Matrix.identity
    result[0, 3] = vec.x
    result[1, 3] = vec.y
    result[2, 3] = vec.z
    m = other * result
    return m
  end

  def self.scale(other : GLM::Matrix, vec : GLM::Vector3) : GLM::Matrix
    result = Matrix.identity
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

    m = other * result
    return m
  end

  def self.translation(vec : Vector3) : GLM::Matrix
    m = Matrix.identity()
    m[0,3] = vec.x
    m[1,3] = vec.y
    m[2,3] = vec.z
    return m
  end

  def self.scale(vec : Vector3) : GLM::Matrix
    m = Matrix.identity()

    if vec.x == 0.0
      vec.x = 1.0f32
    end

    if vec.y == 0.0
      vec.y = 1.0f32
    end

    if vec.z == 0.0
      vec.z = 1.0f32
    end

    m[0,0] = vec.x.to_f32
    m[1,1] = vec.y.to_f32
    m[2,2] = vec.z.to_f32
    return m
  end

  def self.rotation(vec : Vector3) : GLM::Matrix
    rx       = Matrix.identity()
    ry       = Matrix.identity()
    rz       = Matrix.identity()

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

    m = rx * ry * rz
    return m
  end

  def self.rotation(forward : Vector3, up : Vector3) : GLM::Matrix
    f = forward.to_normalized
    r = up.to_normalized.cross(f)
    u = f.cross(r)

    m = rotation(f, u, r)
    return m
  end

  def self.rotation(forward : Vector3, up : Vector3, right : Vector3) : GLM::Matrix
    f = forward
    r = right
    u = up

    m = Matrix.identity()

    m[0, 0] = r.x
    m[0, 1] = r.y
    m[0, 2] = r.z

    m[1, 0] = u.x
    m[1, 1] = u.y
    m[1, 2] = u.z

    m[2, 0] = f.x
    m[2, 1] = f.y
    m[2, 2] = f.z
    return m
  end

  # old code #
  # old code # rotate an object around a given axis and angle
  # old code # angle given in radians
  # old code #
  # old code def self.rotate(angle : Float32, axis : GLM::Vector3)
  # old code   rotate(Mat4.identity, angle, axis)
  # old code end

  def self.rotate(other : GLM::Matrix, angle : Float32, vec : GLM::Vector3)
    c      = Math.cos(angle).to_f32
    s      = Math.sin(angle).to_f32
    result = Matrix.identity
    axis   = vec.normalize

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

end
