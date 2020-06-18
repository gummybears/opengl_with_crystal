require "./image_descriptor"
require "./color_table"

class StumpyGIF::Image
  property descriptor : ImageDescriptor
  property canvas : Canvas
  property local_color_table : ColorTable
  property global_color_table : ColorTable

  def initialize(@canvas, @global_color_table)
    @descriptor = ImageDescriptor.new(canvas.width, canvas.height)
    @local_color_table = ColorTable.new
  end

  def write(io)
    io.write_bytes(0x2c_u8, IO::ByteFormat::LittleEndian)
    @descriptor.write(io)
    @local_color_table.write(io) if @descriptor.lct_flag

    lzw_min_code_size = 8_u8
    output = [] of UInt8

    x = 0
    y = 0

    io.write_bytes(lzw_min_code_size, IO::ByteFormat::LittleEndian)

    canvas.pixels.each do |pixel|
      index = @global_color_table.closest_index(pixel)
      output << index.to_u8
    end

    lzw = LZW.new(lzw_min_code_size)

    # wrapper = BitWrapper.new
    # wrapper.write_bits(lzw.encode(output))

    # bytes = wrapper.bytes
    bytes = lzw.encode(output)

    bytes.each_slice(255) do |block|
      io.write_bytes(block.size.to_u8, IO::ByteFormat::LittleEndian)
      block.each do |byte|
        io.write_bytes(byte, IO::ByteFormat::LittleEndian)
      end
    end

    # Empty block as terminator
    io.write_bytes(0_u8, IO::ByteFormat::LittleEndian)
  end
end
