#
# errors.cr
#
def report_error(text : String)
  puts sprintf("error : %s",text)
  exit(-1)
end

def report_warning(text : String)
  puts sprintf("warning : %s",text)
end

def report_info(text : String)
  puts sprintf("info : %s",text)
end

def filenotfound(filename)
  if File.exists?(filename) == false
    report_error("file '#{filename}' not found")
  end
end

def matrix_notsquare()
  puts sprintf("error : %s","array is not a square matrix")
  exit(-1)
end

def matrix_singular()
  puts sprintf("error : %s","array is singular")
  exit(-1)
end

