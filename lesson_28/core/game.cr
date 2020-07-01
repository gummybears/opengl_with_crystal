require "./math/**"

class Game

  @@elapsed = 0f64

  property config        : Config

  property models        : Hash(String,TextureModel)
  property terrains      : Array(Terrain)
  property lights        : Array(Light)
  property entities      : Array(Entity)
  property guis          : Array(GuiTexture)

  property camera        : Camera
  property window        : CrystGLFW::Window

  property scroll_offset : GLM::Vector2 = GLM::Vector2.new(0,0)
  property scrolling     : Bool         = false

  property mouse_dx      : Float32      = 0
  property mouse_dy      : Float32      = 0

  property mouse_left    : Int32        = -1
  property mouse_right   : Int32        = -1

  #property elapsed       : Float64      = 0

  def initialize(filename : String)
    filenotfound(filename)
    @config = Config.new(filename)

    # hash of models
    @models   = Hash(String,TextureModel).new
    @entities = [] of Entity
    @terrains = [] of Terrain
    @guis     = [] of GuiTexture

    @lights   = [] of Light
    @camera   = Camera.new

    #
    # Request a specific version of OpenGL in core profile mode with forward compatibility.
    #
    hints = {
      Window::HintLabel::ContextVersionMajor => 3,
      Window::HintLabel::ContextVersionMinor => 3,
      Window::HintLabel::ClientAPI           => ClientAPI::OpenGL,
      Window::HintLabel::OpenGLProfile       => OpenGLProfile::Core
    }

    #
    # create a new window
    #
    @window = Window.new(width: @config.settings.width, height: @config.settings.height,title: @config.settings.title, hints: hints)

    #
    # Make the window the current OpenGL context
    #
    @window.make_context_current

    #
    # set the cursor input mode, see https://www.glfw.org/docs/3.2/group__input.html#gaa92336e173da9c8834558b54ee80563b
    #
    @window.cursor.disable
  end

  #
  # number of seconds elapsed since last frame
  #
  def self.elapsed
    @@elapsed
  end

  def load_model_with_texture(name : String, has_transparency : Bool, use_fake_lighting : Bool) : TextureModel

    texture_file  = @config.model_texture(name)

    model_data    = ModelData.from_obj(@config.model_object(name))
    model         = Model.load(model_data)
    texture_model = TextureModel.new(model,texture_file)

    texture_model.shine_damper      = @config.model_shine(name)
    texture_model.reflectivity      = @config.model_reflectivity(name)
    texture_model.has_transparency  = has_transparency
    texture_model.use_fake_lighting = use_fake_lighting
    texture_model.name = name

    return texture_model
  end

  def load_model_with_texture_atlas(name : String, has_transparency : Bool, use_fake_lighting : Bool, image : String, number_of_rows : Int32) : TextureModel

    filenotfound(image)

    #
    # load texture atlas
    #
    texture_atlas = Texture.load(image)

    model_data    = ModelData.from_obj(@config.model_object(name))
    model         = Model.load(model_data)
    texture_model = TextureModel.new(model,texture_atlas)
    texture_model.number_of_rows = number_of_rows

    texture_model.shine_damper      = @config.model_shine(name)
    texture_model.reflectivity      = @config.model_reflectivity(name)
    texture_model.has_transparency  = has_transparency
    texture_model.use_fake_lighting = use_fake_lighting
    texture_model.name = name

    return texture_model
  end

  #
  # using a blend map for our terrain
  #
  def texture_with_blendmap(blend_map : String, models : Array(String)) : {TerrainTexturePack, TerrainTexture}

    terrain_textures = [] of TerrainTexture

    models.each do |model|

      resource = @config.model_texture(model)
      terrain_texture = TerrainTexture.new(Texture.load(resource))

      terrain_textures << terrain_texture
    end

    #
    # Texture pack
    #
    texture_pack = TerrainTexturePack.new(terrain_textures[0], terrain_textures[1], terrain_textures[2],terrain_textures[3])

    #
    # Terrain texture
    #
    resource = config.model_texture(blend_map)
    blend_map = TerrainTexture.new(Texture.load(resource))

    return {texture_pack, blend_map}
  end

  #
  # for now we only setup 1 light source
  #
  def setup_lights()
    #
    # the sun, no attenuation
    #
    @lights << Light.new(@config.light_position(1),@config.light_color(1),@config.light_attenuation(1))

    # other lights
    @lights << Light.new(@config.light_position(2),@config.light_color(2),@config.light_attenuation(2))
    @lights << Light.new(@config.light_position(3),@config.light_color(3),@config.light_attenuation(3))
    @lights << Light.new(@config.light_position(4),@config.light_color(4),@config.light_attenuation(4))
  end

  #
  # using a blend map for our terrains
  #
  def setup_terrains()
    model_names = ["grassy","dirt","pink_flowers","path"]
    texture_pack, blend_map = texture_with_blendmap("blend_map", model_names)

    # create our terrains
    @terrains << TerrainHeightMap.new(-1f32,-2f32, texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new(-1f32,-1f32, texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new(-1f32,0f32,  texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new(-1f32,1f32,  texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new(-1f32,2f32,  texture_pack, blend_map, "res/png/heightmap.png")

    @terrains << TerrainHeightMap.new( 0f32,-2f32, texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new( 0f32,-1f32, texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new( 0f32,0f32,  texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new( 0f32,1f32,  texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new( 0f32,2f32,  texture_pack, blend_map, "res/png/heightmap.png")

    @terrains << TerrainHeightMap.new(1f32,-2f32,  texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new(1f32,-1f32,  texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new(1f32,0f32,   texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new(1f32,1f32,   texture_pack, blend_map, "res/png/heightmap.png")
    @terrains << TerrainHeightMap.new(1f32,2f32,   texture_pack, blend_map, "res/png/heightmap.png")
  end

  #
  # models with texture
  #
  def setup_models()
    @models["tree"]       = load_model_with_texture("tree",      false,false)
    @models["other_tree"] = load_model_with_texture("other_tree",false,false)
    @models["box"]        = load_model_with_texture("box",       false,false)
    @models["grass"]      = load_model_with_texture("grass",     true,true)
    @models["player"]     = load_model_with_texture("player",    false,false)
    @models["lamp"]       = load_model_with_texture("lamp",      false,false)

    #
    # using texture atlas for ferns
    #
    @models["fern"] = load_model_with_texture_atlas("fern", false,false, "res/png/fern_texture_atlas.png", 2)
  end

  #
  # the camera is following the player
  #
  def setup_third_person_camera(player : Player)
    @camera = ThirdPersonCamera.new(player)
  end

  #
  # Player entity
  #
  def setup_player(name) : Player

    position = @config.model_position(name)
    rotation = @config.model_rotation(name)
    scale    = @config.model_scale(name)

    player = Player.new( @models[name],position,rotation,scale)
    player.name = name

    return player
  end

  def get_random_pos() : GLM::Vector3

    w = 800.0f32

    rand = Random.rand(-w..w).to_f32

    # random x position
    x = rand  - w/2.0f32
    y = 0.0f32

    # random z position
    rand = Random.rand(-w..w).to_f32
    z = -rand - w/2.0f32

    position = GLM::Vector3.new(x,y,z)
    return position
  end

  def random_position_model_in_world(name : String)

    # random position
    position = get_random_pos()
    rotation = @config.model_rotation(name)
    scale    = @config.model_scale(name)

    @entities << Entity.new(@models[name],position,rotation,scale)

  end

  def setup_world_scene()

    1.upto(200) do |i|

      ["tree","other_tree","grass"]. each do |name|
        random_position_model_in_world(name)
      end

      #
      # create fern entity using texture atlas
      #
      position = get_random_pos()
      rotation = @config.model_rotation("fern")
      scale    = @config.model_scale("fern")
      random_texture_index = Random.rand(0..4).to_i

      @entities << Entity.new(@models["fern"], random_texture_index,position,rotation,scale)

    end

    # boxes
    1.upto(10) do |i|
      random_position_model_in_world("box")
    end

    # except for lamps
    adjust_height_entities()

    #
    # lamps
    # position 3 lamps using the position of light 2,3 and 4
    #
    rotation  = @config.model_rotation("lamp")
    scale     = @config.model_scale("lamp")

    lamp2 = Entity.new(@models["lamp"],@config.light_position(2),rotation,scale)
    adjust_height_entity(lamp2)

    lamp3 = Entity.new(@models["lamp"],@config.light_position(3),rotation,scale)
    adjust_height_entity(lamp3)

    lamp4 = Entity.new(@models["lamp"],@config.light_position(4),rotation,scale)
    adjust_height_entity(lamp4)

    @entities << lamp2
    @entities << lamp3
    @entities << lamp4

  end

  def adjust_height_entities()
    @entities.each do |entity|
      terrain_index = entity_in_which_terrain(@terrains,entity)

      begin
        terrain = @terrains[terrain_index]
        height = terrain.get_height_of_terrain(entity.position.x,entity.position.z)

        # adjust entity height
        entity.position.y = height
      rescue

      end
    end
  end

  def adjust_height_entity(entity : Entity)
    terrain_index = entity_in_which_terrain(@terrains,entity)

    begin
      terrain = @terrains[terrain_index]
      height = terrain.get_height_of_terrain(entity.position.x,entity.position.z)

      # adjust entity height
      entity.position.y = height
    rescue

    end
  end

  def setup_window()

    @scroll_offset = GLM::Vector2.new(0f32,0f32)
    @mouse_dx      = 0.0f32
    @mouse_dy      = 0.0f32
    #@elapsed       = 0.0f32

  end

  #
  # GUI textures
  #
  def setup_guis

    w = @config.settings.width
    h = config.settings.height

    texture_id = Texture.load("res/png/socuwan.png")
    gui = GuiTexture.new(texture_id, GLM::Vector2.new(0.5f32, 0.5f32), GLM::Vector2.new(0.25f32, 0.25f32))
    @guis << gui
  end

  #
  # example game setup
  #
  def setup

    setup_lights()
    setup_models()
    setup_terrains()

    player = setup_player("player")
    @entities << player

    setup_third_person_camera(player)
    setup_guis()
    setup_world_scene()

    setup_window()

  end

  def player_in_which_terrain(terrains : Array(Terrain), player : Player) : Int32

    position = player.position
    terrains.each_with_index do |terrain,i|

      x = terrain.x
      z = terrain.z

      if position.x >= x && position.x <= x + terrain.size
        if position.z >= z && position.z <= z + terrain.size
          return i
        end
      end

    end

    return 0
  end

  def entity_in_which_terrain(terrains : Array(Terrain), entity : Entity) : Int32

    position = entity.position
    terrains.each_with_index do |terrain,i|

      x = terrain.x
      z = terrain.z

      if position.x >= x && position.x <= x + terrain.size
        if position.z >= z && position.z <= z + terrain.size
          return i
        end
      end

    end

    return 0
  end

  def process_keys()

    #
    # close when ESCAPE key is pressed
    #
    if @window.key_pressed?(Key::Escape)
      @window.should_close
    end
  end

  #
  # processing of mouse events is
  # basic, just to make things work
  # need to be improved
  #
  def process_mouse()

    # get current time
    current_time = LibGLFW.get_time

    #
    # get the window cursor position
    #
    old_cursor_pos = @window.cursor.position

    @window.on_scroll do |event|
      @scroll_offset = GLM::Vector2.new(event.offset[:x].to_f32,event.offset[:y].to_f32)
      @scrolling     = true
      @mouse_left    = -1
      @mouse_right   = -1
    end

    #
    # reset scrolling
    #
    if @scrolling == false
      @scroll_offset = GLM::Vector2.new(0f32,0f32)
    end

    @window.on_mouse_button do |event|

      # stop scrolling
      @scrolling = false
      @scroll_offset = GLM::Vector2.new(0f32,0f32)

      mouse_button = event.mouse_button

      if event.action.press? && mouse_button.left?
        @mouse_left  = 1
        @mouse_right = -1
      end

      if event.action.press? && mouse_button.right?
        @mouse_left  = -1
        @mouse_right = 1
      end
    end

    @window.on_cursor_move do |event|

      #
      # stop scrolling
      #
      @scrolling = false
      new_cursor_pos = event.position
      @mouse_dx = (new_cursor_pos[:x] - old_cursor_pos[:x]).to_f32
      @mouse_dy = (new_cursor_pos[:y] - old_cursor_pos[:y]).to_f32
    end
  end

  def render
    #
    # gui and master renderer
    #
    settings = @config.settings

    #
    # renderers
    #
    gui_renderer    = GuiRenderer.new(settings)
    master_renderer = MasterRenderer.new(settings)

    until @window.should_close?

      CrystGLFW.poll_events

      # get current time
      last_time = LibGLFW.get_time

      process_keys()
      process_mouse()

      #
      # render the terrains
      #
      master_renderer.process_terrains(@terrains)

      @entities.each do |entity|

        #
        # move the player
        #
        if entity.name == "player"
          player = entity.as(Player)

          #
          # need to find the terrain the player is standing on
          # for now take the first terrain as test
          #
          terrain_index = player_in_which_terrain(@terrains,player)
          terrain = terrains[terrain_index]
          player.move(self,terrain)

          if @camera.is_a?(ThirdPersonCamera)
            @camera.move(self)
          end
        end

        master_renderer.process_entity(entity)
      end

      #
      # we only have 1 light (at the moment)
      #
      master_renderer.render(@lights,@camera)

      #
      # render the GUI's
      #
      gui_renderer.render(@guis)

      @window.swap_buffers
      #
      # get the current time
      #
      current_time = LibGLFW.get_time
      @@elapsed = 1.0 * (current_time - last_time)

    end

    @window.destroy

    #
    # cleanup renderers
    #
    gui_renderer.cleanup()
    master_renderer.cleanup()
  end

end

