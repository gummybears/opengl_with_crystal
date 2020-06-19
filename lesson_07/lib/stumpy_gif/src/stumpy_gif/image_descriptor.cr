class StumpyGIF::ImageDescriptor
  property left_position : UInt16
  property top_position : UInt16
  property width : UInt16
  property height : UInt16

  property lct_flag : Bool
  property interlace_flag : Bool
  property sort_flag : Bool

  property lct_size_value : UInt8

  def initialize(width, height)
    @left_position = 0_u16
    @top_position = 0_u16
    @width = width.to_u16
    @height = height.to_u16

    @lct_flag = false
    @interlace_flag = false
    @sort_flag = false

    @lct_size_value = 0_u8
  end

  def lct_size
    lct_size = 2 ** (@lct_size_value + 1)
  end

  def lct_size=(value)
    log = Math.log2(value)
    if (log % 1.0) != 0.0
      raise "Invalid Global Color Table size: #{value}, must be a power of 2"
    else
      @lct_size_value = (log - 1).to_u8
    end
  end

  def write(io)
    io.write_bytes(@left_position, IO::ByteFormat::LittleEndian)
    io.write_bytes(@top_position, IO::ByteFormat::LittleEndian)
    io.write_bytes(@width, IO::ByteFormat::LittleEndian)
    io.write_bytes(@height, IO::ByteFormat::LittleEndian)

    packed_fields = 0_u8
    packed_fields |= 1 << 7 if @lct_flag
    packed_fields |= 1 << 6 if @interlace_flag
    packed_fields |= 1 << 5 if @sort_flag
    packed_fields |= @lct_size_value & 0b111

    io.write_bytes(packed_fields, IO::ByteFormat::LittleEndian)
  end
end
