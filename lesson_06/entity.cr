class Entity

  property texturedModel : Model
  property position      : Vector3f
  property rotX          : Float32
  property rotY          : Float32
  property rotZ          : Float32
  property scale         : Float32

  def initialize(model : Model, position : Vector3f, rotX : Float32, rotY : Float32, rotZ : Float32, scale : Float32)
    @texturedModel = texturedModel
    @position      = position
    @rotX          = rotX
    @rotY          = rotY
    @rotZ          = rotZ
    @scale         = scale
  end

  def increasePosition(dx : Float32, dy : Float32, dz : Float32)
    @position.x = @position.x + dx
    @position.y = @position.y + dy
    @position.z = @position.z + dz
  end

  def increaseRotation(dx : Float32, dy : Float32, dz : Float32)
    @rotX = @rotX + dx
    @rotY = @rotY + dy
    @rotZ = @rotZ + dz
  end

  def model() : Model
    @texturedModel
  end
end
