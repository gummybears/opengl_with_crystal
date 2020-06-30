#require "lib_gl"
require "stumpy_png"
require "./bitmap.cr"

bitmap = Bitmap.new("color_squares.png")
bitmap.save(256,256)
