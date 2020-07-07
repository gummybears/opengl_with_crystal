require "./errors.cr"

#
# a very simple preprocessor
#
class Preprocess

  property lines : Array(String)

  def initialize()
    @lines = [] of String
  end

  #
  # valid filenames
  # lowercase
  # uppercase
  # optional dot (could be more than 1)
  # optional numbers
  # optional directory separator
  #
  def get_include_file(line : String) : {Bool, String}
    x = line.match(/include\s([a-z|A-Z|_|\.|[0-9|\/]+)/)
    if x
      x = x.not_nil!
      if x.size == 2

        return true, x[1]
      end
    end

    return false, ""
  end

  def read(filename : String)
    #puts "preprocessing #{File.real_path(filename)}"

    xlines = File.read_lines(filename)
    xlines.each do |line|

      found, include_file = get_include_file(line)
      if found

        if filename == include_file
          puts "error : include file '#{include_file}' circular referenced in #{filename}"
          exit
        end

        begin
          include_file = File.real_path(include_file)
        rescue
          puts "error : file '#{include_file}' not found"
          exit
        end

        pre = Preprocess.new()
        pre.read(include_file)
        include_lines = pre.lines
        include_lines.each do |x|
          @lines << x if x.size > 0
        end

      else

        @lines << line

      end # if

    end # each
  end # read
end


