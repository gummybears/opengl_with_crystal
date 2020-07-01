require "./bitmap.cr"

class Texture

  property id : UInt32
  def initialize(id : UInt32)
    @id = id
  end

  #
  # load a texture
  #
  def self.load(filename : String) : UInt32

    filenotfound(filename)

    # load texture data
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

    #
    # create texture
    #
    LibGL.gen_textures(1, out texture_id)
    LibGL.bind_texture(LibGL::TEXTURE_2D, texture_id)

    if bitmap.pixels.size > 0

      #
      # wrapping options
      #
      LibGL.tex_parameter_i(LibGL::TEXTURE_2D, LibGL::TEXTURE_WRAP_S, LibGL::REPEAT)
      LibGL.tex_parameter_i(LibGL::TEXTURE_2D, LibGL::TEXTURE_WRAP_T, LibGL::REPEAT)

      #
      # filtering options
      # Note: LibGL::LINEAR is better for higher quality images
      #
      LibGL.tex_parameter_i(LibGL::TEXTURE_2D, LibGL::TEXTURE_MIN_FILTER, LibGL::NEAREST)
      LibGL.tex_parameter_i(LibGL::TEXTURE_2D, LibGL::TEXTURE_MAG_FILTER, LibGL::NEAREST)

      format = bitmap.alpha? ? LibGL::RGBA : LibGL::RGB

      LibGL.tex_image_2d(LibGL::TEXTURE_2D, 0, format, bitmap.width, bitmap.height, 0, format, LibGL::UNSIGNED_BYTE, bitmap.pixels)
      LibGL.generate_mipmap(LibGL::TEXTURE_2D)

      # mipmapping already implemented
      LibGL.tex_parameter_i(LibGL::TEXTURE_2D, LibGL::TEXTURE_MIN_FILTER, LibGL::LINEAR_MIPMAP_LINEAR)
      # set level of detail of bias
      LibGL.tex_parameter_f(LibGL::TEXTURE_2D, LibGL::TEXTURE_LOD_BIAS, -0.4)

      #
      # close the texture
      #
      LibGL.bind_texture(LibGL::TEXTURE_2D, 0)

    else
      report_error("error : failed to load bitmap #{filename}")
    end

    return texture_id
  end # self.load

  #
  # load cube map
  #
  def self.load_cube_map(texture_files : Array(String) ) : UInt32

    LibGL.gen_textures(1, out texture_id)
    LibGL.active_texture(LibGL::TEXTURE0)
    LibGL.bind_texture(LibGL::TEXTURE_CUBE_MAP, texture_id)

    texture_files.each_with_index do |file,i|

      #texture_data = decode_texture_file(file)

      bitmap = Bitmap.new(file)
      format = bitmap.alpha? ? LibGL::RGBA : LibGL::RGB
      LibGL.tex_image_2d(LibGL::TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, format, bitmap.width, bitmap.height, 0, format, LibGL::UNSIGNED_BYTE, bitmap.pixels)

    end # each texture

    LibGL.tex_parameter_i(LibGL::TEXTURE_CUBE_MAP, LibGL::TEXTURE_MAG_FILTER, LibGL::LINEAR)
    LibGL.tex_parameter_i(LibGL::TEXTURE_CUBE_MAP, LibGL::TEXTURE_MIN_FILTER, LibGL::LINEAR)

    return texture_id
  end

  #
  # Loads a cube map texture
  # expects *texture_files* to be in the order of:
  # right face, left face, top face, bottom face, back face, front face
  #
  # Not used
  #
  def self.decode_texture_file(texture_file : String ) : TextureData

    filenotfound(texture_file)

    bitmap = Bitmap.new(texture_file)
    width  = bitmap.width
    height = bitmap.height
    pixels = bitmap.pixels
    r = TextureData.new(pixels,width,height)
    return r
  end

end
