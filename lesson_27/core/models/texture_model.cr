require "./model.cr"
require "../textures/texture.cr"

class TextureModel < Model

  property id : UInt32
  def initialize(model : Model, filename : String)

    filenotfound(filename)

    super(model.vao_id,model.vbos,model.nr_vertices,model.nr_attrib_arrays)
    @id = Texture.load(filename)
  end

  def initialize(model : Model, id : UInt32)
    super(model.vao_id,model.vbos,model.nr_vertices,model.nr_attrib_arrays)
    @id = id
  end

  # not used def draw()
  # not used   bind()
  # not used   LibGL.bind_texture(LibGL::TEXTURE_2D, @id)
  # not used   LibGL.draw_elements(LibGL::TRIANGLES, @nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))
  # not used   unbind()
  # not used end

end
