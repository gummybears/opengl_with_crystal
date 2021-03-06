require "yaml"
require "./settings.cr"

class Scene

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
    r = GLM::Vec3.new(0,0,0)
    begin
      x  = @yaml[key1]["x"].as_f.to_f32
      y  = @yaml[key1]["y"].as_f.to_f32
      z  = @yaml[key1]["z"].as_f.to_f32
      r = GLM::Vec3.new(x,y,z)
      return r
    rescue
    end

    return r
  end

  def bg()
    key1 = "display"
    key2 = "background"
    key3 = "color"
    red      = @yaml[key1][key2][key3]["r"].as_f.to_f32
    blue     = @yaml[key1][key2][key3]["b"].as_f.to_f32
    green    = @yaml[key1][key2][key3]["g"].as_f.to_f32
    opacity  = @yaml[key1][key2][key3]["a"].as_f.to_f32

    Color.new(red,blue,green,opacity)
  end

  def settings : Settings
    Settings.new(title(), width(), height(), fov(), near(), far(), camera(), bg())
  end

  def models() : Array(ModelData)
  end

  def model_position(model : String) : GLM::Vec3

    key1 = "entities"
    key2 = "pos"
    r = GLM::Vec3.new(0,0,0)

    begin
      entity = @yaml[key1][model][key2]

      x = entity["x"].as_f.to_f32
      y = entity["y"].as_f.to_f32
      z = entity["z"].as_f.to_f32
      r = GLM::Vec3.new(x,y,z)
      return r
    rescue
    end

    return r

  end

  def model_rotation(model : String) : GLM::Vec3

    key1 = "entities"
    key2 = "rot"

    entity = @yaml[key1][model][key2]

    x = entity["x"].as_f.to_f32
    y = entity["y"].as_f.to_f32
    z = entity["z"].as_f.to_f32
    r = GLM::Vec3.new(x,y,z)
    return r

  end

  def model_scale(model : String) : GLM::Vec3

    key1 = "entities"
    key2 = "scale"

    entity = @yaml[key1][model][key2]

    x = entity["x"].as_f.to_f32
    y = entity["y"].as_f.to_f32
    z = entity["z"].as_f.to_f32
    r = GLM::Vec3.new(x,y,z)
    return r

  end

  def light_position() : GLM::Vec3
    key1 = "light"
    key2 = "pos"
    x = @yaml[key1][key2]["x"].as_f.to_f32
    y = @yaml[key1][key2]["y"].as_f.to_f32
    z = @yaml[key1][key2]["z"].as_f.to_f32

    r = GLM::Vec3.new(x,y,z)
    return r
  end

  def light_color() : GLM::Vec3
    key1 = "light"
    key2 = "color"
    red      = @yaml[key1][key2]["r"].as_f.to_f32
    blue     = @yaml[key1][key2]["b"].as_f.to_f32
    green    = @yaml[key1][key2]["g"].as_f.to_f32
    #opacity  = @yaml[key1][key2]["a"].as_f.to_f32

    r = GLM::Vec3.new(red,green,blue)
    return r
  end


  # old code def model_vertex_shader(model : String) : String
  # old code
  # old code   key1 = "entities"
  # old code   key2 = "vertexshader"
  # old code   @yaml[key1][model][key2].to_s
  # old code end
  # old code
  # old code def model_fragment_shader(model : String) : String
  # old code
  # old code   key1 = "entities"
  # old code   key2 = "fragmentshader"
  # old code   @yaml[key1][model][key2].to_s
  # old code end

  def model_shine(model : String) : Float32

    key1 = "entities"
    key2 = "shine"
    @yaml[key1][model][key2].as_f.to_f32
  end

  def model_reflectivity(model : String) : Float32

    key1 = "entities"
    key2 = "reflectivity"
    @yaml[key1][model][key2].as_f.to_f32
  end

  def model_object(model : String) : String
    key1 = "entities"
    key2 = "obj"
    @yaml[key1][model][key2].to_s
  end

  def model_texture(model : String) : String
    key1 = "entities"
    key2 = "texture"
    @yaml[key1][model][key2].to_s
  end

  def vertex_count(model : String) : Int32
    key1 = "entities"
    key2 = "vertex_count"
    @yaml[key1][model][key2].as_i
  end

  def size(model : String) : Int32
    key1 = "entities"
    key2 = "size"
    @yaml[key1][model][key2].as_i
  end


end


