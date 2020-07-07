require "yaml"

class Config

  property yaml

  def initialize(file : String)
    filenotfound(file)
    @yaml = YAML.parse(File.read(file))
  end

  def vertexshader
    @yaml["shaders"]["vertex"].as_s
  end

  def fragmentshader
    @yaml["shaders"]["fragment"].as_s
  end

  def title
    @yaml["display"]["screen"]["title"].as_s
  end

  def width
    @yaml["display"]["screen"]["width"].as_i
  end

  def height
    @yaml["display"]["screen"]["height"].as_i
  end

  def fov
    @yaml["display"]["screen"]["fov"].as_f.to_f32
  end

  def near
    @yaml["display"]["screen"]["near"].as_f.to_f32
  end

  def far
    @yaml["display"]["screen"]["far"].as_f.to_f32
  end

  def camera()
    key1 = "camera"
    r = GLM::Vector3.new(0,0,0)
    begin
      x  = @yaml[key1]["x"].as_f.to_f32
      y  = @yaml[key1]["y"].as_f.to_f32
      z  = @yaml[key1]["z"].as_f.to_f32
      r = GLM::Vector3.new(x,y,z)
      return r
    rescue
    end

    return r
  end

  def lights() : Array(GLM::Vector3)

    key1 = "lights"

    r    = [] of GLM::Vector3

    lights = @yaml[key1].as_a
    lights.each do |light|

      x  = light["pos"]["x"].as_f.to_f32
      y  = light["pos"]["y"].as_f.to_f32
      z  = light["pos"]["z"].as_f.to_f32
      pos = GLM::Vector3.new(x,y,z)
      r << pos
    end

    return r
  end

  def bg()
    key1 = "display"
    key2 = "background"
    key3 = "color"
    red   = @yaml[key1][key2][key3]["r"].as_i.to_u8
    green = @yaml[key1][key2][key3]["g"].as_i.to_u8
    blue  = @yaml[key1][key2][key3]["b"].as_i.to_u8
    alpha = @yaml[key1][key2][key3]["a"].as_i.to_u8

    Color.new(red,green,blue,alpha)
  end
end


