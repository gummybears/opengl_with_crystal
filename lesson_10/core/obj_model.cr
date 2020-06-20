require "./model.cr"
require "./texture.cr"
require "../loader/obj.cr"

class ObjModel < Model

  property id : UInt32
  property status : Int32 = 0

  def initialize(model : Model, filename : String)

    # call super
    super(model.vao_id,model.vbos,model.nr_vertices,model.nr_attrib_arrays)
    filenotfound(filename)
    @id = Texture.load(filename)
  end

  def draw()
    bind()
    LibGL.bind_texture(LibGL::TEXTURE_2D, @id)
    LibGL.draw_elements(LibGL::TRIANGLES, @nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))
    unbind()
  end

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
