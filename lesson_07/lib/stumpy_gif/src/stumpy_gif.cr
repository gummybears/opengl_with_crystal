require "stumpy_core"
require "./stumpy_gif/lzw"
require "./stumpy_gif/logical_screen_descriptor"
require "./stumpy_gif/color_table"
require "./stumpy_gif/image"
require "./stumpy_gif/extension/*"
require "./stumpy_gif/websafe"
require "./stumpy_gif/neuquant"
require "./stumpy_gif/median_split"

module StumpyGIF
  include StumpyCore

  def self.write(frames, filename : String, delay_time = 10, quantization = :websafe)
    File.open(filename, "w") do |io|
      write frames, io, delay_time, quantization
    end
  end

  def self.write(frames, io : IO, delay_time = 10, quantization = :websafe)
    "GIF89a".chars.each do |char|
      io.write_bytes(char.ord.to_u8, IO::ByteFormat::LittleEndian)
    end

    canvas = frames.first
    lsd = LogicalScreenDescriptor.new(canvas.width, canvas.height)
    lsd.write(io)

    gct = ColorTable.new

    case quantization
    when :websafe
      gct.colors = Websafe.colors
    when :median_split
      gct.colors = MedianSplit.colors(frames)
    when :neuquant
      gct.colors = NeuQuant.new(frames).colors
    else
      raise "Unknown quantization method: #{quantization}"
    end

    gct.write(io)

    Extension::Netscape.new.write(io) if frames.size > 1


    frames.each do |canvas|
      gce = Extension::GraphicControl.new(delay_time)
      gce.write(io)

      image = Image.new(canvas, gct)
      image.write(io)
    end

    io.write_bytes(0x3b_u8, IO::ByteFormat::LittleEndian)
  end
end
