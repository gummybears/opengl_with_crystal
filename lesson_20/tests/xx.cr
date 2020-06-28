require "./core/math/**"

width  = 1920.0f32
height = 1080.0f32
fov    = 90.0f32
near   = 1.0f32
far    = 1001.0f32
aspect_ratio = (width/height).to_f32
perp = GLM.perspective(fov,aspect_ratio,near, far)

puts "perp"
puts perp.to_s


vec4 = GLM::Vec4.new(0,-10,1,0)
puts vec4.to_s

a = perp * vec4
puts a.to_s
