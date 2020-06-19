def twotriangles() : {Array(Float32), Array(Int32), Array(Float32)}

  vertices = [
               0.5f32,  0.5f32,  0.0f32,
               0.5f32, -0.5f32,  0.0f32,
              -0.5f32, -0.5f32,  0.0f32,
              -0.5f32,  0.5f32,  0.0f32
            ]

  indices = [
              0,1,3, # first triangle
              1,2,3  # second triangle
            ]


  texture_coords = [
            1.0f32, 1.0f32, # top right
            1.0f32, 0.0f32, # bottom right
            0.0f32, 0.0f32, # bottom let
            0.0f32, 1.0f32  # top let
          ]

  return vertices, indices, texture_coords
end
