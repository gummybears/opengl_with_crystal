class Terrain

  property x     : Float32
  property z     : Float32
  property model : TextureModel

  def initialize(grid_x : Float32, grid_z : Float32, vertex_count : Int32, size : Int32, filename : String)

    filenotfound(filename)

    @x         = grid_x * size
    @z         = grid_z * size
    model_data = generate(vertex_count,size)
    @model = TextureModel.new(Model.load(model_data),filename)

  end

  def generate(vertex_count : Int32, size : Int32) : ModelData
    vertices = [] of Float32
    normals  = [] of Float32
    textures = [] of Float32
    indices  = [] of Int32

    dx = (vertex_count-1).to_f32
    #dx = (vertex_count).to_f32
    dy = 0.0f32
    dz = dx

    (0.. vertex_count - 1).each do |i|
      (0.. vertex_count - 1).each do |j|

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

    (0..vertex_count - 1).each do |i|
      (0..vertex_count - 1).each do |j|

        top_left     = (i * vertex_count) + j
        top_right    = top_left + 1
        bottom_left  = ((i + 1) * vertex_count) + j
        bottom_right = bottom_left + 1
        indices << top_left
        indices << bottom_left
        indices << top_right
        indices << top_right
        indices << bottom_left
        indices << bottom_right
      end # each j
    end # each i

    #puts "vertices"
    #puts vertices
    #
    #puts "textures"
    #puts textures
    #
    #puts "indices"
    #puts indices

    r = ModelData.new(vertices,textures,normals,indices)
    return r
  end # generate

end
