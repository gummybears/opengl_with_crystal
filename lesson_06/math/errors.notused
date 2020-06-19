#
# errors.cr
#
PROGRAM = "lesson06"

def report_error(text : String)
  puts sprintf("%s error : %s",PROGRAM,text)
  exit(-1)
end

def report_warning(text : String)
  if ASY::Global.settings.warn
    puts sprintf("%s warning : %s",PROGRAM,text)
  end
end

def report_info(text : String)
  puts sprintf("%s info : %s",PROGRAM,text)
end

def filenotfound(filename)
  if File.exists?(filename) == false
    report_error("file '#{filename}' not found")
  end
end

def matrix_notsquare()
  puts sprintf("%s error : %s",PROGRAM,"array is not a square matrix")
  exit(-1)
end

def matrix_singular()
  puts sprintf("%s error : %s",PROGRAM,"array is singular")
  exit(-1)
end

#def division_byzero(complex : Bool = false)
#  if complex
#    puts sprintf("%s error : %s",PROGRAM,"complex division by zero")
#  else
#    puts sprintf("%s error : %s",PROGRAM,"division by zero")
#  end
#  exit(-1)
#end
