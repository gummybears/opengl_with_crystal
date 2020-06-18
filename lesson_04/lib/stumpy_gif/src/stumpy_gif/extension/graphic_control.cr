class StumpyGIF::Extension::GraphicControl
  property disposal_method : UInt8
  property user_input_flag : Bool
  property transparent_color_flag : Bool

  property delay_time : UInt16
  property transparent_color_index : UInt8

  def initialize(delay_time)
    @disposal_method = 0_u8
    @user_input_flag = false
    @transparent_color_flag = false
    @transparent_color_index = 0_u8
    @delay_time = delay_time.to_u16
  end

  def write(io)
    # Extension header
    io.write_bytes(0x21_u8, IO::ByteFormat::LittleEndian)
    io.write_bytes(0xf9_u8, IO::ByteFormat::LittleEndian)

    # Block size
    io.write_bytes(4_u8, IO::ByteFormat::LittleEndian)

    packed_fields = 0_u8
    packed_fields |= @disposal_method << 2
    packed_fields |= 2 if @user_input_flag
    packed_fields |= 1 if @transparent_color_flag

    io.write_bytes(packed_fields, IO::ByteFormat::LittleEndian)
    io.write_bytes(@delay_time, IO::ByteFormat::LittleEndian)
    io.write_bytes(@transparent_color_index, IO::ByteFormat::LittleEndian)

    # Terminator
    io.write_bytes(0_u8, IO::ByteFormat::LittleEndian)
  end
end
