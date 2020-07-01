#require "lib_gl"
require "stumpy_png"
require "./color.cr"
#
# Provides a resource wrapper around the image loading library.
# This keeps the image loading abstracted from the engine thus enabling
# it to be easily changed in the future.
#
class Bitmap
  property filename     : String
  property width        : Int32 = 0
  property height       : Int32 = 0
  property num_channels : UInt8 = 0
  property pixels       : Array(Array(Color))
  #

  def initialize(filename : String)
    @filename = filename
    @pixels = Array.new(0) { Array.new(0) { Color.new }}
  end


  # Loads a bitmap
  def load()

    canvas = StumpyPNG.read(@filename)

    # create bitmap
    @num_channels = 4
    @width        = canvas.width
    @height       = canvas.height

    @pixels = Array.new(@width) { Array.new(@height) { Color.new }}

    (0...canvas.width).each do |x|
      (0...canvas.height).each do |y|
        color = canvas.get(x, y).to_rgba
        @pixels[x][y] = Color.new(color[0], color[1], color[2], color[3])
      end
    end
  end

  # Loads a bitmap
  def save(width : Int32, height : Int32)

    canvas = StumpyPNG::Canvas.new(width,height)

    (0...width-1).each do |x|
      (0...height-2).each do |y|

        if x <= width//2 && y <= height//2
          color = StumpyPNG::RGBA.from_rgb_n(255,0,0, 8)
          canvas[x, y] = color

        elsif x >= width//2 && y <= height//2
          color = StumpyPNG::RGBA.from_rgb_n(0,255,0, 8)
          canvas[x, y] = color
        elsif x >= width//2 && y >= height//2
          color = StumpyPNG::RGBA.from_rgb_n(0,0,255, 8)
          canvas[x, y] = color
        else
          color = StumpyPNG::RGBA.from_rgb_n(0,255,255, 8)
          canvas[x, y] = color

        end
      end
    end

    StumpyPNG.write(canvas, @filename)
  end
end
