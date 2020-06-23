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

  def self.terrain(x : Float32, z : Float32, vertex_count : Int32, size : Int32) : ModelData

    #nr_count = (vertex_count * vertex_count)
    #vertices = Array.new(nr_count * 3) {0.0f32}
    #normals  = Array.new(nr_count * 3) {0.0f32}
    #textures = Array.new(nr_count * 2) {0.0f32}
    #counter = 0

    # not used nr_indices = 6 * (nr_count - 1) * (nr_count - 1)
    # not used indices = Array.new(nr_indices) { 0 }

    vertices = [] of Float32
    normals  = [] of Float32
    textures = [] of Float32


    if vertex_count == 1
      report_error("vertex count must be greater than 1")
    end

    #dx = (vertex_count-1).to_f32
    dx = (vertex_count).to_f32
    dy = 0.0f32
    dz = dx

    puts "dx #{dx} dy #{dy} dz #{dz}"

    (0.. vertex_count - 1).each do |i|
      (0.. vertex_count - 1).each do |j|

        # vertices[counter*3]     = (j/dx).to_f32 * size
        # vertices[counter*3 + 1] = dy
        # vertices[counter*3 + 2] = -(i/dz).to_f32 * size
        #
        # # normal is in the y direction (up)
        # normals[counter*3]      = 0
        # normals[counter*3 + 1]  = 1
        # normals[counter*3 + 2]  = 0
        #
        # textures[counter*2]     = (j / dx).to_f32
        # textures[counter*2 + 1] = (i / dx).to_f32
        # counter = counter + 1

        vertices <<  (j/dx).to_f32 * size
        vertices <<  dy
        vertices <<  -(i/dz).to_f32 * size

        # normal is in the y direction (up)
        normals << 0
        normals << 1
        normals << 0

        textures << (j / dx).to_f32
        textures << (i / dx).to_f32
      end
    end

    # nr_triples   = vertices.size/3
    # nr_triangles = nr_triples/2
    # #puts "nr triangles #{nr_triangles.to_i}"

    indices = [] of Int32
    (0..vertex_count - 1).each do |i|
      (0..vertex_count - 1).each do |j|

        top_left     = (i * vertex_count) + j
        top_right    = top_left + 1
        bottom_left  = ((i + 1) * vertex_count) + j
        bottom_right = bottom_left + 1

        #puts "i #{i} j #{j} tl #{top_left} tr #{top_right} bl #{bottom_left} br #{bottom_right}"

        indices << top_left
        indices << bottom_left
        indices << top_right
        indices << top_right
        indices << bottom_left
        indices << bottom_right
      end

    end

    #puts "vertices (#{vertices.size}), nr triples #{vertices.size/3}"
    #puts vertices
    #
    #puts "textures"
    #puts textures
    #
    #puts "indices"
    #puts indices

    r = ModelData.new(vertices,textures,normals,indices)
    return r
  end

  def self.twotriangles() : ModelData

    z = -1.0f32
    z = 0.0f32
    vertices = [
                0.5f32,  0.5f32,  z,
                0.5f32, -0.5f32,  z,
                -0.5f32, -0.5f32,  z,
                -0.5f32,  0.5f32,  z
              ]

    indices = [
                0,1,3, # first triangle
                1,2,3  # second triangle
              ]

    x = 0.0f32
    y = 0.0f32
    z = 1.0f32
    normals = [
                x,y,z,
                x,y,z,
                x,y,z,
                x,y,z
              ]


    textures = [
              1.0f32, 1.0f32, # top right
              1.0f32, 0.0f32, # bottom right
              0.0f32, 0.0f32, # bottom left
              0.0f32, 1.0f32  # top left
            ]

    puts "vertices"
    puts vertices
    #

    puts "textures"
    puts textures

    puts "indices"
    puts indices

    r = ModelData.new(vertices,textures,normals,indices)
    return r
  end
end
