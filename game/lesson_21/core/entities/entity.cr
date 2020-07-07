require "../math/**"

class Entity

  property model    : TextureModel
  property position : GLM::Vector3
  property rotX     : Float32
  property rotY     : Float32
  property rotZ     : Float32
  property scale    : GLM::Vector3
  property angle    : Float32

  property name     : String

  def initialize(model : TextureModel, position : GLM::Vector3, rotation : GLM::Vector3, scale : GLM::Vector3, angle : Float32 = 0.0f32)
    @model    = model
    @position = position
    @scale    = scale
    @rotX     = rotation.x
    @rotY     = rotation.y
    @rotZ     = rotation.z
    @angle    = angle
    @name     = "empty"
  end

  def increasePosition(dx : Float32, dy : Float32, dz : Float32)
    @position.x = @position.x + dx
    @position.y = @position.y + dy
    @position.z = @position.z + dz
  end

  def increaseRotation(dx : Float32, dy : Float32, dz : Float32)
    @rotX  = @rotX + dx
    @rotY  = @rotY + dy
    @rotZ  = @rotZ + dz
  end

  #
  # create model matrix out of position, rotation and scale data
  #
  #
  # Note:
  # The order is important
  # first the scale, then the rotation followed by the translation
  # is applied
  # see http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/
  #
  def create_model_matrix() : GLM::Matrix
    trans    = GLM.translate(@position)
    rotation = GLM.rotation(GLM::Vector3.new(@rotX,@rotY,@rotZ))
    scale    = GLM.scale(@scale)

    r = trans * rotation * scale
    return r
  end

  def rotation() : String
    s = sprintf("(%6.3f,%6.3f,%6.3f)",@rotX,@rotY,@rotZ)
    return s
  end

end
