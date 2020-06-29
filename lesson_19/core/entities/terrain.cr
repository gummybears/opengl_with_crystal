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

    0.upto(vertex_count - 1) do |i|
      0.upto(vertex_count - 1) do |j|

        vertices << (j / (vertex_count - 1) * size).to_f32
        vertices << 0f32
        vertices << -(i / (vertex_count - 1) * size).to_f32

        textures << j.to_f32 / (vertex_count - 1)
        textures << i.to_f32 / (vertex_count - 1)

        #
        # normal is in the y direction (up)
        #
        normals << 0.0f32
        normals << 1.0f32
        normals << 0.0f32
      end
    end

    0.upto(vertex_count - 1) do |gz|
      0.upto(vertex_count - 1) do |gx|
        top_left     = (gz * vertex_count) + gx
        top_right    = top_left + 1
        bottom_left  = ((gz + 1)*vertex_count) + gx
        bottom_right = bottom_left + 1

        indices << top_left
        indices << bottom_left
        indices << top_right
        indices << top_right
        indices << bottom_left
        indices << bottom_right
      end
    end

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
