require "./model.cr"
require "../texture/texture.cr"

class TextureModel < Model

  property id : UInt32
  def initialize(model : Model, filename : String)

    filenotfound(filename)

    super(model.vao_id,model.vbos,model.nr_vertices,model.nr_attrib_arrays)
    @id = Texture.load(filename)
  end

  # disabled def draw()
  # disabled   bind()
  # disabled   LibGL.bind_texture(LibGL::TEXTURE_2D, @id)
  # disabled   LibGL.draw_elements(LibGL::TRIANGLES, @nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))
  # disabled   unbind()
  # disabled end

end
