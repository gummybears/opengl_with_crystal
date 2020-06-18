require "../src/stumpy_gif"
include StumpyGIF

frames = [] of Canvas

(0..5).each do |z|
  canvas = Canvas.new(256, 256)

  (0..255).each do |x|
    (0..255).each do |y|
      color = RGBA.from_rgb_n([x, y, z * 51], 8)
      canvas[x, y] = color
    end
  end

  frames << canvas
end

StumpyGIF.write(frames, "rainbow_websafe.gif", 50)
StumpyGIF.write(frames, "rainbow_median_split.gif", 50, quantization: :median_split)
StumpyGIF.write(frames, "rainbow_neuquant.gif", 50, quantization: :neuquant)
