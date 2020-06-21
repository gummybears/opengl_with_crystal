#require "./texture_model.cr"

class TerrainModel < Model #< TextureModel

  #property size         : Float32 = 800
  #property vertex_count : Int32 = 10
  #
  #property x            : Float32
  #property z            : Float32
  #
  #property model        : Model

  #def initialize(grid_x : Int32, grid_z : Int32) #, filename : String)
  #
  #  #filenotfound(filename)
  #
  #  @x = grid_x * size
  #  @z = grid_z * size
  #
  #  @model = generate()
  #  #super(@model,filename)
  #  super(@model.vao_id,@model.vbos,@model.nr_vertices,@model.nr_attrib_arrays)
  #end

  def self.load(grid_x : Int32, grid_z : Int32) : Model

    vertex_count = 10
    size         = 800

    nr_count = (vertex_count * vertex_count)
    vertices = Array.new(nr_count * 3) {0.0f32}
    normals  = Array.new(nr_count * 3) {0.0f32}
    textures = Array.new(nr_count * 2) {0.0f32}

    size = 6 * (nr_count - 1) * (nr_count - 1)
    indices = Array.new(size) { 0 }

    counter = 0

    (0.. vertex_count - 1).each do |i|
      (0.. vertex_count - 1).each do |j|

        factor = (vertex_count - 1).to_f32 * size

        vertices[counter*3]     = factor
        vertices[counter*3 + 1] = 0
        vertices[counter*3 + 2] = i.to_f32/factor
        normals[counter*3]      = 0
        normals[counter*3 + 1]  = 1
        normals[counter*3 + 2]  = 0

        textures[counter*2]     = j.to_f32/(vertex_count - 1)
        textures[counter*2 + 1] = i.to_f32/(vertex_count - 1)
        counter = counter + 1

      end
    end

    counter = 0
    (0..vertex_count - 1).each do |gz|
      (0..vertex_count - 1).each do |gx|

        top_left     = gz * vertex_count + gx
        top_right    = top_left + 1
        bottom_left  = (gz + 1) * vertex_count + gz
        bottom_right = bottom_left + 1

        indices[counter] = top_left
        counter = counter + 1

        indices[counter] = bottom_left
        counter = counter + 1

        indices[counter] = top_right
        counter = counter + 1

        indices[counter] = top_right
        counter = counter + 1

        indices[counter] = bottom_left
        counter = counter + 1

        indices[counter] = bottom_right
        counter = counter + 1
      end
    end

    r = Model.load(vertices,indices,textures,normals)
    return r
  end

  #def draw()
  #  bind()
  #  #LibGL.bind_texture(LibGL::TEXTURE_2D, @id)
  #  LibGL.draw_elements(LibGL::TRIANGLES, @nr_vertices, LibGL::UNSIGNED_INT, Pointer(Void).new(0))
  #  unbind()
  #end

end
