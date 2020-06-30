require "../math/**"

class Entity

  property model    : TextureModel
  property position : GLM::Vector3
  property rotX     : Float32
  property rotY     : Float32
  property rotZ     : Float32
  property scale    : GLM::Vector3
  #property angle    : Float32

  property name     : String

  # Texture atlases
  # the textures are number from left to right
  # and from top to bottom
  #
  # Example
  #
  # 0 1 2 3
  # 4 5 6 7
  # ...
  #
  property texture_index : Int32 = 0

  def initialize(model : TextureModel, position : GLM::Vector3, rotation : GLM::Vector3, scale : GLM::Vector3) #, angle : Float32 = 0.0f32)
    @model    = model
    @position = position
    @scale    = scale
    @rotX     = rotation.x
    @rotY     = rotation.y
    @rotZ     = rotation.z
    #@angle    = angle
    @name     = "empty"
  end

  # constructor to allow you which texture to use
  def initialize(model : TextureModel, index : Int32, position : GLM::Vector3, rotation : GLM::Vector3, scale : GLM::Vector3) #, angle : Float32 = 0.0f32)
    @model    = model
    @position = position
    @scale    = scale
    @rotX     = rotation.x
    @rotY     = rotation.y
    @rotZ     = rotation.z
    #@angle    = angle
    @name     = "empty"

    @texture_index = index
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


  #
  # calculate the x offset of the given texture index in the texture atlas
  #
  def get_texture_x_offset() : Float32

    nr_rows = @model.number_of_rows
    column = @texture_index/nr_rows

    r = column//nr_rows
    return r.to_f32
  end

  #
  # calculate the y offset of the given texture index in the texture atlas
  #
  def get_texture_y_offset() : Float32

    nr_rows = @model.number_of_rows
    row     = @texture_index/nr_rows

    r = row//nr_rows
    return r.to_f32

  end

end
