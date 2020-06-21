require "./model.cr"
require "./texture.cr"
require "../loader/obj.cr"

class ObjModel < Model

  #property id : UInt32
  # property status : Int32 = 0

  # disabled def initialize(model : Model, filename : String)
  # disabled
  # disabled   # call super
  # disabled   super(model.vao_id,model.vbos,model.nr_vertices,model.nr_attrib_arrays)
  # disabled   filenotfound(filename)
  # disabled   @id = Texture.load(filename)
  # disabled end

  # disabled def draw()
  # disabled   bind()
  # disabled   LibGL.bind_texture(LibGL::TEXTURE_2D, @id)
  # disabled   LibGL.draw_elements(LibGL::TRIANGLES, @nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))
  # disabled   unbind()
  # disabled end

  #
  # load model from an OBJ file
  #
  def self.load(filename : String) : Model
    filenotfound(filename)

    obj = OBJ.new
    obj.open(filename)
    obj.to_opengl

    vertices = obj.vertices_arr
    indices  = obj.indices_arr
    textures = obj.textures_arr
    normals  = obj.normals_arr

    if textures.size == 0
      model = Model.load(vertices,indices)
      return model
    else
      model = Model.load(vertices,indices,textures,normals)
      return model
    end

    return Model.new
  end
end
