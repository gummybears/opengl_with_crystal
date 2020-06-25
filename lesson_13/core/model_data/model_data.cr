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

    r = ModelData.new(vertices,textures,normals,indices)
    return r
  end
end
