require "yaml"

x = YAML.parse(File.read("scene.yml"))
title = x["display"]["screen"]["title"]
width = x["display"]["screen"]["width"]

puts title
puts width
puts

#camera = x["display"]["camera"]
#puts camera
entity = x["entities"]["dragon"]
puts entity
#puts entities.size
#entities.to_a.each do |x|
#  puts x
#end
#(0..entities.size-1).each do |i|
#  x = entities[i]
#  puts x
#end
