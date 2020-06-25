require "../math/**"

class Entity

  property model    : TextureModel
  property position : GLM::Vec3
  property rotX     : Float32
  property rotY     : Float32
  property rotZ     : Float32
  property scale    : GLM::Vec3
  property angle    : Float32

  def initialize(model : TextureModel, position : GLM::Vec3, rotation : GLM::Vec3, scale : GLM::Vec3, angle : Float32 = 0.0f32)
    @model    = model
    @position = position
    @scale    = scale
    @rotX     = rotation.x
    @rotY     = rotation.y
    @rotZ     = rotation.z
    @angle    = angle
  end

  def increasePosition(dx : Float32, dy : Float32, dz : Float32)
    @position.x = @position.x + dx
    @position.y = @position.y + dy
    @position.z = @position.z + dz
  end

  def increaseRotation(dangle : Float32, axis : GLM::Vec3)
    @rotX  = axis.x
    @rotY  = axis.y
    @rotZ  = axis.z
    @angle = @angle + dangle
  end

  def increaseRotation(dx : Float32, dy : Float32, dz : Float32)
    @rotX  = @rotX + dx
    @rotY  = @rotY + dy
    @rotZ  = @rotZ + dz
  end

  #
  # create model matrix out of position, rotation and scale data
  #
  def model_matrix() : GLM::Mat4
    trans  = GLM.translate(@position)
    rotate = GLM.rotation(GLM.vec3(@rotX,@rotY,@rotZ))
    scale  = GLM.scale(@scale)

    r = trans * rotate * scale
    return r
  end

  #
  # draw entity
  #
  def draw(program : Program)

    #
    # commented out
    # rotate object around an axis and angle
    #
    #rotate = GLM.rotate(@angle, GLM.vec3(@rotX,@rotY,@rotZ))

    program.set_uniform_matrix_4f("model", model_matrix())
    @model.draw()
  end
end
