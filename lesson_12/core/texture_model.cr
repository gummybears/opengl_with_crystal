require "./model.cr"
require "./texture/texture.cr"

class TextureModel < Model

  property id : UInt32

  def initialize(model : Model, filename : String)

    # call super
    super(ModelType::TEXTURE, model.vao_id,model.vbos,model.nr_vertices,model.nr_attrib_arrays)
    filenotfound(filename)
    @id = Texture.load(filename)
  end

  def draw()
    bind()
    LibGL.bind_texture(LibGL::TEXTURE_2D, @id)
    LibGL.draw_elements(LibGL::TRIANGLES, @nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))
    unbind()
  end

end
