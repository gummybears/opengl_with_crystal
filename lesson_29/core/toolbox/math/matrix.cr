#
# matrix.cr
#
require "../errors.cr"
require "./for_macro.cr"

module GLM

  class Matrix
    getter   nr_rows : Int32
    getter   nr_cols : Int32
    property data    : Array(Float32)

    def initialize()
      @nr_rows = 4
      @nr_cols = 4
      @data = Array.new(nr_rows*nr_cols) { 0f32 }
    end

    def buffer
      @data
    end

    #
    # computes the offset into the internal 1-dimensional array 'data'
    #
    private def compute_index(row : Int32, col : Int32) : Int32

      i = row + @nr_cols * col
      return i

    end

    #
    # given a row and column
    # computes the offset in the array '@data'
    #
    private def row_col_to_index(row : Int32, col : Int32) : Int32

      index = compute_index(row,col)
      if index >= 0 && index < @data.size
        return index
      end

      report_error("invalid indices for matrix[#{row},#{col}]")
      return -1
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

      if @nr_cols != @nr_rows
        report_error("can only create a square matrix")
      end

      @data = Array.new(nr_rows*nr_cols) { 0f32 }
    end

    def initialize(arr : Array(Array(Float32)) )
      @nr_rows = arr.size()
      @nr_cols = arr[0].size()

      @data = Array.new(nr_rows*nr_cols) { 0f32 }

      (0..@nr_rows - 1).each do |r|
        (0..@nr_cols - 1).each do |c|

          index    = compute_index(r,c)
          real_val = 1.0f32 * arr[r][c]
          @data[index] = real_val

        end
      end
    end

    def initialize(arr : Array(Array(Float64)) )
      @nr_rows = arr.size()
      @nr_cols = arr[0].size()

      @data = Array.new(nr_rows*nr_cols) { 0f32 }

      (0..@nr_rows - 1).each do |r|
        (0..@nr_cols - 1).each do |c|

          index    = compute_index(r,c)
          real_val = 1.0f32 * arr[r][c]
          @data[index] = real_val

        end
      end
    end

    def initialize(arr : Array(Array(Int32)) )
      @nr_rows = arr.size()
      @nr_cols = arr[0].size()

      @data = Array.new(nr_rows*nr_cols) { 0f32 }

      (0..@nr_rows - 1).each do |r|
        (0..@nr_cols - 1).each do |c|

          index    = compute_index(r,c)
          real_val = 1.0f32 * arr[r][c]
          @data[index] = real_val

        end
      end
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
    # sets a matrix element at the given row and column
    # with the given real value
    #
    def []=(row : Int32, col : Int32, value : Int32)

      row = negative_row(row)
      col = negative_column(col)

      validate_row(row)
      validate_column(col)

      @data[row_col_to_index(row, col)] = value.to_f32
    end

    #
    # sets a matrix element at the given row and column
    # with the given Real value
    #
    def []=(row : Int32, col : Int32, value : Float32)

      row = negative_row(row)
      col = negative_column(col)

      validate_row(row)
      validate_column(col)

      @data[row_col_to_index(row, col)] = value
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
    # returns the diagonal of a matrix as a new matrix
    # Note: only for square matrices
    #
    def diagonal() : GLM::Matrix

      # check matrix is square
      if @nr_rows != @nr_cols
        matrix_notsquare()
      end

      arr = GLM::Matrix.new(@nr_rows,@nr_cols)
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

      m = transpose()
      return m
    end

    #
    # returns the identity matrix for a given n
    #
    def self.identity(n : Int32 = 4) : GLM::Matrix

      arr = GLM::Matrix.new(n,n)
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
    def self.zero(n : Int32 = 4) : GLM::Matrix
      arr = GLM::Matrix.new(n,n)
      return arr
    end

    #
    # returns a matrix filled with 0
    # Note: sets the object values to 0
    #
    def zero() : GLM::Matrix
      return GLM::Matrix.new(@nr_rows,@nr_cols)
    end

    #
    # returns a matrix filled with 0
    # Note: class method
    #
    def self.zero(rows, cols : Int32) : GLM::Matrix
      arr = GLM::Matrix.new(rows,cols)
      return arr
    end

    #
    # returns true when the matrix is square
    #
    def square?() : Bool
      @nr_rows == @nr_cols
    end

    #
    # multiplies matrix other with self
    #
    def *(other : GLM::Matrix) : GLM::Matrix

      r1 = @nr_rows
      c1 = @nr_cols

      r2 = other.nr_rows
      c2 = other.nr_cols

      if c1 != r2
        report_error("the number of columns of the left matrix should equal the number of rows of the right matrix")
      end

      r = GLM::Matrix.new(r1,c2)

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
    def *(other : GLM::Vector4) : GLM::Vector4

      if @nr_cols != other.rows()
        report_error("the number of columns of the matrix should equal the dimension of the vector")
      end

      r = GLM::Vector4.new(0,0,0,0)
      for i = 0, i < @nr_rows, i = i + 1 do

        sum = 0f32
        for j = 0, j < @nr_cols, j = j + 1 do
          val = self[i,j] * other[j]
          sum = sum + val
        end

        r[i] = sum
      end

      return r
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
        return self[0,0]
      end

      if @nr_rows == 2
        val = self[0,0] * self[1,1] - self[0,1] * self[1,0]
        return val
      end

      sum = 0f32
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

      return sum
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

      r = Array.new(0) { Array.new(0) { 0f32}}
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

      r = GLM::Matrix.new(@nr_rows,@nr_cols)
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
          r[row,col] = 1f32 * sign * det
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

        (0..erow).each do |k|
          m[k,j] = m[k,j].div(val)
        end
      end

      return m
    end

    def to_s : String
      s = [] of String
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[0,0],self[0,1],self[0,2],self[0,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[1,0],self[1,1],self[1,2],self[1,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[2,0],self[2,1],self[2,2],self[2,3])
      s << sprintf("|%6.3f %6.3f %6.3f %6.3f|",self[3,0],self[3,1],self[3,2],self[3,3])

      r = s.join("\n")
      return r
    end

    #
    # compares matrix other to self
    # returns true when equal
    # otherwise false
    #
    def ==(other : GLM::Matrix) : Bool

      (0..@nr_rows - 1).each do |i|
        (0..@nr_cols -1).each do |j|

          flag = self[i,j].be_close(other[i,j],0.0001)
          if flag == false
            return false
          end

        end
      end

      return true
    end

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
