#
# matrix.cr
#
module GLM
  enum Storage
    ROWMAJOR = 0
    COLMAJOR = 1
  end

  class Matrix
    getter   nr_rows : Int32
    getter   nr_cols : Int32
    property buffer  : Float32*
    property status  : Int32 = 0

    property storage : GLM::Storage = GLM::Storage::ROWMAJOR

    #
    # the default Matrix is a matrix with 2 rows and 2 columns
    #
    def initialize()
      @nr_rows = 4
      @nr_cols = 4

      @buffer = Pointer(Float32).malloc( nr_rows*nr_cols )
    end

    # computes the offset into the internal 1-dimensional array 'data'
    private def compute_index(row : Int32, col : Int32) : Int32

      i = 0

      case @storage
        when GLM::Storage::ROWMAJOR
          i = row * @nr_cols + col

        when GLM::Storage::COLMAJOR
          report_error("not implemented")

        else
          # Crystal 0.34
      end # case

      return i
    end

    #
    # given a row and column
    # computes the offset in the array '@buffer'
    # in row major order (slow)
    #
    private def row_col_to_index(row : Int32, col : Int32) : Int32

      #index = row * @nr_cols + col
      index = compute_index(row,col)

      if index >= 0 && index < 16
        return index
      end
      report_error("invalid indices for matrix[#{row},#{col}]")
    end

    private def negative_row(row : Int32) : Int32

      # allow negative row index
      if row < 0
        row = @nr_rows + row
      end

      return row
    end

    private def negative_column(col : Int32) : Int32

      # allow negative column index
      if col < 0
        col = @nr_cols + col
      end

      return col
    end

    private def validate_row(row : Int32)
      if row < 0 || row >= @nr_rows
        report_error("invalid index for matrix row #{row}")
      end
    end

    private def validate_column(col : Int32)
      if col < 0 || col >= @nr_cols
        report_error("invalid index for matrix column #{col}")
      end
    end

    private def validate_range(r : ::Range(Int32, Int32) )
      if r.begin > r.end
        report_error("invalid range given [#{r.begin}..#{r.end}] for matrix")
      end
    end

    #
    # retrieves the value at the given row and column
    #
    def [](row : Int32,col : Int32) : Float32

      row = negative_row(row)
      col = negative_column(col)

      validate_row(row)
      validate_column(col)

      r = @buffer[row_col_to_index(row, col)]
      return r
    end

    #
    # getter, returns a row matrix (1 x nr columns)
    #
    def [](row : Int32, cols : ::Range(Int32, Int32) ) : GLM::Matrix

      validate_row(row)
      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)

      # calculate the number of columns
      nrcols = (cols.end - cols.begin + 1).abs
      r      = GLM::Matrix.new(1,nrcols)

      colindex = 0
      (cols.begin..cols.end).each do |j|
        r[0,colindex] = self[row,j]
        colindex = colindex + 1
      end

      return r
    end

    #
    # getter, returns a column matrix (nr rows x 1)
    #
    def [](rows : ::Range(Int32, Int32), col : Int32) : GLM::Matrix

      validate_range(rows)
      validate_row(rows.begin)
      validate_row(rows.end)
      validate_column(col)

      # calculate the number of rows
      nrrows = (rows.end - rows.begin + 1).abs

      #
      # need to retrieve the column values individually
      #
      arr = [] of Complex
      (rows.begin..rows.end).each do |i|
        index = row_col_to_index(i,col)
        arr << @buffer[index]
      end

      r = GLM::Matrix.new(nrrows,1,arr)
      return r
    end

    #
    # getter, returns a submatrix
    #
    def [](rows : ::Range(Int32, Int32), cols : ::Range(Int32, Int32) ) : GLM::Matrix
      validate_range(rows)
      validate_range(cols)

      validate_row(rows.begin)
      validate_row(rows.end)
      validate_column(cols.begin)
      validate_column(cols.end)

      #
      # calculates the number of columns and rows
      #
      nrcols = (cols.end - cols.begin + 1).abs
      nrrows = (rows.end - rows.begin + 1).abs

      arr = Array.new(0) { Array.new(0) { Complex.new(0.0,0.0) } }
      (rows.begin..rows.end).each do |i|

        rowdata = [] of Complex
        (cols.begin..cols.end).each do |j|
          rowdata << self[i,j]
        end

        if rowdata.size() > 0
          arr << rowdata
        end

      end

      r = GLM::Matrix.new(arr)
      return r
    end

    #
    # setter, sets the matrix values for given row range and column
    #
    def []=(rows : ::Range(Int32, Int32), col : Int32, m : GLM::Matrix) : GLM::Matrix

      validate_range(rows)
      validate_row(rows.begin)
      validate_row(rows.end)
      validate_column(col)

      #
      # need to set the matrix values
      #
      (0..m.rows-1).each do |i|
        (0..m.columns-1).each do |j|

          self[rows.begin + i,col] = m[i,j]

        end
      end

      return self
    end

    #
    # setter, sets the matrix values for given row and column range
    #
    def []=(row : Int32, cols : ::Range(Int32, Int32), m : GLM::Matrix) : GLM::Matrix

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)
      validate_row(row)

      #
      # need to set the matrix values
      #
      (0..m.rows-1).each do |i|
        (0..m.columns-1).each do |j|

          self[row,cols.begin + j] = m[i,j]

        end
      end

      return self
    end

    #
    # setter, sets the matrix values for given row range and column range
    #
    def []=(rows : ::Range(Int32,Int32), cols : ::Range(Int32, Int32), m : GLM::Matrix) : GLM::Matrix
      validate_range(rows)
      validate_range(cols)
      validate_row(rows.begin)
      validate_row(rows.end)
      validate_column(cols.begin)
      validate_column(cols.end)

      #
      # need to set the matrix values
      #
      (0..m.rows-1).each do |i|
        (0..m.columns-1).each do |j|

          self[rows.begin + i,cols.begin + j] = m[i,j]

        end
      end

      return self
    end

    #
    # from an array of values
    #
    # setter, sets the matrix values for given row range and column given an array of Real
    #
    def []=(rows : ::Range(Int32, Int32), col : Int32, arr : Array(Real) ) : GLM::Matrix

      validate_range(rows)
      validate_row(rows.begin)
      validate_row(rows.end)
      validate_column(col)

      #
      # need to set the matrix values
      #
      arrindex = 0
      (rows.begin..rows.end).each do |i|
        self[i,col] = Complex.new(1.0 * arr[arrindex], 0.0)
        arrindex = arrindex + 1
      end

      return self
    end

    #
    # setter, sets the matrix values for given row range and column given an array of Complex
    #
    def []=(rows : ::Range(Int32, Int32), col : Int32, arr : Array(Complex) ) : GLM::Matrix

      validate_range(rows)
      validate_row(rows.begin)
      validate_row(rows.end)
      validate_column(col)

      #
      # need to set the matrix values
      #
      arrindex = 0
      (rows.begin..rows.end).each do |i|
        self[i,col] = arr[arrindex]
        arrindex = arrindex + 1
      end

      return self
    end

    #
    # setter, sets the matrix values for given row and column range
    #
    def []=(row : Int32, cols : ::Range(Int32, Int32), arr : Array(Real)) : GLM::Matrix

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)
      validate_row(row)

      #
      # need to set the matrix values
      #
      arrindex = 0
      (cols.begin..cols.end).each do |j|

        self[row,j] = Complex.new(arr[arrindex],0.0)
        arrindex = arrindex + 1
      end

      return self
    end

    #
    # setter, sets the matrix values for given row and column range
    #
    def []=(row : Int32, cols : ::Range(Int32, Int32), arr : Array(Complex)) : GLM::Matrix

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)
      validate_row(row)

      #
      # need to set the matrix values
      #
      arrindex = 0
      (cols.begin..cols.end).each do |j|

        self[row,j] = arr[arrindex]
        arrindex = arrindex + 1
      end

      return self
    end

    #
    # sets a matrix element at the given row and column
    # with the given real value
    #
    def []=(row : Int32, col : Int32, value : Real)

      row = negative_row(row)
      col = negative_column(col)

      validate_row(row)
      validate_column(col)

      @buffer[row_col_to_index(row, col)] = value.to_f32
    end

    #
    # sets a matrix element at the given row and column
    # with the given complex value
    #
    def []=(row : Int32, col : Int32, value : Float32)

      row = negative_row(row)
      col = negative_column(col)

      validate_row(row)
      validate_column(col)

      @buffer[row_col_to_index(row, col)] = value
    end

    private def format_value(precision : Int32, width : Int32, val : Float32) : String
      if precision == 0
        return sprintf("%g",val)
      end

      # format value with given precision
      s = sprintf("%.#{precision}f",val)
      # right align
      sval = sprintf("%#{width}s",s)
      return sval
    end

    private def format_value(precision : Int32, width : Int32, val : Float32) : String
      if precision == 0
        return val.to_s
      end

      # value is real ?
      if val.imag == 0.0
        return format_value(precision,width,val.real)
      end

      # value is imaginary ?
      if val.real == 0.0
        return format_value(precision,width,val.imag) + "i"
      end

      # format value with given precision
      # s = val.to_s + " "

      # determine plus/minus sign
      pmsign = "+"
      space  = " "

      if val.imag < 0.0
        pmsign = "-"
        val = Float32.new(val.real,-1.0 * val.imag)
      end

      s_real = format_value(precision,width,val.real)
      s_imag = format_value(precision,width,val.imag)

      s = "(" + s_real + space + pmsign + s_imag + "i)"
      # right align
      sval = sprintf("%#{width}s",s)
      return sval
    end

    #
    # prints the matrix
    #
    def print(precision : Int32 = 2, width : Int32 = 6, with_row : Bool = true)

      s = [] of String
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[0,0],self[0,1],self[0,2],self[0,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[1,0],self[1,1],self[1,2],self[1,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[2,0],self[2,1],self[2,2],self[2,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[3,0],self[3,1],self[3,2],self[3,3])

      r = s.join("\n")
      return r

    end

    #
    # returns the number of rows
    #
    def rows : Int32
      @nr_rows
    end

    #
    # returns the number of columns
    #
    def columns : Int32
      @nr_cols
    end

    #
    # returns the matrix row 'i'
    #
    def row(i : Int32) : GLM::Vector

      validate_row(i)

      #
      # start index and end index
      #
      si = row_col_to_index(i,0)
      ei = row_col_to_index(i,@nr_cols-1)

      r = @buffer[si..ei]
      v = GLM::Vector.new(r)
      return v
    end

    #
    # returns a sub vector of the matrix row 'i'
    #
    def row(i,scol,ecol : Int32) : GLM::Vector

      validate_row(i)
      validate_column(scol)
      validate_column(ecol)

      #
      # need to retrieve the row values individually
      # from scol to ecol
      r = [] of Float32
      (scol..ecol).each do |col|
        index = row_col_to_index(i,col)
        r << @buffer[index]
      end

      v = GLM::Vector.new(r)
      return v
    end

    #
    # returns a vector (either row/column)
    #
    def to_vector() : GLM::Vector

      x = [] of Float32
      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols - 1).each do |j|
          x << self[i,j]
        end
      end

      r = GLM::Vector.new(x)
      return r
    end

    #
    # applies  the operation specified by the operand
    # to all the elements in row 'i'
    # with the given real value
    #
    # returns a matrix
    #
    def row(i : Int32, value : Real, operand : String = "*") : GLM::Matrix

      validate_row(i)

      #
      # convert to complex value
      #
      val = Float32.new(1.0 * value, 0.0)

      r = self.clone

      #
      # start index and end index
      #
      si = row_col_to_index(i,0)
      ei = row_col_to_index(i,@nr_cols-1)

      #
      # go over each element
      #
      (si..ei).each do |j|
        case operand
          when "*"
            r.data[j] = @buffer[j] * val

          when "-"
            r.data[j] = @buffer[j] - val

          when "+"
            r.data[j] = @buffer[j] + val

          else
            # Crystal 0.34
        end # case
      end

      return r
    end

    #
    # applies  the operation specified by the operand
    # to all the elements in row 'i'
    # with the given complex value
    #
    # returns a matrix
    #
    def row(i : Int32, value : Float32, operand : String = "*") : GLM::Matrix

      validate_row(i)
      val = value
      r   = self.clone

      #
      # start index and end index
      #
      si = row_col_to_index(i,0)
      ei = row_col_to_index(i,@nr_cols-1)

      #
      # go over each element
      #
      (si..ei).each do |j|
        case operand
          when "*"
            r.data[j] = @buffer[j] * val

          when "-"
            r.data[j] = @buffer[j] - val

          when "+"
            r.data[j] = @buffer[j] + val

          else
            # Crystal 0.34
        end # case
      end

      return r
    end

    #
    # replaces a row 'i' with the given array
    #
    def replace_row(i : Int32, values : Array(Real)) : GLM::Matrix

      validate_row(i)

      if values.size() != @nr_cols
        report_error("the number of array elements does not match the number of matrix columns")
      end

      r = self.clone

      #
      # start index and end index
      #
      si = row_col_to_index(i,0)
      ei = row_col_to_index(i,@nr_cols-1)

      (0..@nr_cols-1).each do |j|
        r[i,j] = Float32.new(1.0 * values[j],0.0)
      end

      return r
    end

    #
    # replaces a row 'i' with the given array
    #
    def replace_row(i : Int32, values : Array(Float32)) : GLM::Matrix

      validate_row(i)

      if values.size() != @nr_cols
        report_error("the number of array elements does not match the number of matrix columns")
      end

      r = self.clone

      #
      # start index and end index
      #
      si = row_col_to_index(i,0)
      ei = row_col_to_index(i,@nr_cols-1)

      (0..@nr_cols-1).each do |j|
        r[i,j] = values[j]
      end

      return r
    end

    #
    # replaces a row 'i' with the given vector
    #
    def replace_row(i : Int32, v : GLM::Vector) : GLM::Matrix

      arr = v.to_arr
      r = replace_row(i,arr)
      return r
    end

    #
    # perform row operations
    # scale row 'i' with c1
    # scale row 'j' with c2
    # add these rows
    # and replace row 'dest' with the result
    #
    # returns a matrix
    #
    def add_rows(dest,i,j : Int32, c1,c2 : Real) : GLM::Matrix
      validate_row(dest)
      validate_row(i)
      validate_row(j)

      r  = self.clone
      r1 = self.clone
      r2 = self.clone

      c1 = c1 * 1.0
      c2 = c2 * 1.0

      #
      # multiply all the elements of row 'i' of matrix 'r1 with the value 'c1'
      #
      if c1 != 1.0
        r1 = r1.row(i,c1,"*")
      end

      #
      # multiply all the elements of row 'j' of matrix 'r2 with the value 'c2'
      #
      if c2 != 1.0
        r2 = r2.row(j,c2,"*")
      end

      #
      # now add row 'i' and row 'j' and replace row 'dest' of matrix r
      # retrieve row 'i'
      #
      r1 = r1.row(i)
      r2 = r2.row(j)
      r3 = r1 + r2

      # replace row 'dest' with vector r3
      r = r.replace_row(dest,r3)

      return r
    end

    #
    # perform row operations
    # scale row 'i' with c1
    # scale row 'j' with c2
    # subtract these rows
    # and replace row 'dest' with the result
    #
    # returns a matrix
    #
    def subtract_rows(dest,i,j : Int32, c1,c2 : Real) : GLM::Matrix
      validate_row(dest)
      validate_row(i)
      validate_row(j)

      r  = self.clone
      r1 = self.clone
      r2 = self.clone

      c1 = c1 * 1.0
      c2 = c2 * 1.0

      #
      # multiply all the elements of row 'i' of matrix 'r1 with the value 'c1'
      #
      if c1 != 1.0
        r1 = r1.row(i,c1,"*")
      end

      #
      # multiply all the elements of row 'j' of matrix 'r2 with the value 'c2'
      #
      if c2 != 1.0
        r2 = r2.row(j,c2,"*")
      end

      #
      # now add row 'i' and row 'j' and replace row 'dest' of matrix r
      # retrieve row 'i'
      #
      r1 = r1.row(i)
      r2 = r2.row(j)
      r3 = r1 - r2

      # replace row 'dest' with vector r3
      r = r.replace_row(dest,r3)

      return r
    end

    #
    # perform row operations
    # scale row 'i' with c1
    # scale row 'j' with c2
    # subtract these rows
    # and replace row 'dest' with the result
    #
    # returns a matrix
    #
    def subtract_rows(dest,i,j : Int32, c1,c2 : Float32) : GLM::Matrix
      validate_row(dest)
      validate_row(i)
      validate_row(j)

      r  = self.clone
      r1 = self.clone
      r2 = self.clone

      #
      # multiply all the elements of row 'i' of matrix 'r1 with the value 'c1'
      #
      if c1 != Float32.new(1.0,0.0)
        r1 = r1.row(i,c1,"*")
      end

      #
      # multiply all the elements of row 'j' of matrix 'r2 with the value 'c2'
      #
      if c2 != Float32.new(1.0,0.0)
        r2 = r2.row(j,c2,"*")
      end

      #
      # now add row 'i' and row 'j' and replace row 'dest' of matrix r
      # retrieve row 'i'
      #
      r1 = r1.row(i)
      r2 = r2.row(j)
      r3 = r1 - r2

      # replace row 'dest' with vector r3
      r = r.replace_row(dest,r3)

      return r
    end

    #
    # returns the matrix column 'i' as a vector
    #
    def column(i : Int32) : GLM::Vector4

      validate_column(i)

      #
      # need to retrieve the column values individually
      #
      r = [] of Float32
      (0..@nr_rows-1).each do |row|
        index = row_col_to_index(row,i)
        r << @buffer[index]
      end

      v = GLM::Vector4.new(r)
      return v
    end

    #
    # returns a sub vector of the matrix column 'i'
    #
    def column(i,srow,erow : Int32 ) : GLM::Vector4

      validate_column(i)
      validate_row(srow)
      validate_row(erow)

      #
      # need to retrieve the column values individually
      # from srow to erow
      #
      r = [] of Float32
      (srow..erow).each do |row|
        index = row_col_to_index(row,i)
        r << @buffer[index]
      end

      v = GLM::Vector.new(r)
      return v
    end

    #
    # returns the diagonal of a matrix as a new matrix
    # Note: only for square matrices
    #
    def diagonal() : GLM::Matrix

      # check matrix is square
      if @nr_rows != @nr_cols
        matrix_notsquare()
      end

      arr = GLM::Matrix.new()
      (0..@nr_rows - 1).each do |r|
        (0..@nr_cols - 1).each do |c|

          if r == c
            arr[r,r] = self[r,r]
          end
        end
      end

      return arr
    end

    #
    # returns the diagonal element of a matrix as an array
    # Note: only for square matrices
    #
    def diagonal_to_a() : Array(Float32)

      empty?()
      if square?() == false
        matrix_notsquare()
      end

      arr = [] of Float32
      (0..@nr_rows - 1).each do |r|
        (0..@nr_cols - 1).each do |c|
          if r == c
            arr << self[r,r].real
          end
        end
      end

      return arr
    end

    #
    # given an array of Float32
    # returns a diagonal matrix
    # useful when doing Eigen value decomposition
    #
    def self.diagonal(a : Array(Float32)) : GLM::Matrix

      r1 = a.size()
      c1 = r1

      r = GLM::Matrix.new(r1,c1)
      (0..r1-1).each do |i|
        r[i,i] = a[i]
      end

      return r
    end

    #
    # returns a matrix with the elements of v on the main diagonal
    #
    def self.diagonal(v : GLM::Vector) : GLM::Matrix

      n = v.size()
      if n <= 0
        report_error("empty vector given")
      end

      r = GLM::Matrix.new(n,n)
      (0..n-1).each do |i|
        r[i,i] = v[i]
      end

      return r
    end

    #
    # returns a matrix with the elements of v on the sub diagonal
    #
    def tridiagonal(v : GLM::Vector) : GLM::Matrix

      n = @nr_rows

      nv = v.size()
      if nv <= 0
        report_error("empty vector given")
      end

      # vector v should have n - 1 elements
      if nv != n - 1
        report_error("the size of the vector is #{nv} but should be #{n-1}")
      end

      r = self.clone()
      (0..nv-1).each do |i|
        r[i+1,i] = v[i]
        r[i,i+1] = v[i]
      end

      return r
    end

    #
    # returns a tridiagonal matrix given a diagonal and sub diagonal vector
    #
    def self.tridiagonal(diag_v, sub_diag_v : GLM::Vector) : GLM::Matrix

      r = GLM::Matrix.diagonal(diag_v)

      n   = diag_v.size()
      #
      # the method tred2 compute the subdiagonal
      # where the first element is always 0.0
      # we need to take a vector slice
      # and skip the first element
      #
      sub = sub_diag_v[1..n-1]

      r     = r.tridiagonal(sub)
      return r
    end

    #
    # returns the diagonal elements of a matrix as a column vector
    #
    def self.diagonal(a : GLM::Matrix) : GLM::Vector

      a.empty?()
      if a.square?() == false
        matrix_notsquare()
      end

      arr = [] of Float32
      (0..a.rows-1).each do |i|
        arr << a[i,i]
      end

      return GLM::Vector.new(arr)
    end

    #
    # returns a matrix with the elements of vector v on the diagonal given by k
    # k > 0 returns the diagonal entries above the main diagonal
    # k < 0 returns the diagonal entries below the main diagonal
    #
    def self.diagonal(v : GLM::Vector, k : Int32) : GLM::Matrix

      n = v.size()
      if n <= 0
        report_error("empty vector given")
      end

      #
      # need to make room for the super diagonal as the 'k' offset of the main diagonal
      # Note: the k.abs as k can be negative
      #
      n = n + k.abs

      r = GLM::Matrix.new(n,n)
      (0..v.size()-1).each do |i|
        if k > 0
          r[i,i+k] = v[i]
        end

        if k == 0
          r[i,i] = v[i]
        end

        if k < 0
          r[i+k.abs,i] = v[i]
        end

      end

      return r
    end

    #
    # returns a vector with the elements of matrix a on the diagonal given by k
    # k > 0 returns the diagonal entries above the main diagonal
    # k < 0 returns the diagonal entries below the main diagonal
    #
    def self.diagonal(a : GLM::Matrix, k : Int32) : GLM::Vector

      nr_rows = a.rows
      nr_cols = a.columns
      arr     = [] of Float32

      if k == 0
        (0..nr_rows-1).each do |i|
          arr << a[i,i]
        end
      end

      if k > 0
        (0..nr_rows-1-k).each do |i|
          arr << a[i,i+k]
        end
      end

      # Note the k.abs
      if k < 0
        (0..nr_rows-1-k.abs).each do |i|
          arr << a[i+k.abs,i]
        end
      end

      return GLM::Vector.new(arr)
    end

    #
    # returns the transpose of a matrix as a new matrix
    #
    def transpose() : GLM::Matrix

      m = GLM::Matrix.new(@nr_cols,@nr_rows)
      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols - 1).each do |j|
          m[j,i] = self[i,j]
        end
      end

      return m
    end

    #
    # returns the transpose of a matrix as a new matrix
    # shorter method name
    #
    def t() : GLM::Matrix

      m = GLM::Matrix.new(@nr_cols,@nr_rows)
      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols - 1).each do |j|
          m[j,i] = self[i,j]
        end
      end
      return m
    end

    #
    # returns the complex conjugate or the Hermitian of a matrix as a new matrix
    #
    def h() : GLM::Matrix

      m = GLM::Matrix.new(@nr_cols,@nr_rows)
      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols - 1).each do |j|
          m[j,i] = self[i,j].conj()
        end
      end

      return m
    end

    #
    # returns the identity matrix for a given n
    #
    def self.eye() : GLM::Matrix

      n = 4
      arr = GLM::Matrix.new()
      (0..n - 1).each do |i|
        (0..n - 1).each do |j|
          if i == j
            arr[i,j] = 1f32
          end
        end
      end

      return arr
    end

    #
    # returns a square matrix filled with 0
    #
    def self.zero(n : Int32) : GLM::Matrix
      arr = GLM::Matrix.new(n,n)
      return arr
    end

    #
    # returns a matrix with the given matrices as diagonal blocks
    #
    def self.diag(m1, m2 : GLM::Matrix) : GLM::Matrix
      r = m1.rows + m2.rows
      c = m1.columns + m2.columns

      m = GLM::Matrix.new(r,c)

      (0..m1.rows-1).each do |i|
        (0..m1.columns-1).each do |j|
          m[i,j] = m1[i,j]
        end
      end

      (0..m2.rows-1).each do |i|
        (0..m2.columns-1).each do |j|
          m[m1.rows+i,m1.columns+j] = m2[i,j]
        end
      end

      return m
    end

    #
    # returns a matrix filled with 0
    # Note: sets the object values to 0
    #
    def zero() : GLM::Matrix
      return GLM::Matrix.new()
    end

    #
    # returns a matrix filled with 0
    # Note: class method
    #
    def self.zero(rows, cols : Int32) : GLM::Matrix
      arr = GLM::Matrix.new(rows,cols)
      return arr
    end

    def self.zero() : GLM::Matrix
      arr = GLM::Matrix.new()
      return arr
    end

    #
    # returns the clone of a matrix
    #
    def clone() : GLM::Matrix
      arr = GLM::Matrix.new()
      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols - 1).each do |j|
          arr[i,j] = self[i,j]
        end
      end

      return arr
    end

    #
    # returns true when the matrix is upper triangular
    # i.e non zero entries on the diagonal and above
    # zero's below the diagonal
    #
    def upper_triangular?(tolerance : Float32 = GLM::EPSILON) : Bool

      empty?()
      if square?() == false
        matrix_notsquare()
      end

      (0..@nr_rows - 1).each do |i|

        #
        # test Matrix elements below the diagonal
        #
        (0.. i - 1).each do |j|

          #
          # expected value should be 0.0
          #
          flag = self[i,j].real.be_close(0.0,tolerance)
          if flag == false
            return false
          end
        end
      end

      return true
    end

    #
    # returns true when the matrix is square
    #
    def square?() : Bool
      @nr_rows == @nr_cols
    end

    #
    # returns true when the matrix is symmetric (A = AT)
    #
    def symmetric?() : Bool

      empty?()
      if square? == false
        return false
      end

      (0..@nr_rows-1).each do |i|
        (0..@nr_cols-1).each do |j|
          a = self[i,j]
          b = self[j,i]

          if a != b
            return false
          end
        end
      end

      return true
    end

    #
    # returns true when the matrix is hermitian (A = AH)
    #
    def hermitian?(show : Bool = false) : Bool
      empty?()
      if square? == false
        return false
      end

      (0..@nr_rows-1).each do |i|
        (0..@nr_cols-1).each do |j|
          a = self[i,j]
          b = self[j,i]

          if a != b.conj()
            return false
          end
        end
      end

      return true
    end

    #
    # returns true when the matrix is unitary (A * AH = AH * A = I)
    #
    def unitary?(show : Bool = false) : Bool
      empty?()
      if square? == false
        return false
      end

      m  = @nr_rows
      i  = GLM::Matrix.eye(m)
      m1 = self * self.h()
      m2 = self.h() * self

      flag1 = m1.compare?(m2,show)
      flag2 = m1.compare?(i,show)
      flag3 = m2.compare?(i,show)
      return flag1 && flag2 && flag3
    end

    #
    # returns true when the matrix is orthogonal (A * AT = AT * A = I)
    #
    def orthogonal?(show : Bool = false) : Bool
      empty?()
      if square?() == false
        matrix_notsquare()
      end

      m  = @nr_rows
      i  = GLM::Matrix.eye(m)
      m1 = self * self.t()
      m2 = self.t() * self

      flag1 = m1.compare?(m2,show,0.00001)
      flag2 = m1.compare?(i,show,0.00001)
      flag3 = m2.compare?(i,show,0.00001)
      return flag1 && flag2 && flag3
    end

    #
    # returns true when the matrix is orthogonal (A * AT = AT * A = I)
    # and the individual column vectors have length 1
    #
    def orthonormal?(show : Bool = false) : Bool
      empty?()
      if square?() == false
        matrix_notsquare()
      end

      # compute length of each column vector
      (0..@nr_cols-1).each do |j|
        v = column(j)
        len = v.length()
        flag = len.be_close(1.0,0.0000001)
        if flag == false
          return false
        end
      end


      m  = @nr_rows
      i  = GLM::Matrix.eye(m)
      m1 = self * self.t()
      m2 = self.t() * self

      flag1 = m1.compare?(m2,show,0.00001)
      flag2 = m1.compare?(i,show,0.00001)
      flag3 = m2.compare?(i,show,0.00001)

      return flag1 && flag2 && flag3
    end


    #
    # returns true when the matrix is normal (A * AH = AH * A)
    #
    def normal?(show : Bool = false) : Bool
      empty?()
      if square? == false
        return false
      end

      m  = @nr_rows
      m1 = self * self.h()
      m2 = self.h() * self

      flag1 = m1.compare?(m2,show)
      flag2 = m2.compare?(m1,show)
      return flag1 && flag2
    end

    #
    # returns true when the matrix is tridiagonal
    #
    def tridiagonal?() : Bool
      empty?()

      if square?() == false
        matrix_notsquare()
      end

      n = @nr_rows
      if n <= 2
        return false
      end

      #
      # for i != j
      # all entries below the main and lower sub diagonal should be 0
      # and all entries above the main and upper sub diagonal should be 0
      #

      if n == 3
        if self[2,0] == 0 && self[0,2] == 0
          return true
        else
          return false
        end
      end

      flag1 = false
      flag2 = false

      (0 .. @nr_rows - 1).each do |i|
        (0 .. @nr_cols - 1).each do |j|
          val = self[i,j]

          if i != j

            # triangle below diagonal and sub diagonal should contain 0
            if i > j && j < @nr_cols - 2
              if val == 0.0
                flag1 = true
              else
                flag1 = false
              end
            end

            # triangle above diagonal and sub diagonal should contain 0
            if j > i && i < @nr_rows - 2
              if val == 0.0
                flag2 = true
              else
                flag2 = false
              end
            end
          end
        end
      end

      # for tridiagonal flag1 and flag2 should be true
      if flag1 && flag2
        return true
      end
      return false
    end

    #
    # returns the trace of the matrix
    #
    def trace() : Float32
      if square? == false
        matrix_notsquare()
      end

      sum = 0.0
      (0..@nr_rows-1).each do |i|
        (0..@nr_cols-1).each do |j|
          if i == j
            sum = sum + self[i,i].real
          end

        end
      end

      return sum
    end

    #
    # compares matrix other to self
    # returns true when equal
    # otherwise false
    #
    def ==(other : GLM::Matrix) : Bool

      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols -1).each do |j|

          flag = self[i,j].real.be_close(other[i,j].real,GLM::EPSILON)
          if flag == false
            return false
          end

        end
      end

      return true
    end

    #
    # compares matrix self to nested array
    # returns true when equal
    # otherwise false
    #
    def ==(other : Array(Array(Real)) ) : Bool

      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols -1).each do |j|

          flag = self[i,j].real.be_close(other[i,j].real,GLM::EPSILON)
          if flag == false
            return false
          end

        end
      end

      return true
    end

    #
    # adds matrix other to self
    #
    def +(other : GLM::Matrix) : GLM::Matrix
      r = GLM::Matrix.new()

      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols -1).each do |j|
          r[i,j] = self[i,j] + other[i,j]
        end
      end

      return r
    end

    #
    # subtracts matrix other from self
    #
    def -(other : GLM::Matrix) : GLM::Matrix
      r = GLM::Matrix.new()

      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols -1).each do |j|
          r[i,j] = self[i,j] - 1.0 * other[i,j]
        end
      end

      return r
    end

    #
    # multiplies matrix other with self
    #
    def *(other : GLM::Matrix) : GLM::Matrix

      r1 = 4
      c1 = 4

      r2 = 4
      c2 = 4

      r = GLM::Matrix.new

      for i = 0, i < r1, i = i + 1 do
        for j = 0, j < c2, j = j + 1 do
          for k = 0, k < c1, k = k + 1 do
            r[i,j] = r[i,j] + self[i,k] * other[k,j]
          end
        end
      end

      return r
    end

    #
    # multiplies matrix self with vector other
    # should return a vector
    #
    def *(other : GLM::Vector) : GLM::Vector

      if @nr_cols != other.size()
        report_error("the number of columns of the matrix should equal the dimension of the vector")
      end

      r = GLM::Vector.new(@nr_rows)
      for i = 0, i < @nr_rows, i = i + 1 do

        # for each row
        # we multiply the matrix elements r[row,j] * v[j]
        # and sum them
        # and set v[j] = sum
        #

        sum = Float32.new(0.0,0.0)
        for j = 0, j < @nr_cols, j = j + 1 do
          val = self[i,j] * other[j]
          sum = sum + val
        end

        r[i] = sum
      end

      return r
    end

    #
    # divides matrix self with other
    # square matrices only
    #
    def /(other : GLM::Matrix) : GLM::Matrix

      empty?()
      if square?() == false
        matrix_notsquare()
      end

      other.empty?()
      if other.square?() == false
        matrix_notsquare()
      end

      r1 = @nr_rows
      c1 = @nr_cols

      r2 = other.nr_rows
      c2 = other.nr_cols

      if c1 != r2
        report_error("the number of columns of the left matrix should equal the number of rows of the right matrix")
      end

      r = GLM::Matrix.new(r1,c2)

      # new code 11-04-2019
      for i = 0, i < r1, i = i + 1 do
        for j = 0, j < c1, j = j + 1 do
          if other[i,j].zero?() # == 0.0
            division_byzero(true)
          end
          r[i,j] = r[i,j] + self[i,j].div(other[i,j])
        end
      end

      return r
    end

    #
    # divides matrix self with complex number
    # square matrices only
    #
    def /(other : Float32) : GLM::Matrix

      empty?()
      if square?() == false
        matrix_notsquare()
      end

      n = @nr_rows
      r = GLM::Matrix.new(n,n)
      for i = 0, i < n, i = i + 1 do
        for j = 0, j < n, j = j + 1 do

          if other.zero?()
            division_byzero(true)
          end
          r[i,j] = r[i,j] + self[i,j].div(other)
        end
      end

      return r
    end

    #
    # divides matrix self with real number
    # square matrices only
    #
    def /(other : Real) : GLM::Matrix

      empty?()
      if square?() == false
        matrix_notsquare()
      end

      n = @nr_rows
      r = GLM::Matrix.new(n,n)

      val = 1.0 * other

      for i = 0, i < n, i = i + 1 do
        for j = 0, j < n, j = j + 1 do

          if val == 0.0
            division_byzero()
          end
          r[i,j] = r[i,j] + self[i,j]/val
        end
      end

      return r
    end

    #
    # returns true when all the columns have zeros
    #
    def zeros?(i : Int32) : Bool
      validate_row(i)

      flag = true
      (0..@nr_cols -1).each do |j|
        val = self[i,j]
        if val.zero?() == false # != 0.0
          flag = false
        end
      end

      return flag
    end

    #
    # reports a fatal error when the matrix is empty
    #
    def empty?()
      if @nr_rows == 0
        report_error("given matrix is empty")
      end

      if @nr_cols == 0
        report_error("given matrix is empty")
      end
    end

    #
    # returns the determinant of the matrix
    #
    def determinant() : Float32
      empty?()

      if square?() == false
        matrix_notsquare()
      end

      # determinant of a 1x1 matrix is just self[0,0]
      if @nr_rows == 1
        return self[0,0].real
      end

      if @nr_rows == 2
        val = self[0,0] * self[1,1] - self[0,1] * self[1,0]
        return val.real
      end

      sum = Float32.new(0.0,0.0) #0.0
      #
      # loop over all the column elements from the first row
      #
      (0..@nr_cols - 1).each do |j|

        min = minor(0,j)

        #
        # need to take the sign into account
        #
        sign = (-1.0)**j
        x    = sign * self[0,j] * min.determinant()
        sum  = sum + x
      end

      return sum.real
    end

    #
    # returns the minor matrix given a row 'i' and column 'j'
    #
    def minor(i,j : Int32) : GLM::Matrix

      empty?()

      if @nr_rows < 2
        report_error("cannot adjoint matrix with 1 row")
      end

      if @nr_cols < 2
        report_error("cannot adjoint matrix with 1 column")
      end

      if i < 0 || i >= @nr_rows
        report_error("cannot remove row #{i}")
      end

      if j < 0 || j >= @nr_cols
        report_error("cannot remove column #{j}")
      end

      r = Array.new(0) { Array.new(0) { Float32.new(0.0,0.0) }}
      (0..@nr_rows - 1).each do |row|

        if row != i
          #
          # copy an entire row from arr (skipping column j)
          # to r
          #
          temp = [] of Float32
          do_insert = false
          (0..@nr_cols - 1).each do |col|
            if col != j
              temp << self[row,col]
              do_insert = true
            end
          end

          if do_insert
            r << temp
          end

        end
      end

      return GLM::Matrix.new(r)
    end

    #
    # returns the adjoint of the matrix
    #
    def adjoint() : GLM::Matrix

      empty?()

      if @nr_rows <= 1
        report_error("cannot adjoint matrix with 1 row or less")
      end

      if @nr_cols <= 1
        report_error("cannot adjoint matrix with 1 column or less")
      end

      r = GLM::Matrix.new()
      #
      # we need to compute the determinants of all the minor matrices of the matrix
      #
      (0..@nr_rows-1).each do |row|
        (0..@nr_cols-1).each do |col|

          temp = self.minor(row,col)
          det  = temp.determinant()

          #
          # need to multiply det by the sign -1 or +1
          #
          sign = (-1.0)**(row + col)
          r[row,col] = sign * det
        end
      end

      #
      # now transpose matrix 'r' to get the adjoint of the matrix
      #
      rt = r.transpose()
      return rt

    end

    #
    # returns the inverse of the matrix
    #
    def inverse() : GLM::Matrix

      empty?()

      if square?() == false
        matrix_notsquare()
      end

      det = determinant()
      if det == 0.0
        matrix_singular()
      end

      adj = adjoint()

      #
      # need to divide each matrix element of the adjoint matrix
      # by the determinant
      #
      (0..@nr_rows-1).each do |row|
        (0..@nr_cols-1).each do |col|
          adj[row,col] = adj[row,col]/det
        end
      end

      return adj
    end

    #
    # returns the one-, two- or Frobenius norm of a matrix
    #
    def norm(type : String = "Frobenius") : Float32

      sum = Float32.new(0.0,0.0)
      r   = Float32.new(0.0,0.0)

      case type

        # maximum column sum
        when "one"

          sum_column = [] of Float32
          (0..columns-1).each do |j|

            sum = Float32.new(0.0,0.0)

            #
            # get column vector
            #
            cv = column(j)
            (0..cv.size()-1).each do |i|
              sum = sum + cv[i]
            end

            sum_column << sum
          end

          r = max(sum_column)

        # maximum row sum
        when "two"

          sum_row = [] of Float32
          (0..rows-1).each do |j|

            sum = Float32.new(0.0,0.0)
            #
            # get row vector
            #
            rv = row(j)
            (0..rv.size()-1).each do |i|
              sum = sum + rv[i]
            end

            sum_row << sum
          end

          r = max(sum_row)

        when "Frobenius"

          for i = 0, i < @nr_rows, i = i + 1 do
            for j = 0, j < @nr_cols, j = j + 1 do
              val = self[i,j]
              sum = sum + val * val
            end
          end
          r = sum.sqrt

        else

          report_error("unknown norm type '#{type}', valid types are 'one' and 'Frobenius'")

      end # case

      return r
    end

    #
    # returns the rank of the matrix
    #
    def rank() : Int32

      #
      # put the matrix first
      # in reduced row echolon form
      #
      reduced = rref()

      # count the number of non zero rows
      nr_rows = reduced.rows()
      nr_cols = reduced.columns()

      count = 0
      for i = 0, i < nr_rows, i = i + 1 do

        #
        # is the row entirely filled with zero's
        #
        found = reduced.zeros?(i)

        #
        # we have a row with at least one non zero column
        #
        if found == false
          count = count + 1
        end
      end

      return count
    end

    #
    # returns true when the matrix is full rank
    # ie rank() == min(@nr_rows,@nr_cols)
    #
    def fullrank?() : Bool
      r   = rank()
      min = min(@nr_rows,@nr_cols)
      if r == min
        return true
      end

      return false
    end

    #
    # converts a matrix into a nested array of Float32
    #
    def to_arr() : Array(Array(Float32))
      arr = Array.new(@nr_rows) { Array.new(@nr_cols) {0.0}}

      (0..@nr_rows-1).each do |i|
        (0..@nr_cols-1).each do |j|
          arr[i][j] = self[i,j].real
        end
      end

      return arr
    end

    #
    # swaps row i with j
    #
    def swap_rows(i : Int32, j : Int32) : GLM::Matrix
      validate_row(i)
      validate_column(j)

      arr    = to_arr()
      temp   = arr[i]
      arr[i] = arr[j]
      arr[j] = temp

      r = GLM::Matrix.new(arr)
      return r
    end

    #
    # returns the reduced row echolon form of the matrix
    #
    def rref() : GLM::Matrix

      gj = GLM::GaussJordan.new(self)
      r  = gj.eliminate(false)
      return r
    end

    #
    # returns the QR decomposition of the matrix
    #
    def qr() : {GLM::Matrix,GLM::Matrix}
      a   = self.clone()
      qr  = GLM::QR.new(a)
      q,r = qr.compute()
      return {q,r}
    end

    #
    # returns the upper triangular part of the matrix
    #
    def triupper() : GLM::Matrix
      r = GLM::Matrix.new()

      (0..r.nr_rows-1).each do |i|
        (0..r.nr_cols-1).each do |j|
          if j >= i
            r[i,j] = self[i,j]
          end
        end
      end

      return r
    end

    #
    # returns the lower triangular part of the matrix
    #
    def trilower() : GLM::Matrix
      r = GLM::Matrix.new()

      (0..r.nr_rows-1).each do |i|
        (0..r.nr_cols-1).each do |j|
          if j < i
            r[i,j] = self[i,j]
          end
        end
      end

      return r
    end

    #
    # deletes the row 'i'
    # and returns the new modified matrix
    #
    def delete_at(i : Int32) : GLM::Matrix
      validate_row(i)

      #
      # we are copying the matrix row by row
      # skipping row 'i'
      #

      # test we don't create a matrix with zero rows
      test_rows = @nr_rows - 1
      if test_rows == 0
        return self
      end

      r = GLM::Matrix.new(@nr_rows - 1,@nr_cols)

      new_row_index = 0
      (0..@nr_rows-1).each do |k|

        if k != i

          (0..@nr_cols-1).each do |j|
            r[new_row_index,j] = self[k,j]
          end

          new_row_index = new_row_index + 1
        end
      end

      return r
    end


    #
    # compare both matrices within the tolerance of epsilon
    #
    def compare?(other : GLM::Matrix, show : Bool = false, eps : Float32 = 1.0e-5) : Bool

      self.empty?()
      other.empty?()

      if other.rows != self.rows || other.columns != self.columns
        return false
      end

      (0..other.rows-1).each do |i|
        (0..other.columns-1).each do |j|

          diff = (other[i,j] - self[i,j]).abs
          if diff > eps
            if show
              puts "comparing #{other[i,j]} and #{self[i,j]} failed at (#{i},#{j}), difference found of #{diff}"
            end
            return false
          end
        end
      end

      return true
    end

    #
    # normalize each column vector of the matrix
    #
    def normalize() : GLM::Matrix

      m = self
      erow = @nr_rows - 1

      (0..@nr_cols-1).each do |j|
        val = column(j).norm()

        #if val == 0
        if val.zero?()
          division_byzero(true)
        end

        #m[0..erow,j] = (1.0/val) * m[0..erow,j]

        # complex division
        (0..erow).each do |k|
          m[k,j] = m[k,j].div(val)
        end
      end

      return m
    end

    #
    # returns a matrix with random values
    #
    def self.rand(rows, columns : Int32, min_val : Real = 0, max_val : Real = 1) : GLM::Matrix

      if min_val > max_val
        swap_val = max_val
        min_val  = max_val
        max_val  = swap_val
      end

      m = GLM::Matrix.new(rows,columns)

      val_range = ::Range.new(min_val,max_val)

      (0..rows-1).each do |i|
        (0..columns-1).each do |j|
          #
          # Random.new.rand computes a random value in range 'val_range'
          #
          m[i,j] = Random.new.rand(val_range)
        end
      end

      return m
    end

  end # Matrix

  # fov in degrees
  def self.perspective(fov : Float32, aspect : Float32, near : Float32, far : Float32) : GLM::Matrix
    #
    # aspect ratio is 0 or the near plane equals the far plane
    #
    if aspect == 0
      report_error("aspect ratio is 0")
    end

    if near == far
      report_error("the near and far plane are equal")
    end

    rad             = GLM.radians(fov)
    tan_half_fov    = Math.tan(rad/2.0)
    frustrum_length = far - near

    m = Matrix.zero
    m[0, 0] = 1.0f32 / (aspect * tan_half_fov).to_f32
    m[1, 1] = 1.0f32 / tan_half_fov.to_f32
    m[2, 2] = -(far + near).to_f32 / (frustrum_length).to_f32
    m[3, 3] = 0.0f32

    #m[2, 3] = -(2.0f32 * far * near) / (frustrum_length).to_f32
    #m[3, 2] = -1.0f32

    #
    # in the GLM documentation the last 2 lines just above this line
    # are transposed
    #
    m[3, 2] = -(2.0f32 * far * near) / (frustrum_length).to_f32
    m[2, 3] = -1.0f32
    m
  end

  def self.orthographic(left : Float32, right : Float32, bottom : Float32, top : Float32, near : Float32,  far : Float32)
    m = Matrix.zero
    m[0, 0] = 2 / (right - left)
    m[1, 1] = 2 / (top - bottom)
    m[2, 2] = -2 / (far - near)
    m[3, 3] = 1.0

    m[0, 3] = - (right + left)/(right - left)
    m[1, 3] = - (top + bottom)/(top - bottom)
    m[2, 3] = - (far + near)/(far - near)
  end

  #
  def self.translate(other : GLM::Matrix, vector : GLM::Vector3) : GLM::Matrix
    result       = Matrix.eye
    result[0, 3] = vector.x
    result[1, 3] = vector.y
    result[2, 3] = vector.z
    r = other * result
    return r
  end

  # returns a translation matrix
  def self.translate(vector : GLM::Vector3) : GLM::Matrix
    r       = Matrix.eye
    r[0, 3] = vector.x
    r[1, 3] = vector.y
    r[2, 3] = vector.z
    return r
  end

  # returns a scaling matrix
  def self.scale(vector : GLM::Vector3) : GLM::Matrix
    r       = Matrix.eye
    r[0, 0] = vector.x
    r[1, 1] = vector.y
    r[2, 2] = vector.z
    return r
  end

  def self.rotate(vector : Vector3) : GLM::Matrix
    rx       = Matrix.eye()
    ry       = Matrix.eye()
    rz       = Matrix.eye()

    xrad     = self.radians(vector.x)
    yrad     = self.radians(vector.y)
    zrad     = self.radians(vector.z)

    rx[1, 1] =  Math.cos(xrad)
    rx[2, 2] =  Math.cos(xrad)
    rx[1, 2] = -Math.sin(xrad)
    rx[2, 1] =  Math.sin(xrad)

    ry[0, 0] =  Math.cos(yrad)
    ry[2, 2] =  Math.cos(yrad)
    ry[0, 2] =  Math.sin(yrad)
    ry[2, 0] = -Math.sin(yrad)

    rz[0, 0] =  Math.cos(zrad)
    rz[1, 1] =  Math.cos(zrad)
    rz[0, 1] = -Math.sin(zrad)
    rz[1, 0] =  Math.sin(zrad)

    r = rx * ry * rz
    return r
  end

  def self.look_at(eye : Vector3, center : Vector3, up : Vector3)
    f = (center - eye).normalize
    s = f.cross(up).normalize
    u = s.cross(f)

    m = Matrix.eye()
    m[0, 0] = s.x
    m[0, 1] = s.y
    m[0, 2] = s.z
    m[1, 0] = u.x
    m[1, 1] = u.y
    m[1, 2] = u.z
    m[2, 0] = -f.x
    m[2, 1] = -f.y
    m[2, 2] = -f.z
    m[0, 3] = -s.dot(eye)
    m[1, 3] = -u.dot(eye)
    m[2, 3] = f.dot(eye)
    m
  end


  def model_matrix(position : GLM::Vector3, rotation : GLM::Vector3, scale : GLM::Vector3) : GLM::Matrix

    trans    = GLM.translate(position)
    rotation = GLM.rotation(rot)
    scale    = GLM.scale(scale)

    r = trans * rotation * scale
    return r
  end

end

#
# operator Int32 * GLM::Matrix
#
struct Int32

  # multiplies matrix other with a Int32
  def *(other : GLM::Matrix) : GLM::Matrix

    r1 = other.nr_rows
    c1 = other.nr_cols

    r = GLM::Matrix.new(r1,c1)

    for i = 0, i < r1, i = i + 1 do
      for j = 0, j < c1, j = j + 1 do
        r[i,j] = self * other[i,j]
      end
    end

    return r
  end
end

#
# operator Float32 * GLM::Matrix
#
struct Float32

  # multiplies matrix other with a Float32
  def *(other : GLM::Matrix) : GLM::Matrix

    r1 = other.nr_rows
    c1 = other.nr_cols

    r = GLM::Matrix.new(r1,c1)

    for i = 0, i < r1, i = i + 1 do
      for j = 0, j < c1, j = j + 1 do
        r[i,j] = self * other[i,j]
      end
    end

    return r
  end

  #
  # compare actual value (self) with expected value
  #
  def be_close(expected_value : Float32, delta : Float32) : Bool
    actual_value = self
    (actual_value - expected_value).abs <= delta
  end

end
