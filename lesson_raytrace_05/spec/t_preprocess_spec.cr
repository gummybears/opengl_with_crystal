require "spec"
require "../core/preprocess.cr"

describe "Preprocess" do

  #describe "new" do
  #  it "file found" do
  #    pre = Preprocess.new("spec/shader1.txt")
  #    pre.status.should eq 0
  #  end
  #
  #  it "file not found" do
  #    pre = Preprocess.new("spec/shader.txt")
  #    pre.status.should eq -1
  #  end
  #end

  describe "get_include_file" do

    it "// include file.txt" do

      pre = Preprocess.new
      line = "// include file.txt"
      found, file = pre.get_include_file(line)
      found.should eq true
      file.should eq "file.txt"
    end

    it "// include file.txt;" do

      pre = Preprocess.new
      line = "// include file.txt;"
      found, file = pre.get_include_file(line)
      found.should eq true
      file.should eq "file.txt"
    end

    it "// include file.txt/-*&" do
      pre = Preprocess.new
      line = "// include file.txt/-*&"
      found, file = pre.get_include_file(line)
      found.should eq true
      file.should eq "file.txt/"
    end

    it "// include File" do
      pre = Preprocess.new
      line = "// include File"
      found, file = pre.get_include_file(line)
      found.should eq true
      file.should eq "File"
    end


    it "// include File..text" do
      pre = Preprocess.new

      line = "// include File..text"
      found, file = pre.get_include_file(line)
      found.should eq true
      file.should eq "File..text"
    end

    it "// include " do
      pre = Preprocess.new
      line = "// include "
      found, file = pre.get_include_file(line)
      found.should eq false
      file.should eq ""
    end

    it "// include" do
      pre = Preprocess.new
      line = "// include"
      found, file = pre.get_include_file(line)
      found.should eq false
      file.should eq ""
    end
  end

  describe "read" do
    it "process includes (no cyclic detection)" do
      pre = Preprocess.new()

      pre.read("spec/shader1.txt")
      pre.lines.join("|").should eq "123|abc|def|ghi|lmk|456"
      pre.lines.size.should eq 6

    end

  end
end
