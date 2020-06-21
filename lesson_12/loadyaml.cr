require "yaml"

x = YAML.parse(File.read("scene.yml"))
title = x["display"]["screen"]["title"]
width = x["display"]["screen"]["width"]

puts title
puts width
puts

#camera = x["display"]["camera"]
#puts camera
entities = x["objects"] #["model1"]
puts entities.size
