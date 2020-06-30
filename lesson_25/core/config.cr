require "yaml"
require "./settings.cr"

class Config

  property yaml

  def initialize(file : String)
    filenotfound(file)
    @yaml = YAML.parse(File.read(file))
  end

  def title()
    @yaml["display"]["screen"]["title"].to_s
  end

  def width
    @yaml["display"]["screen"]["width"].as_f.to_f32
  end

  def height
    @yaml["display"]["screen"]["height"].as_f.to_f32
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

  def settings : Settings
    Settings.new(title(), width(), height(), fov(), near(), far(), camera(), bg(),fog_density(), fog_gradient())
  end

  def models() : Array(ModelData)
  end

  def model_position(model : String) : GLM::Vector3

    key1 = "entities"
    key2 = "pos"
    r = GLM::Vector3.new(0,0,0)

    begin
      entity = @yaml[key1][model][key2]

      x = entity["x"].as_f.to_f32
      y = entity["y"].as_f.to_f32
      z = entity["z"].as_f.to_f32
      r = GLM::Vector3.new(x,y,z)
      return r
    rescue
    end

    return r

  end

  def model_rotation(model : String) : GLM::Vector3

    key1 = "entities"
    key2 = "rot"

    entity = @yaml[key1][model][key2]

    x = entity["x"].as_f.to_f32
    y = entity["y"].as_f.to_f32
    z = entity["z"].as_f.to_f32
    r = GLM::Vector3.new(x,y,z)
    return r

  end

  def model_scale(model : String) : GLM::Vector3

    key1 = "entities"
    key2 = "scale"

    entity = @yaml[key1][model][key2]

    x = entity["x"].as_f.to_f32
    y = entity["y"].as_f.to_f32
    z = entity["z"].as_f.to_f32
    r = GLM::Vector3.new(x,y,z)
    return r

  end

  def light_position(i : Int32) : GLM::Vector3
    key1 = "light#{i}"
    key2 = "pos"
    x = @yaml[key1][key2]["x"].as_f.to_f32
    y = @yaml[key1][key2]["y"].as_f.to_f32
    z = @yaml[key1][key2]["z"].as_f.to_f32

    r = GLM::Vector3.new(x,y,z)
    return r
  end

  def light_color(i : Int32) : GLM::Vector3
    key1 = "light#{i}"
    key2 = "color"
    red      = @yaml[key1][key2]["r"].as_f.to_f32
    blue     = @yaml[key1][key2]["b"].as_f.to_f32
    green    = @yaml[key1][key2]["g"].as_f.to_f32

    r = GLM::Vector3.new(red,green,blue)
    return r
  end

  def model_shine(model : String) : Float32

    key1 = "entities"
    key2 = "shine"
    @yaml[key1][model][key2].as_f.to_f32
  end

  def model_reflectivity(model : String) : Float32

    key1 = "entities"
    key2 = "reflectivity"
    begin
      @yaml[key1][model][key2].as_f.to_f32
    rescue
      report_error("model not found in yaml file, '#{model}'")
    end

  end

  def model_object(model : String) : String
    key1 = "entities"
    key2 = "obj"
    begin
      @yaml[key1][model][key2].to_s
    rescue
      report_error("model not found in yaml file, '#{model}'")
    end
  end

  def model_texture(model : String) : String
    key1 = "entities"
    key2 = "texture"
    begin
      @yaml[key1][model][key2].to_s
    rescue
      report_error("model not found in yaml file, '#{model}'")
    end

  end

  def vertex_count(model : String) : Int32
    key1 = "entities"
    key2 = "vertex_count"
    begin
      @yaml[key1][model][key2].as_i
    rescue
      report_error("model not found in yaml file, '#{model}'")
    end

  end

  def size(model : String) : Int32
    key1 = "entities"
    key2 = "size"
    @yaml[key1][model][key2].as_i
  end

  def fog_gradient()
    @yaml["fog"]["gradient"].as_f.to_f32
  end

  def fog_density()
    @yaml["fog"]["density"].as_f.to_f32
  end

end


