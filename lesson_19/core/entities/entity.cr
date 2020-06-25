require "../math/**"

class Entity

  property model    : TextureModel
  property position : GLM::Vec3
  property rotX     : Float32
  property rotY     : Float32
  property rotZ     : Float32
  property scale    : GLM::Vec3
  property angle    : Float32

  property name     : String

  def initialize(model : TextureModel, position : GLM::Vec3, rotation : GLM::Vec3, scale : GLM::Vec3, angle : Float32 = 0.0f32)
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

  # old code def increaseRotation(dangle : Float32, axis : GLM::Vec3)
  # old code   @rotX  = axis.x
  # old code   @rotY  = axis.y
  # old code   @rotZ  = axis.z
  # old code   @angle = @angle + dangle
  # old code end

  def increaseRotation(dx : Float32, dy : Float32, dz : Float32)
    @rotX  = @rotX + dx
    @rotY  = @rotY + dy
    @rotZ  = @rotZ + dz
  end

  #
  # create model matrix out of position, rotation and scale data
  #
  def create_model_matrix() : GLM::Mat4
    trans    = GLM.translate(@position)
    rotation = GLM.rotation(GLM.vec3(@rotX,@rotY,@rotZ))
    scale    = GLM.scale(@scale)

    #
    # Note:
    # The order is important
    # first the scale, then the rotation followed by the translation
    # is applied
    # see http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/
    #
    r = trans * rotation * scale
    return r
  end

  def create_model_matrix2() : GLM::Mat4
    matrix = GLM::Mat4.identity()
    x_axis = GLM::Vec3.new(1,0,0)
    y_axis = GLM::Vec3.new(0,1,0)
    z_axis = GLM::Vec3.new(0,0,1)

    matrix = GLM.translate(matrix, @position)

    matrix = GLM.rotate(matrix, GLM.radians(@rotX), x_axis)
    matrix = GLM.rotate(matrix, GLM.radians(@rotY), y_axis)
    matrix = GLM.rotate(matrix, GLM.radians(@rotZ), z_axis)

    matrix = GLM.scale(matrix, @scale)
    return matrix
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

    model_matrix = create_model_matrix()
    program.set_uniform_matrix_4f("model", model_matrix)
    @model.draw()
  end

  def rotation() : String
    s = sprintf("(%6.3f,%6.3f,%6.3f)",@rotX,@rotY,@rotZ)
    return s
  end

  # dummy method
  def move(display : Display)
  end
end
