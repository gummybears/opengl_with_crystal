class StumpyGIF::ColorTable
  getter colors : Slice(RGBA)

  def initialize
    @colors = Slice(RGBA).new(256) { RGBA.new(0_u16, 0_u16, 0_u16, 0_u16) }
  end

  def write(io)
    @colors.each do |color|
      r, g, b = color.to_rgb8

      io.write_bytes(r, IO::ByteFormat::LittleEndian)
      io.write_bytes(g, IO::ByteFormat::LittleEndian)
      io.write_bytes(b, IO::ByteFormat::LittleEndian)
    end
  end

  def colors=(colors)
    colors.each_with_index do |color, index|
      @colors[index] = color
    end
  end

  def closest_index(color)
    closest = @colors.min_by do |other|
      (other.r.to_i64 - color.r.to_i64) ** 2 +
      (other.g.to_i64 - color.g.to_i64) ** 2 +
      (other.b.to_i64 - color.b.to_i64) ** 2
    end

    @colors.index(closest) || 0
  end
end
