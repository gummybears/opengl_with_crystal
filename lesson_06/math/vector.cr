#
# vector.cr
#
# Quick and dirty hack of existing code
#
module ASY
  class Vector
    property data : Array(Float32)

    def initialize(x : Float32, y : Float32, z : Float32)
      n = 3
      @data = Array.new(n) { 0.0f32 }
      @data[0] = x
      @data[1] = y
      @data[2] = z
    end

    # getters
    def x
      @data[0]
    end

    def y
      @data[1]
    end

    def z
      @data[2]
    end

    # setters
    def x=(val)
      @data[0] = val
    end

    def y=(val)
      @data[1] = val
    end

    def z=(val)
      @data[2] = val
    end

    #
    # the default Vector is a 3 dimensional vector
    #
    def initialize()
      n = 3
      @data = Array.new(n) { 0.0f32 }
    end

    #
    # initializes a zero vector given the number of columns
    #
    def initialize(nr_cols : Int32)

      if nr_cols < 1
        report_error("cannot create an empty vector")
      end

      @data = Array.new(nr_cols) { 0.0f32 }
    end

    #
    # converts an array of Int32|Float64 to Complex
    #
    private def to_real(arr : Array(Float32) ) : Array(Float32)
      data = arr.dup
      return data
    end

    #
    # initializes a vector given an array of (Int32|Float64)
    #
    def initialize(arr : Array(Float32) )
      @data = to_real(arr)
    end

    #
    # initializes a vector given an array of Complex
    #
    def initialize(arr : Array(Int32) )
      @data = arr
    end

    def size() : Int32
      return @data.size()
    end

    private def validate_range(r : ::Range(Int32, Int32) )
      if r.begin > r.end
        report_error("invalid range given [#{r.begin}..#{r.end}] for vector")
      end
    end

    private def validate_column(col : Int32)
      if col < 0 || col >= @data.size()
        report_error("invalid value for vector index #{col}")
      end
    end

    #
    # getters
    #
    def [](col : Int32) : Float32

      validate_column(col)
      r = @data[col]
      return r
    end

    #
    # returns a subvector as an array
    #
    def [](cols : ::Range(Int32, Int32) ) : ASY::Vector

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)

      arr = @data[cols.begin..cols.end]
      #return arr
      return ASY::Vector.new(arr)
    end

    #
    # returns a subvector as a vector
    #
    def subvector(cols : ::Range(Int32, Int32) ) : ASY::Vector

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)

      arr = @data[cols.begin..cols.end]
      return ASY::Vector.new(arr)
    end

    #
    # setter, real value
    #
    def []=(col : Int32, value : Real)

      validate_column(col)
      @data[col] = Complex.new(1.0 * value,0.0)
    end

    #
    # setter, complex value
    #
    def []=(col : Int32, value : Complex)

      validate_column(col)
      @data[col] = value
    end

    #
    # setter, real value
    #
    def []=(cols : ::Range(Int32, Int32), value : Real)

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)

      (cols.begin..cols.end).each do |i|
        @data[i] = Complex.new(1.0 * value,0.0)
      end
    end

    #
    # setter, complex value
    #
    def []=(cols : ::Range(Int32, Int32), value : Complex)

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)

      (cols.begin..cols.end).each do |i|
        @data[i] = value
      end
    end

    #
    # setter, vector range
    #
    def []=(cols : ::Range(Int32, Int32), value : ASY::Vector)

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)

      (0..value.size()-1).each do |i|
        index = cols.begin + i

        if index > cols.end
          break
        end

        @data[index] = value[i]
      end
    end

    #
    # returns the vector as a column vector inside a matrix
    #
    def column() : ASY::Matrix

      m = ASY::Matrix.new(size(),1,@data)
      return m
    end

    #
    # returns the transpose of the column vector as a row vector inside a matrix
    #
    def transpose() : ASY::Matrix

      nr_rows = size()
      nr_cols = 1

      m  = ASY::Matrix.new(nr_rows,nr_cols,@data)
      mt = m.t()
      return mt
    end

    #
    # returns the transpose of the column vector as a row vector inside a matrix
    #
    def t() : ASY::Matrix
      nr_rows = size()
      nr_cols = 1

      m = ASY::Matrix.new(nr_rows,nr_cols,@data)
      mt = m.t()
      return mt
    end

    #
    # returns the hermitian (complex conjugate transposed) of a vector
    #
    def h() : ASY::Matrix

      nr_rows = size()
      nr_cols = 1

      m  = ASY::Matrix.new(nr_rows,nr_cols,@data)
      mt = m.h()
      return mt
    end

    def conj() : ASY::Vector

      arr = [] of Complex
      (0..@data.size-1).each do |i|

        val = @data[i].conj
        arr << val
      end

      r = ASY::Vector.new(arr)
      return r
    end

    #
    # returns the dot product of a vector with self
    #
    def dot(other : ASY::Vector) : Complex

      r = Complex.new(0.0,0.0)
      (0..size() - 1).each do |j|
        r = r + self[j] * other[j]
      end

      return r
    end

    #
    # returns the 2 norm of a vector
    #
    def norm() : Float64 #Complex
      #val = self.dot(self)
      #return val.sqrt
      return abs()
    end

    #
    # returns the length of a vector
    #
    def abs() : Float64
      v   = self
      val = v.dot(v.conj())
      d   = Math.sqrt(val.real)
      return d
    end

    #
    # returns the length of a vector
    #
    def length() : Float64
      return self.abs()
    end

    #
    # returns the clone of a vector
    #
    def clone() : ASY::Vector

      arr = ASY::Vector.new(size())
      (0..size() - 1).each do |i|
        arr[i] = self[i]
      end

      return arr
    end

    #
    # returns the vector as an array of Float64
    #
    def to_arr() : Array(Float64)

      arr = [] of Float64

      (0..size() - 1).each do |i|
        arr << self[i].real
      end

      return arr
    end

    #
    # returns the vector as an array of Complex
    #
    def to_carr() : Array(Complex)

      arr = [] of Complex

      (0..size() - 1).each do |i|
        arr << self[i]
      end

      return arr
    end

    #
    # compares vector self with other
    # returns true when not equal
    # otherwise false
    #
    def <(other : ASY::Vector)
      len1 = self.abs()
      len2 = other.abs()

      if len1 < len2
        return true
      end

      return false
    end

    #
    # compares vector self with other
    # returns true when equal
    # otherwise false
    #
    def ==(other : ASY::Vector)

      size1 = self.size()
      size2 = other.size()

      if size1 != size2
        return false
      end

      (0..size1-1).each do |i|
        val1 = self[i]
        val2 = other[i]

        flag1 = val1.real.be_close(val2.real,ASY::EPSILON)
        flag2 = val1.imag.be_close(val2.imag,ASY::EPSILON)

        if flag1 == false || flag2 == false
          return false
        end
      end

      return true
    end

    #
    # returns true if vector v1 != v2
    #
    def !=(other : ASY::Vector)
      size1 = self.size()
      size2 = other.size()

      if size1 != size2
        return true
      end

      (0..size1-1).each do |i|
        val1 = self[i]
        val2 = other[i]

        flag1 = val1.real.be_close(val2.real,ASY::EPSILON)
        flag2 = val1.imag.be_close(val2.imag,ASY::EPSILON)

        if flag1 == true && flag2 == true
          return false
        end
      end

      return true
    end

    #
    # returns true if vector v1 <= v2
    #
    def <=(other : ASY::Vector)
      flag1 = self < other
      flag2 = self == other
      return flag1 && flag2
    end

    #
    # returns true if vector v1 >= v2
    #
    def >=(other : ASY::Vector)
      flag1 = self > other
      flag2 = self == other
      return flag1 && flag2
    end

    def <=>(other : ASY::Vector)
      len1 = self.abs()
      len2 = other.abs()

      if len1 < len2
        return -1
      elsif len1 == len2
        return 0
      end

      return 1
    end

    #
    # adds vector other to self
    #
    def +(other : ASY::Vector) : ASY::Vector

      v = ASY::Vector.new(size())
      (0..size() - 1).each do |j|
        v[j] = self[j] + other[j]
      end

      return v
    end

    #
    # subtracts vector other from self
    #
    def -(other : ASY::Vector) : ASY::Vector
      v = ASY::Vector.new(size())
      (0..size() - 1).each do |j|
        v[j] = self[j] - other[j]
      end

      return v
    end

    #
    # returns the dot product of the vector 'self' and vector 'other'
    #
    def *(other : ASY::Vector) : Complex
      return self.dot(other)
    end

    # divides self with a complex number
    def /(other : Complex) : ASY::Vector

      arr = [] of Complex
      (0..self.size() - 1).each do |i|
        if other.zero?() == false
          arr << self[i].div(other)
        else
          division_byzero(true)
        end
      end

      r = ASY::Vector.new(arr)
      return r
    end

    # divides self with a Real
    def /(other : Real) : ASY::Vector

      arr = [] of Complex
      (0..self.size() - 1).each do |i|
        if other != 0.0

          val = self[i]/other
          arr << val #Complex.new(val,0.0)
        else
          division_byzero()
        end
      end

      r = ASY::Vector.new(arr)
      return r
    end

    #
    # right multiply column vector with row vector encoded as matrix
    #
    # self  is a column vector, m rows and 1 column
    # other is a row vector (as a matrix), with 1 row and n columns
    # the result of this product is a matrix with m rows and n columns (mxn)
    #
    def *(other : ASY::Matrix) : ASY::Matrix

      m = size()
      n = other.columns()

      #
      # create the matrix
      #
      r = ASY::Matrix.new(m,n)

      (0.. m - 1).each do |i|
        (0.. n - 1).each do |j|

          #
          # Note we take row 0 of the matrix other
          # the matrix other only has 1 row and is in fact a row vector
          #
          r[i,j] = self[i] * other[0,j]
        end
      end

      return r
    end

    def empty?()
      if size() == 0
        report_error("vector is the zero vector")
      end
    end

    #
    # returns the string representation of a vector
    #
    def to_s(precision : Int32 = 2, width : Int32 = 6) : String
      s = "("

      arr = [] of String
      (0..size() - 1).each do |i|

        val = @data[i]
        arr << val.to_s
      end

      s = s + arr.join(",")
      s = s + ")"
      return s
    end

    #
    # returns a unit vector (dim n) with 1 in position 'i'
    # Note: zero based
    #
    def self.eye(dim : Int32,i : Int32) : ASY::Vector

      r = ASY::Vector.new(dim)
      r[i] = Complex.new(1.0,0.0)
      return r
    end

    #
    # concatenates a vector with self
    #
    def concat(other : ASY::Vector) : ASY::Vector
      a1 = self.clone.to_arr
      a2 = other.clone.to_arr

      arr = [] of Float64
      a1.each do |x|
        arr << x
      end

      a2.each do |x|
        arr << x
      end

      r = ASY::Vector.new(arr)
      return r
    end

    #
    # returns a vector with random values
    #
    def self.rand(dim : Int32, min_val : Real = 0, max_val : Real = 1) : ASY::Vector

      if min_val > max_val
        swap_val = max_val
        min_val  = max_val
        max_val  = swap_val
      end

      val_range = ::Range.new(min_val,max_val)

      arr = [] of Float64

      (0..dim-1).each do |i|
        arr << 1.0 * Random.new.rand(val_range)
      end

      v = ASY::Vector.new(arr)
      return v
    end

    #
    # compare both vectors within the tolerance of epsilon
    #
    def compare?(other : ASY::Vector, show : Bool = false, eps : Float64 = 1.0e-5) : Bool

      self.empty?()
      other.empty?()

      if other.size() != self.size()
        return false
      end

      (0..other.size()-1).each do |i|
        diff = (other[i] - self[i]).abs
        if diff > eps
          if show
            puts "comparing #{other[i]} and #{self[i]} failed at (#{i}), difference found of #{diff}"
          end
          return false
        end
      end

      return true
    end

  end
end

# operator Int32 * ASY::Vector
struct Int32

  # multiplies Vector other with a Int32
  def *(other : ASY::Vector) : ASY::Vector

    arr = [] of Float64
    (0..other.size() -1).each do |i|
      arr << 1.0 * self * other[i].real
    end

    r = ASY::Vector.new(arr)
    return r
  end
end

# operator Float64 * ASY::Vector
struct Float64

  # multiplies Vector other with a Float64
  def *(other : ASY::Vector) : ASY::Vector

    arr = [] of Float64
    (0..other.size() - 1).each do |i|
      arr << 1.0 * self * other[i].real
    end

    r = ASY::Vector.new(arr)
    return r
  end
end

# operator Complex * ASY::Vector
struct Complex

  # multiplies vector other with a complex number
  def *(other : ASY::Vector) : ASY::Vector

    arr = [] of Complex
    (0..other.size() - 1).each do |i|
      arr << self * other[i]
    end

    r = ASY::Vector.new(arr)
    return r
  end

  # divides vector other with a complex number
  def /(other : ASY::Vector) : ASY::Vector

    arr = [] of Complex
    (0..other.size() - 1).each do |i|
      if other[i].zero?() == false
        arr << self.div(other[i])
      else
        division_byzero(true)
      end
    end

    r = ASY::Vector.new(arr)
    return r
  end
end
