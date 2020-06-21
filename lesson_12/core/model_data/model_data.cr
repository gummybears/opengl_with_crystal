require "../obj/obj.cr"

class ModelData

  property vertices : Array(Float32)
  property textures : Array(Float32)
  property normals  : Array(Float32)
  property indices  : Array(Int32)

  def initialize(vertices : Array(Float32), textures :  Array(Float32), normals :  Array(Float32), indices : Array(Int32) )
    @vertices = vertices
    @textures = textures
    @normals  = normals
    @indices  = indices
  end

  #
  # load model from an OBJ file
  #
  def self.from_obj(filename : String) : ModelData
    filenotfound(filename)

    obj = OBJ.new
    obj.open(filename)
    obj.to_opengl

    vertices = obj.vertices_arr
    indices  = obj.indices_arr
    textures = obj.textures_arr
    normals  = obj.normals_arr

    data = ModelData.new(vertices,textures,normals,indices)
    return data
  end

  def self.terrain(grid_x : Int32, grid_z : Int32, vertex_count : Int32, size : Int32) : ModelData

    #vertex_count = 10
    #size         = 800

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

    r = ModelData.new(vertices,textures,normals,indices)
    return r
  end

end
