class Model
end

class Entity
  property s : String
  def initialize(s : String)
    @s = s
  end
end

class Entities
  property list : Array(Entity)

  def initialize
    @list = [] of Entity
  end

  def add(e : Entity)
    @list << e
  end
end

entities1 = [] of Entity
entities1 << Entity.new("0")
entities1 << Entity.new("1")
entities1 << Entity.new("2")

entities2 = [] of Entity
entities2 << Entity.new("1")
entities2 << Entity.new("2")
entities2 << Entity.new("3")

#h = Hash(Model,Entities).new
h = Hash(String,Array(Entity)).new
h["model1"] = entities1
h["model2"] = entities2

h.each do |key,value|
  puts key
  list = value
  list.each do |e|
    puts e.s
  end

end
