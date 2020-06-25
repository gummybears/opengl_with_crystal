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
    if File.exists?(filename) == false
      puts "file #{filename} not found"
      exit
    end

    # load texture data
    bitmap = Bitmap.new(filename)
    #
    # best results with textures
    # when the width/height are modulo 2
    #
    modulo_width = bitmap.width % 2
    module_height = bitmap.height % 2
    if modulo_width != 0 || module_height != 0
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
      LibGL.tex_parameter_i(LibGL::TEXTURE_2D, LibGL::TEXTURE_MIN_FILTER, LibGL::LINEAR_MIPMAP_LINEAR)
      LibGL.tex_parameter_f(LibGL::TEXTURE_2D, LibGL::TEXTURE_LOD_BIAS, -0.4)

      #
      # close the texture
      #
      LibGL.bind_texture(LibGL::TEXTURE_2D, 0)


    else
      report_error("error : failed to load bitmap #{filename}")
      #exit
    end
    return texture_id

  end
end
