require "../math/**"

class Entity

  property model    : Model
  property position : GLM::Vec3
  property rotX     : Float32
  property rotY     : Float32
  property rotZ     : Float32
  property scale    : GLM::Vec3
  property angle    : Float32

  def initialize(model : Model, position : GLM::Vec3, rotation : GLM::Vec3, scale : GLM::Vec3, angle : Float32 = 0.0f32)
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

  def draw(shaderprogram : ShaderProgram)

    model  = GLM.translate(GLM.vec3(@position.x,@position.y,@position.z))
    rotate = GLM.rotate(@angle, GLM.vec3(@rotX,@rotY,@rotZ))
    model  = rotate * model
    shaderprogram.set_uniform_matrix_4f("model", model)

    @model.draw()
  end
end
