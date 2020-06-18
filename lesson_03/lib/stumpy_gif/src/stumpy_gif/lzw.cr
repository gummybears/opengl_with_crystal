class StumpyGIF::LZW
  MAX_DICT = 4096

  property min_code_size : UInt8

  property clear_code : UInt16
  property code_mask : UInt16
  property eoi_code : UInt16
  property next_code : UInt16

  property code_size : UInt8

  def initialize(@min_code_size)
    @clear_code = (1 << @min_code_size).to_u16
    @eoi_code = @clear_code + 1 # End of Information code
    @next_code = @eoi_code + 1

    @code_mask = @clear_code - 1
    @code_size = @min_code_size + 1
    @cur_shift = 0
    @cur_code = 0_u16
    @code_table = {} of UInt64 => UInt16

    @cur = 0_u64
    @buf = Array(UInt8).new
    @pos = 0
  end

  def encode(data)
    @cur_code = data[0].to_u16 & @code_mask
    emit_code(@clear_code)
    @first = false

    i = 1
    while i < data.size
      k = data[i] & @code_mask
      cur_key = (@cur_code.to_u64 << 8 | k.to_u64).to_u32.to_u64

      if @code_table.has_key?(cur_key)
        @cur_code = @code_table[cur_key]
      else
        emit_code(@cur_code)

        if @next_code == MAX_DICT
          emit_code(@clear_code)
          @next_code = @eoi_code + 1
          @code_size = @min_code_size + 1
          @code_table = {} of UInt64 => UInt16
        else
          if @next_code >= (1 << @code_size)
            @code_size += 1
          end
          @code_table[cur_key] = @next_code
          @next_code += 1
        end

        @cur_code = k.to_u16
      end

      i += 1
    end

    emit_code(@cur_code)
    emit_code(@eoi_code)
    emit_bits(1)

    @buf
  end

  def emit_code(code)
    @cur |= code.to_u64 << @cur_shift
    @cur_shift += @code_size

    emit_bits(8) if @cur_shift >= 8
  end

  def emit_bits(n)
    while @cur_shift >= n
      @buf << (@cur & 0xff).to_u8
      @cur >>= 8
      @cur_shift -= 8
    end
  end
end
