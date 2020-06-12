lib LibGL
  alias Enum = UInt32
  alias Boolean = UInt8
  alias Bitfield = UInt32
  alias Byte = Int8
  alias Short = Int16
  alias Int = Int32 
  alias Long = Int64
  alias UByte = UInt8
  alias UShort = UInt16
  alias UInt = UInt32
  alias ULong = UInt64
  alias Sizei = Int32
  alias Float = Float32
  alias Double = Float64
  alias SizeiPtr = LibC::SizeT
  alias IntPtr = LibC::SizeT
  alias Char = UInt8
  alias Sync = Pointer(Void)
  alias Debugproc = (Enum, Enum, UInt, Enum, Sizei, Pointer(Char), Pointer(Void) -> Void)
end