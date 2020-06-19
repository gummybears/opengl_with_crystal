class StumpyGIF::LogicalScreenDescriptor
  property width : UInt16
  property height : UInt16

  property gct_flag : Bool
  property sort_flag : Bool
  property color_resolution : UInt8

  property background_color_index : UInt8
  property pixel_aspect_ration : UInt8

  def initialize(width, height)
    @width = width.to_u16
    @height = height.to_u16
    @gct_flag = true
    @color_resolution = 8_u8
    @sort_flag = false
    @gct_size_value = 7_u8
    @background_color_index = 0_u8
    @pixel_aspect_ration = 0_u8
  end

  def gct_size
    gct_size = 2 ** (@gct_size_value + 1)
  end

  def gct_size=(value)
    log = Math.log2(value)
    if (log % 1.0) != 0.0
      raise "Invalid Global Color Table size: #{value}, must be a power of 2"
    else
      @gct_size_value = (log - 1).to_u8
    end
  end

  def write(io)
    io.write_bytes(@width, IO::ByteFormat::LittleEndian)
    io.write_bytes(@height, IO::ByteFormat::LittleEndian)

    packed_fields = 0_u8
    packed_fields |= 1 << 7 if @gct_flag
    packed_fields |= ((@color_resolution - 1) & 0b111) << 4
    packed_fields |= 1 << 3 if @sort_flag
    packed_fields |= @gct_size_value & 0b111

    io.write_bytes(packed_fields, IO::ByteFormat::LittleEndian)
    io.write_bytes(@background_color_index, IO::ByteFormat::LittleEndian)
    io.write_bytes(@pixel_aspect_ration, IO::ByteFormat::LittleEndian)
  end
end
