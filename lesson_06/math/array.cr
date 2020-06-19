#
# array.cr
#
#
require "./errors.cr"

macro define_methods1(var_type)
  def rows(arr : Array({{var_type}} ) )
    return 1
  end

  def cols(arr : Array( {{var_type}} ) )
    return arr.size
  end

  def length(arr : Array( {{var_type}} ) )
    return arr.size
  end

  def sort(arr : Array( {{var_type}} ), func ) : Array( {{var_type}} )
    b = arr.sort { |a,b| func.call(a,b) }
    return b
  end

  def concat(arr1, arr2 : Array( {{var_type}} ) ) : Array( {{var_type}} )
    r = [] of {{var_type}}
    arr1.each do |x|
      r << x
    end

    arr2.each do |x|
      r << x
    end

    return r
  end

  def concat(arr1, arr2, arr3 : Array( {{var_type}} ) ) : Array( {{var_type}} )
    r = [] of {{var_type}}
    arr1.each do |x|
      r << x
    end

    arr2.each do |x|
      r << x
    end

    arr3.each do |x|
      r << x
    end
    return r
  end
end

macro define_methods2(var_type)

  #
  # returns the number of rows
  #
  def rows(arr : Array(Array({{var_type}}) ) )
    if arr.size > 0
      return arr.size
    end

    return 0
  end

  #
  # returns the number of columns for the row 0
  #
  def cols(arr : Array(Array({{var_type}}) ) )
    if arr.size > 0 && arr[0].size > 0
      x = arr[0].size
      return x
    end

    return 0
  end

  #
  # returns the number of columns for the 'i'th row
  #
  def cols(arr : Array(Array({{var_type}})), i : Int32)
    if i > rows(arr)
      report_error("index out of bounds for i is #{i}")
    end

    if arr.size > 0 && arr[i].size > 0
      x = arr[i].size
      return x
    end

    return 0
  end

  def length(arr : Array(Array({{var_type}}) ) )
    return cols(arr) * rows(arr)
  end

  #
  # returns a column vector for a given row in a n x n array
  #
  def get_row(arr : Array(Array({{var_type}})), row : Int32 ) : Array({{var_type}})

    r = [] of {{var_type}}

    (0..cols(arr)-1).each do |j|
      r << arr[row][j]
    end

    return r

  end
end

macro define_methods3(var_type)
  def rows(arr : Array(Array(Array({{var_type}}))) )
    if arr.size > 0 && arr[0].size > 0
      return arr[0].size
    end

    return 0
  end

  def depth(arr : Array(Array(Array({{var_type}}))) )
    if arr.size > 0
      return arr.size
    end
    return 0
  end

  def cols(arr : Array(Array(Array({{var_type}}))) )
    if arr.size > 0 && arr[0].size > 0 && arr[0][0].size > 0
      return arr[0][0].size
    end

    return 0
  end

  def length(arr : Array(Array(Array({{var_type}}))) )
    return cols(arr) * rows(arr) * depth(arr)
  end

end


#
# appends val to array arr
#
def append(arr, val)
  arr << val
end

#
#  removes array element starting at i up to (including j)
#
def remove(arr, i, j : Int32)

  if j < i
    report_error("index j must be greater/equal to i in remove")
  end

  r = Range.new(i,j)
  begin
    arr.delete_at(r)
  rescue e
    report_error(e.message.to_s.downcase)
    return arr
  end

  return arr
end

#
# removes all array elements
#
def remove(arr)
  arr.clear()
end

#
# removes an array element at position 'i'
#
def remove(arr, i : Int32)
  begin
    arr.delete_at(i)
  rescue e
    report_error(e.message.to_s.downcase)
    return arr
  end

  return arr
end

#
# inserts object before the element at index and shifting successive elements, if any
#
def insert(arr, val, i : Int32)
  begin
    arr.insert(i,val)
  rescue e
    report_error(e.message.to_s.downcase)
    return arr
  end
end

#
# if n >= 1 returns the array [0,1,...,n-1]
# (otherwise returns a null array)
#
def sequence(n : Int32) : Array(Int32)

  arr = [] of Int32
  if n < 1
    report_warning("sequence returns an empty array for n = #{n}")
    return arr
  end


  (0.. n - 1).each do |i|
    arr << i
  end

  return arr
end


#
# print the 2 dimensional array of Real's
#
def print(arr : Array(Array(Real)), precision : Int32 = 2, with_row : Bool = true)

  n = rows(arr)
  format  = "2.#{precision}"

  row = 0
  while row < n

    col = 0
    str = [] of String
    while col < cols(arr)
      class_type = arr[row][col].class.to_s

      s = ""
      case class_type
        when "Float32","Float64"
          s = sprintf("% #{format}f",arr[row][col])

        when "Int","Int32","Int64"
          s = sprintf("%d",arr[row][col])

        else
          # Crystal 0.34
      end # case

      str << s
      col = col + 1
    end

    line = ""
    if with_row
      line = "#{row+1} : " +  str.join(" ")
    else
      line = str.join(" ")
    end
    puts line

    row = row + 1
  end
end

#
# print the 2 dimensional array of Pairs
#
def print(arr : Array(Array(ASY::Pair)), precision : Int32 = 2, with_row : Bool = true)

  n      = rows(arr)
  format = "2.#{precision}"

  row = 0
  while row < n

    col = 0
    str = [] of String
    while col < cols(arr)
      class_type = arr[row][col].class.to_s

      s = ""
      s = sprintf("%s",arr[row][col].to_s(precision,with_row))

      str << s
      col = col + 1
    end

    line = ""
    if with_row
      line = "#{row+1} : " +  str.join(" ")
    else
      line = str.join(" ")
    end
    puts line

    row = row + 1
  end
end

#
# print the 2 dimensional array of Triples
#
def print(arr : Array(Array(ASY::Triple)), precision : Int32 = 2, with_row : Bool = true)

  n = rows(arr)
  format  = "2.#{precision}"

  row = 0
  while row < n

    col = 0
    str = [] of String
    while col < cols(arr)
      class_type = arr[row][col].class.to_s

      s = ""
      s = sprintf("%s",arr[row][col].to_s(precision,with_row))

      str << s
      col = col + 1
    end

    line = ""
    if with_row
      line = "#{row+1} : " +  str.join(" ")
    else
      line = str.join(" ")
    end
    puts line

    row = row + 1
  end
end

define_methods1 Bool
define_methods1 Int32
define_methods1 Float64
define_methods1 String

define_methods2 Bool
define_methods2 Int32
define_methods2 Float64
define_methods2 String
define_methods2 Real

define_methods3 Bool
define_methods3 Int32
define_methods3 Float64
define_methods3 String

