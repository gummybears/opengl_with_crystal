class StumpyGIF::Extension::Netscape
  property loop_count : UInt16
  def initialize(@loop_count = 0_u16)
  end

  def write(io)
    # Extension header
    io.write_bytes(0x21_u8, IO::ByteFormat::LittleEndian)
    io.write_bytes(0xff_u8, IO::ByteFormat::LittleEndian)

    # Block size
    io.write_bytes(11_u8, IO::ByteFormat::LittleEndian)

    "NETSCAPE2.0".chars.each do |c|
      io.write_bytes(c.ord.to_u8, IO::ByteFormat::LittleEndian)
    end

    # Sub-block size
    io.write_bytes(3_u8, IO::ByteFormat::LittleEndian)

    # Loop sub-block
    io.write_bytes(1_u8, IO::ByteFormat::LittleEndian)

    # Loop as long as possible
    # TODO: make this customizable
    io.write_bytes(@loop_count, IO::ByteFormat::LittleEndian)

    # Block terminator
    io.write_bytes(0_u8, IO::ByteFormat::LittleEndian)
  end
end
