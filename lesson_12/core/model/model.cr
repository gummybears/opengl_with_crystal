enum ModelType
  TEXTURE
  TERRAIN
  OBJ
  PLAYER
end

class Model

  #property type             : ModelType
  property vao_id           : LibGL::UInt
  property vbos             : Array(LibGL::UInt)
  property nr_vertices      : Int32
  property nr_attrib_arrays : Int32

  property shine_damper : Float32 = 1.0f32
  property reflectivity : Float32 = 0.0f32

  #def initialize(type : ModelType, vao_id : LibGL::UInt, vbos : Array(LibGL::UInt), nr_vertices : Int32, nr_attrib_arrays : Int32)
  def initialize(vao_id : LibGL::UInt, vbos : Array(LibGL::UInt), nr_vertices : Int32, nr_attrib_arrays : Int32)
    #@type             = type
    @vao_id           = vao_id
    @vbos             = vbos
    @nr_vertices      = nr_vertices
    @nr_attrib_arrays = nr_attrib_arrays
  end

  #
  # enable attributes
  #
  def bind()
    LibGL.bind_vertex_array(@vao_id)
    0.upto(@nr_attrib_arrays - 1) do |i|
      LibGL.enable_vertex_attrib_array(i)
    end
  end

  #
  # disable attributes
  #
  def unbind()
    0.upto(@nr_attrib_arrays - 1) do |i|
      LibGL.disable_vertex_attrib_array(i)
    end

    LibGL.bind_vertex_array(0)
  end

  #
  # draw a model
  #
  def draw()
    bind()
    LibGL.draw_elements(LibGL::TRIANGLES, @nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))
    unbind()
  end

  #
  # creates a new vertex array object so we can store all of our buffered data
  #
  private def self.create_vao
    LibGL.gen_vertex_arrays(1, out vao_id)
    LibGL.bind_vertex_array(vao_id)
    return vao_id
  end

  #
  # unbind the VAO
  #
  private def self.unbind_vao
    LibGL.bind_vertex_array 0
  end

  #
  # load the vertices and indices data
  #
  def self.load(vertices : Array(Float32), indices : Array(Int32)) : Model

    vao_id = create_vao

    vbos   = [] of LibGL::UInt
    vbos <<  bind_indices_buffer(indices)
    vbos <<  store_data_in_attribute_list(0, 3, vertices)

    unbind_vao

    #
    # Note:
    # one of the vbos is for the indices, so we don't need an attribute array for that.
    #
    nr_attrib_arrays = vbos.size - 1
    Model.new(vao_id, vbos, indices.size(), nr_attrib_arrays)
  end

  #
  # Loads vertices/indices/texture coordinates into open gl and returns a model object that can be used for drawing.
  #
  def self.load(vertices : Array(Float32), indices : Array(Int32), texture_coords : Array(Float32) ) : Model

    vao_id = create_vao

    vbos = [] of LibGL::UInt

    vbos << bind_indices_buffer(indices)
    vbos << store_data_in_attribute_list(0, 3, vertices)
    vbos << store_data_in_attribute_list(1, 2, texture_coords)
    unbind_vao

    #
    # Note:
    # one of the vbos is for the indices, so we don't need an attribute array for that.
    #
    nr_attrib_arrays = vbos.size - 1
    Model.new(vao_id, vbos, indices.size(), nr_attrib_arrays)
  end

  #
  # Loads vertices/normals/indices/texture coordinates from ModelData
  #
  #def self.load(type : ModelType, data : ModelData) : Model
  def self.load(data : ModelData) : Model
    vao_id = create_vao

    vbos = [] of LibGL::UInt

    vbos << bind_indices_buffer(data.indices)
    vbos << store_data_in_attribute_list(0, 3, data.vertices)
    vbos << store_data_in_attribute_list(1, 2, data.textures)
    vbos << store_data_in_attribute_list(2, 3, data.normals)
    unbind_vao

    #
    # Note:
    # one of the vbos is for the indices, so we don't need an attribute array for that.
    #
    nr_attrib_arrays = vbos.size - 1
    #Model.new(type, vao_id, vbos, data.indices.size(), nr_attrib_arrays)
    Model.new(vao_id, vbos, data.indices.size(), nr_attrib_arrays)
  end

  #
  # bind our indices data to a VBO buffer
  #
  private def self.bind_indices_buffer(indices : Array(Int32))

    LibGL.gen_buffers(1, out vbo_id)
    LibGL.bind_buffer(LibGL::ELEMENT_ARRAY_BUFFER, vbo_id)
    LibGL.buffer_data(LibGL::ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(Int32), indices, LibGL::STATIC_DRAW)
    return vbo_id
  end

  #
  # Stores some data into an attribute list.
  # *attribute_number* is which attribute the data will be bound to. You should use sequental numbers starting at 0 otherwise something may break.
  # *coordinate_size* is how big the data is e.g. 3d coordinates, 2d coordinats.
  # if your data is a 3d vector you should set the value to 3.
  #
  def self.store_data_in_attribute_list(attribute_number : Int32, coordinate_size : Int32, vertices : Array(Float32))

    #
    # the vertex data
    #
    LibGL.gen_buffers(1, out vbo_id)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, vbo_id)
    LibGL.buffer_data(LibGL::ARRAY_BUFFER, vertices.size * sizeof(Float32), vertices, LibGL::STATIC_DRAW)

    #
    # vertex buffer
    #
    offset = Pointer(Void).new(0)
    LibGL.vertex_attrib_pointer(attribute_number, coordinate_size, LibGL::FLOAT, LibGL::FALSE, coordinate_size * sizeof(Float32), offset)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, 0)
    return vbo_id
  end

end
