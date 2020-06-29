require "./terrain.cr"

TERRAIN_MAX_HEIGHT      =  40
TERRAIN_MAX_PIXEL_COLOR = 256 * 256 * 256
TERRAIN_SIZE            = 800

class TerrainHeightMap < Terrain

  property x            : Float32
  property z            : Float32
  property model        : Model
  property texture_pack : TerrainTexturePack
  property blend_map    : TerrainTexture

  def initialize(grid_x : Float32, grid_z : Float32, texture_pack : TerrainTexturePack, blend_map : TerrainTexture, filename : String = "")

    vertex_count = 0
    size         = TERRAIN_SIZE

    filenotfound(filename)

    super(grid_x,grid_z,vertex_count,size,texture_pack, blend_map)

    @x = grid_x * TERRAIN_SIZE
    @z = grid_z * TERRAIN_SIZE

    model_data = generate_height_map(filename)
    @model     = Model.load(model_data)
  end


  def generate_height_map(filename : String) : ModelData

    # load height map
    bitmap = Bitmap.new(filename)
    #
    # best results with textures
    # when the width/height are modulo 2
    #
    modulo_width  = bitmap.width % 2
    modulo_height = bitmap.height % 2
    if modulo_width != 0 || modulo_height != 0
      puts "warning : texture bitmap width/height is not modulo 2"
    end

    vertex_count = bitmap.height

    vertices = [] of Float32
    normals  = [] of Float32
    textures = [] of Float32
    indices  = [] of Int32

    dx = (vertex_count-1).to_f32
    dy = 0.0f32
    dz = dx

    0.upto(vertex_count - 1) do |i|
      0.upto(vertex_count - 1) do |j|

        vertices << (j / (vertex_count - 1) * TERRAIN_SIZE).to_f32
        vertices << get_height(j, i, bitmap)
        vertices << (i / (vertex_count - 1) * TERRAIN_SIZE).to_f32

        textures << j.to_f32 / (vertex_count - 1)
        textures << i.to_f32 / (vertex_count - 1)

        norm = calculate_normals(j, i, bitmap)
        normals << norm.x
        normals << norm.y
        normals << norm.z
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
  end # generate_height_map

  def get_height(x : Int32, z : Int32, bitmap : Bitmap) : Float32

    if x < 0 || x >= bitmap.height || z < 0 || z >= bitmap.height
      return 0f32
    end

    pixel  = bitmap.pixel(x, z)
    height = -((pixel.red.to_i32 << 16) + (pixel.green.to_i32 << 8) + pixel.blue.to_i32).to_f32
    height += TERRAIN_MAX_PIXEL_COLOR/2f32
    height /= TERRAIN_MAX_PIXEL_COLOR/2f32
    height *= TERRAIN_MAX_HEIGHT
    return height
  end

  def calculate_normals(x : Int32, z : Int32, bitmap : Bitmap) : GLM::Vector3
    height_l = get_height(x - 1, z, bitmap)
    height_r = get_height(x + 1, z, bitmap)
    height_d = get_height(x, z - 1, bitmap)
    height_u = get_height(x, z + 1, bitmap)

    normal = GLM::Vector3.new(height_l - height_r, 2f32, height_d - height_u)
    normal.to_normalized
  end
end
