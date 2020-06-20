require "../loader/obj.cr"
obj = OBJ.new
obj.open("../models/cube3.obj")
puts "obj normals #{obj.normals.size}"
puts "obj vertices #{obj.vertices.size}"
puts "obj texture_coordinates #{obj.texture_coordinates.size}"
puts "obj faces #{obj.faces.size}"

obj.to_a

puts "vertices (#{obj.vertices_arr.size})"
puts obj.vertices_arr
puts "indices (#{obj.indices_arr.size})"
puts obj.indices_arr
puts "textures (#{obj.textures_arr.size})"
puts obj.textures_arr
