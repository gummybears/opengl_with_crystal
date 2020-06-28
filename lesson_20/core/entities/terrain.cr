class Terrain

  property x            : Float32
  property z            : Float32
  property model        : Model
  property texture_pack : TerrainTexturePack
  property blend_map    : TerrainTexture

  def initialize(grid_x : Float32, grid_z : Float32, vertex_count : Int32, size : Int32, texture_pack : TerrainTexturePack, blend_map : TerrainTexture)

    @texture_pack = texture_pack
    @blend_map    = blend_map

    @x         = grid_x * size
    @z         = grid_z * size
    model_data = generate(vertex_count,size)
    @model     = Model.load(model_data)
  end

  def generate(vertex_count : Int32, size : Int32) : ModelData
    vertices = [] of Float32
    normals  = [] of Float32
    textures = [] of Float32
    indices  = [] of Int32

    dx = (vertex_count-1).to_f32
    dy = 0.0f32
    dz = dx

    (0.. vertex_count - 1).each do |i|
      (0.. vertex_count - 1).each do |j|

        vertices <<  (j/dx).to_f32 * size
        vertices <<  dy
        vertices <<  -(i/dz).to_f32 * size

        #
        # normal is in the y direction (up)
        #
        normals << 0.0f32
        normals << 1.0f32
        normals << 0.0f32

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

    r = ModelData.new(vertices,textures,normals,indices)
    return r
  end # generate

  def create_model_matrix() : GLM::Matrix

    position = GLM::Vector3.new(@x,0,@z)
    rot      = GLM::Vector3.new(0,0,0)
    scale    = GLM::Vector3.new(0,0,0)

    trans    = GLM.translate(position)
    rotation = GLM.rotation(rot)
    scale    = GLM.scale(scale)

    r = trans * rotation * scale
    return r
  end

end
