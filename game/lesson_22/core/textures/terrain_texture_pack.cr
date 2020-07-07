class TerrainTexturePack

  property background_texture : TerrainTexture
  property r_texture : TerrainTexture
  property g_texture : TerrainTexture
  property b_texture : TerrainTexture

  def initialize(background_texture : TerrainTexture, r_texture : TerrainTexture, g_texture : TerrainTexture, b_texture : TerrainTexture)
    @background_texture = background_texture
    @r_texture = r_texture
    @g_texture = g_texture
    @b_texture = b_texture
  end

end
