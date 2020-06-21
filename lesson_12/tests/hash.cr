class Model
end

class Entity
end

class Entities
end
entities = [] of Entity
entities << Entity.new
entities << Entity.new

h = Hash(Model,Entities).new
