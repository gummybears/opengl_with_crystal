#
# matrix.cr
#
# Quick and dirty hack of existing code
# removed all LAPACK methods
#
require "./errors.cr"
require "./array.cr"
require "./for_macro.cr"
require "./aliastype.cr"
require "./angle.cr"


module ASY
  enum Storage
    ROWMAJOR = 0
    COLMAJOR = 1
  end

  class Matrix
    getter   nr_rows : Int32
    getter   nr_cols : Int32
    property data    : Array(Float32)
    property status  : Int32 = 0

    property storage : ASY::Storage = ASY::Storage::ROWMAJOR

    #
    # the default Matrix is a matrix with 2 rows and 2 columns
    #
    def initialize()
      @nr_rows = 2
      @nr_cols = 2

      @data = Array.new(nr_rows*nr_cols) { 0.0f32 }
    end

    # computes the offset into the internal 1-dimensional array 'data'
    private def compute_index(row : Int32, col : Int32) : Int32

      i = 0

      case @storage
        when ASY::Storage::ROWMAJOR
          i = row * @nr_cols + col

        when ASY::Storage::COLMAJOR
          report_error("not implemented")

        else
          # Crystal 0.34
      end # case

      return i
    end

    #
    # given a row and column
    # computes the offset in the array '@data'
    # in row major order (slow)
    #
    def row_col_to_index(row : Int32, col : Int32) : Int32

      index = compute_index(row,col)
      if index >= 0 && index < @data.size
        return index
      end
      report_error("invalid indices for matrix[#{row},#{col}]")
    end

    #
    # initializes Matrix with zero's given the number of row and columns
    #
    def initialize(nr_rows : Int32, nr_cols : Int32)
      @nr_rows = nr_rows
      @nr_cols = nr_cols

      if @nr_rows < 0 && @nr_cols < 0
        report_error("cannot create a matrix with negative sizes")
      end

      if @nr_rows < 0
        report_error("cannot create a matrix with negative sizes")
      end

      if @nr_cols < 0
        report_error("cannot create a matrix with negative sizes")
      end

      @data = Array.new(nr_rows*nr_cols) { 0.0f32 }
    end

    #
    # initializes Matrix from a nested array of Real
    #
    def initialize(arr : Array(Array(Real)) )
      @nr_rows = arr.size()
      @nr_cols = arr[0].size()

      @data = Array.new(nr_rows*nr_cols) { 0.0f32 }

      (0..@nr_rows - 1).each do |r|
        (0..@nr_cols - 1).each do |c|

          index    = r * @nr_cols + c
          real_val = 1.0 * arr[r][c]
          @data[index] = 1.0f32 * real_val

        end
      end
    end

    #
    # initializes Matrix from a nested array of Float32
    #
    def initialize(arr : Array(Array(Float32)) )
      @nr_rows = arr.size()
      @nr_cols = arr[0].size()

      @data = Array.new(nr_rows*nr_cols) { 0.0f32 }

      (0..@nr_rows - 1).each do |r|
        (0..@nr_cols - 1).each do |c|

          index = r * @nr_cols + c
          @data[index] = arr[r][c]

        end
      end
    end

    # old code #
    # old code # initializes a Matrix given the number of rows/columns and data array of Real
    # old code #
    # old code def initialize(nr_rows : Int32, nr_cols : Int32, data : Array(Real) )
    # old code   @nr_rows = nr_rows
    # old code   @nr_cols = nr_cols
    # old code   @data    = to_Float32(data)
    # old code end
    # old code
    # old code #
    # old code # initializes a Matrix given the number of rows/columns and data array of Float32
    # old code #
    # old code def initialize(nr_rows : Int32, nr_cols : Int32, data : Array(Float32) )
    # old code   @nr_rows = nr_rows
    # old code   @nr_cols = nr_cols
    # old code   @data    = data
    # old code end

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

      r = @data[row_col_to_index(row, col)]
      return r
    end

    #
    # getter, returns a row matrix (1 x nr columns)
    #
    def [](row : Int32, cols : ::Range(Int32, Int32) ) : ASY::Matrix

      validate_row(row)
      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)

      # calculate the number of columns
      nrcols = (cols.end - cols.begin + 1).abs
      r      = ASY::Matrix.new(1,nrcols)

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
    def [](rows : ::Range(Int32, Int32), col : Int32) : ASY::Matrix

      validate_range(rows)
      validate_row(rows.begin)
      validate_row(rows.end)
      validate_column(col)

      # calculate the number of rows
      nrrows = (rows.end - rows.begin + 1).abs

      #
      # need to retrieve the column values individually
      #
      arr = [] of Float32
      (rows.begin..rows.end).each do |i|
        index = row_col_to_index(i,col)
        arr << @data[index]
      end

      r = ASY::Matrix.new(nrrows,1,arr)
      return r
    end

    #
    # getter, returns a submatrix
    #
    def [](rows : ::Range(Int32, Int32), cols : ::Range(Int32, Int32) ) : ASY::Matrix
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

      arr = Array.new(0) { Array.new(0) { Float32.new(0.0,0.0) } }
      (rows.begin..rows.end).each do |i|

        rowdata = [] of Float32
        (cols.begin..cols.end).each do |j|
          rowdata << self[i,j]
        end

        if rowdata.size() > 0
          arr << rowdata
        end

      end

      r = ASY::Matrix.new(arr)
      return r
    end

    #
    # setter, sets the matrix values for given row range and column
    #
    def []=(rows : ::Range(Int32, Int32), col : Int32, m : ASY::Matrix) : ASY::Matrix

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
    def []=(row : Int32, cols : ::Range(Int32, Int32), m : ASY::Matrix) : ASY::Matrix

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
    def []=(rows : ::Range(Int32,Int32), cols : ::Range(Int32, Int32), m : ASY::Matrix) : ASY::Matrix
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
    def []=(rows : ::Range(Int32, Int32), col : Int32, arr : Array(Real) ) : ASY::Matrix

      validate_range(rows)
      validate_row(rows.begin)
      validate_row(rows.end)
      validate_column(col)

      #
      # need to set the matrix values
      #
      arrindex = 0
      (rows.begin..rows.end).each do |i|
        self[i,col] = Float32.new(1.0 * arr[arrindex], 0.0)
        arrindex = arrindex + 1
      end

      return self
    end

    #
    # setter, sets the matrix values for given row range and column given an array of Float32
    #
    def []=(rows : ::Range(Int32, Int32), col : Int32, arr : Array(Float32) ) : ASY::Matrix

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
    def []=(row : Int32, cols : ::Range(Int32, Int32), arr : Array(Real)) : ASY::Matrix

      validate_range(cols)
      validate_column(cols.begin)
      validate_column(cols.end)
      validate_row(row)

      #
      # need to set the matrix values
      #
      arrindex = 0
      (cols.begin..cols.end).each do |j|

        self[row,j] = Float32.new(arr[arrindex],0.0)
        arrindex = arrindex + 1
      end

      return self
    end

    #
    # setter, sets the matrix values for given row and column range
    #
    def []=(row : Int32, cols : ::Range(Int32, Int32), arr : Array(Float32)) : ASY::Matrix

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

      @data[row_col_to_index(row, col)] = value.to_f32
    end

    #
    # sets a matrix element at the given row and column
    # with the given Float32 value
    #
    def []=(row : Int32, col : Int32, value : Float32)

      row = negative_row(row)
      col = negative_column(col)

      validate_row(row)
      validate_column(col)

      @data[row_col_to_index(row, col)] = value
    end

    #
    # prints the matrix
    #
    def print(precision : Int32 = 2, width : Int32 = 6, with_row : Bool = true)
      nrc = @nr_cols
      if with_row
        nrc = nrc + 1
      end

      colstr = Array.new(@nr_rows) { Array.new(nrc) {""}}

      (0..@nr_cols-1).each do |j|
        colv = self.column(j)

        (0..colv.size()-1).each do |row|
          val  = colv[row]
          sval = val.to_s
          colstr[row][j] = sval
        end
      end

      # print colstr
      (0..rows(colstr) - 1).each do |row|

        str = [] of String

        (0..cols(colstr) - 1).each do |col|
          str << colstr[row][col]
        end

        line = ""
        if with_row
          line = "#{row} : " +  str.join(" ")
        else
          line = str.join(" ")
        end
        puts line
      end
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
    def row(i : Int32) : ASY::Vector

      validate_row(i)

      #
      # start index and end index
      #
      si = row_col_to_index(i,0)
      ei = row_col_to_index(i,@nr_cols-1)

      r = @data[si..ei]
      v = ASY::Vector.new(r)
      return v
    end

    #
    # returns a sub vector of the matrix row 'i'
    #
    def row(i,scol,ecol : Int32) : ASY::Vector

      validate_row(i)
      validate_column(scol)
      validate_column(ecol)

      #
      # need to retrieve the row values individually
      # from scol to ecol
      r = [] of Float32
      (scol..ecol).each do |col|
        index = row_col_to_index(i,col)
        r << @data[index]
      end

      v = ASY::Vector.new(r)
      return v
    end

    #
    # returns a vector (either row/column)
    #
    def to_vector() : ASY::Vector

      x = [] of Float32
      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols - 1).each do |j|
          x << self[i,j]
        end
      end

      r = ASY::Vector.new(x)
      return r
    end

    #
    # applies  the operation specified by the operand
    # to all the elements in row 'i'
    # with the given real value
    #
    # returns a matrix
    #
    def row(i : Int32, value : Real, operand : String = "*") : ASY::Matrix

      validate_row(i)

      #
      # convert to Float32 value
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
            r.data[j] = @data[j] * val

          when "-"
            r.data[j] = @data[j] - val

          when "+"
            r.data[j] = @data[j] + val

          else
            # Crystal 0.34
        end # case
      end

      return r
    end

    #
    # applies  the operation specified by the operand
    # to all the elements in row 'i'
    # with the given Float32 value
    #
    # returns a matrix
    #
    def row(i : Int32, value : Float32, operand : String = "*") : ASY::Matrix

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
            r.data[j] = @data[j] * val

          when "-"
            r.data[j] = @data[j] - val

          when "+"
            r.data[j] = @data[j] + val

          else
            # Crystal 0.34
        end # case
      end

      return r
    end

    #
    # returns the matrix column 'i' as a vector
    #
    def column(i : Int32) : ASY::Vector

      validate_column(i)

      #
      # need to retrieve the column values individually
      #
      r = [] of Float32
      (0..@nr_rows-1).each do |row|
        index = row_col_to_index(row,i)
        r << @data[index]
      end

      v = ASY::Vector.new(r)
      return v
    end

    #
    # returns a sub vector of the matrix column 'i'
    #
    def column(i,srow,erow : Int32 ) : ASY::Vector

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
        r << @data[index]
      end

      v = ASY::Vector.new(r)
      return v
    end

    #
    # returns the transpose of a matrix as a new matrix
    #
    def transpose() : ASY::Matrix

      m = ASY::Matrix.new(@nr_cols,@nr_rows)
      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols - 1).each do |j|
          m[j,i] = self[i,j]
        end
      end

      return m
    end

    #
    # returns the identity matrix for a given n
    #
    def self.eye(n : Int32) : ASY::Matrix

      arr = ASY::Matrix.new(n,n)
      (0..n - 1).each do |i|
        (0..n - 1).each do |j|
          if i == j
            arr[i,j] = 1.0f32
          end
        end
      end

      return arr
    end

    #
    # returns a square matrix filled with 0
    #
    def self.zero(n : Int32) : ASY::Matrix
      arr = ASY::Matrix.new(n,n)
      return arr
    end

    #
    # returns a matrix filled with 0
    # Note: sets the object values to 0
    #
    def zero() : ASY::Matrix
      return ASY::Matrix.new(@nr_rows,@nr_cols)
    end

    #
    # returns a matrix filled with 0
    # Note: class method
    #
    def self.zero(rows, cols : Int32) : ASY::Matrix
      arr = ASY::Matrix.new(rows,cols)
      return arr
    end

    #
    # returns the clone of a matrix
    #
    def clone() : ASY::Matrix
      arr = ASY::Matrix.new(@nr_rows,@nr_cols)
      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols - 1).each do |j|
          arr[i,j] = self[i,j]
        end
      end

      return arr
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
    # returns true when the matrix is orthogonal (A * AT = AT * A = I)
    #
    def orthogonal?(show : Bool = false) : Bool
      empty?()
      if square?() == false
        matrix_notsquare()
      end

      m  = @nr_rows
      i  = ASY::Matrix.eye(m)
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
      i  = ASY::Matrix.eye(m)
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
    # compares matrix other to self
    # returns true when equal
    # otherwise false
    #
    def ==(other : ASY::Matrix) : Bool

      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols -1).each do |j|

          flag = self[i,j].real.be_close(other[i,j].real,ASY::EPSILON)
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

          flag = self[i,j].real.be_close(other[i,j].real,ASY::EPSILON)
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
    def +(other : ASY::Matrix) : ASY::Matrix
      r = ASY::Matrix.new(@nr_rows,@nr_cols)

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
    def -(other : ASY::Matrix) : ASY::Matrix
      r = ASY::Matrix.new(@nr_rows,@nr_cols)

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
    def *(other : ASY::Matrix) : ASY::Matrix

      r1 = @nr_rows
      c1 = @nr_cols

      r2 = other.nr_rows
      c2 = other.nr_cols

      if c1 != r2
        report_error("the number of columns of the left matrix should equal the number of rows of the right matrix")
      end

      r = ASY::Matrix.new(r1,c2)

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
    def *(other : ASY::Vector) : ASY::Vector

      if @nr_cols != other.size()
        report_error("the number of columns of the matrix should equal the dimension of the vector")
      end

      r = ASY::Vector.new(@nr_rows)
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
    def /(other : ASY::Matrix) : ASY::Matrix

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

      r = ASY::Matrix.new(r1,c2)

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
    # divides matrix self with Float32 number
    # square matrices only
    #
    def /(other : Float32) : ASY::Matrix

      empty?()
      if square?() == false
        matrix_notsquare()
      end

      n = @nr_rows
      r = ASY::Matrix.new(n,n)
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
    def /(other : Real) : ASY::Matrix

      empty?()
      if square?() == false
        matrix_notsquare()
      end

      n = @nr_rows
      r = ASY::Matrix.new(n,n)

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
    def determinant() : Float64
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

      sum = 0.0
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
    def minor(i,j : Int32) : ASY::Matrix

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

      return ASY::Matrix.new(r)
    end

    #
    # returns the adjoint of the matrix
    #
    def adjoint() : ASY::Matrix

      empty?()

      if @nr_rows <= 1
        report_error("cannot adjoint matrix with 1 row or less")
      end

      if @nr_cols <= 1
        report_error("cannot adjoint matrix with 1 column or less")
      end

      r = ASY::Matrix.new(@nr_rows,@nr_cols)
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
    def inverse() : ASY::Matrix

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
    # deletes the row 'i'
    # and returns the new modified matrix
    #
    def delete_at(i : Int32) : ASY::Matrix
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

      r = ASY::Matrix.new(@nr_rows - 1,@nr_cols)

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
    # compares the diagonals of both matrices within the tolerance of epsilon
    #
    def compare_diagonal?(other : ASY::Matrix, eps : Float64 = 1.0e-10, ) : Bool

      self.empty?()
      other.empty?()

      if self.square?() == false
        matrix_notsquare()
      end

      if other.square?() == false
        matrix_notsquare()
      end

      if other.rows != self.rows || other.columns != self.columns
        return false
      end

      n = other.rows
      n.times do |i|
        diff = (other[i,i].abs - self[i,i].abs).abs
        #if (other[i,i] - self[i,i]).abs > eps
        if diff > eps
          return false
        end
      end

      return true
    end

    #
    # compare both matrices within the tolerance of epsilon
    #
    def compare?(other : ASY::Matrix, show : Bool = false, eps : Float64 = 1.0e-5) : Bool

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
    def normalize() : ASY::Matrix

      m = self
      erow = @nr_rows - 1

      (0..@nr_cols-1).each do |j|
        val = column(j).norm()

        #if val == 0
        if val.zero?()
          division_byzero(true)
        end

        #m[0..erow,j] = (1.0/val) * m[0..erow,j]

        # Float32 division
        (0..erow).each do |k|
          m[k,j] = m[k,j].div(val)
        end
      end

      return m
    end

    def self.translation_matrix(position : ASY::Triple) : ASY::Matrix
      r = self.eye(4)
      r[0,3] = position.x
      r[1,3] = position.y
      r[2,3] = position.z
      r[3,3] = 1.0f32
      return r
    end

    def self.scale_matrix(scale : ASY::Triple) : ASY::Matrix
      r = self.eye(4)

      if scale.x == 0.0
        scale.x = 1.0f32
      end

      if scale.y == 0.0
        scale.y = 1.0f32
      end

      if scale.z == 0.0
        scale.z = 1.0f32
      end

      r[0,0] = scale.x
      r[1,1] = scale.y
      r[2,2] = scale.z

      return r
    end

    def self.rotation_matrix(rot : ASY::Triple) : ASY::Matrix

      rx       = self.eye(4)
      ry       = self.eye(4)
      rz       = self.eye(4)

      xrad     = radians(rot.x)
      yrad     = radians(rot.y)
      zrad     = radians(rot.z)

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

    def self.model_matrix(position : ASY::Triple, rotation : ASY::Triple, scale : ASY::Triple) : ASY::Matrix

      m_trans = self.translation_matrix(position)
      m_scale = self.scale_matrix(scale)
      m_rot   = self.rotation_matrix(rotation)

      #r = m_trans * m_scale * m_rot
      r = m_trans * m_rot * m_scale
      #r = r.transpose()
      return r
    end

    def self.perspective(fov : Float32, aspect_ratio : Float32, near : Float32, far : Float32) : ASY::Matrix
      r = self.eye(4)

      #rad     = fov
      #tan     = Math.tan(rad * 0.5 * Math::PI/180.0)
      #scale   = 1.0/tan
      #r[0, 0] = scale.to_f32
      #r[1, 1] = scale.to_f32
      #r[2, 2] = -far/(far - near)
      #r[3, 2] = -far * near/(far - near)
      #r[2, 3] = -1.0f32
      #r[3, 3] =  0.0f32
      #return r

      # wrong in_radians   = radians(fov.to_f32/2.0f32)
      # wrong tan_half_fov = Math.tan(in_radians)

      tan_half_fov = Math.tan(fov/2.0)
      zm = far - near
      zp = far + near

      r[0, 0] = 1.0f32/(tan_half_fov * aspect_ratio)
      r[1, 1] = 1.0f32/tan_half_fov
      r[2, 2] = -1.0 * zp/zm
      r[2, 3] = -2.0f32 * (far * near)/zm
      r[3, 2] = -1.0f32
      r[3, 3] = 0.0f32
      r = r.transpose()
      return r
    end

    def self.view_matrix( position : ASY::Triple, pitch : Float32, yaw : Float32) : ASY::Matrix

      r = self.eye(4)

      negative_pos = -1.0f32 * position

      rad_pitch = radians(pitch)
      rad_yaw   = radians(yaw)
      x_axis    = ASY::Triple.new(1,0,0)
      y_axis    = ASY::Triple.new(0,1,0)

      rot_pitch = rotate3(pitch, x_axis)
      rot_yaw   = rotate3(yaw,   y_axis)

      r = rot_pitch * r
      r = rot_yaw   * r
      r = shift3(negative_pos) * r
      puts r.print
      return r
    end

  end
end

#
# operator Int32 * ASY::Matrix
#
struct Int32

  # multiplies matrix other with a Int32
  def *(other : ASY::Matrix) : ASY::Matrix

    r1 = other.nr_rows
    c1 = other.nr_cols

    r = ASY::Matrix.new(r1,c1)

    for i = 0, i < r1, i = i + 1 do
      for j = 0, j < c1, j = j + 1 do
        r[i,j] = self * other[i,j]
      end
    end

    return r
  end
end

#
# operator Float64 * ASY::Matrix
#
struct Float64

  # multiplies matrix other with a Float64
  def *(other : ASY::Matrix) : ASY::Matrix

    r1 = other.nr_rows
    c1 = other.nr_cols

    r = ASY::Matrix.new(r1,c1)

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
  def be_close(expected_value : Float64, delta : Float64) : Bool
    actual_value = self
    (actual_value - expected_value).abs <= delta
  end
end

#struct Float32
#
#  # multiplies matrix other with a Float32 number
#  def *(other : ASY::Matrix) : ASY::Matrix
#
#    r1 = other.nr_rows
#    c1 = other.nr_cols
#
#    r = ASY::Matrix.new(r1,c1)
#
#    for i = 0, i < r1, i = i + 1 do
#      for j = 0, j < c1, j = j + 1 do
#        r[i,j] = self * other[i,j]
#      end
#    end
#
#    return r
#  end
#end
