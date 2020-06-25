require "../core/model_data/model_data.cr"

def model_matrix(position : GLM::Vec3, scale : GLM::Vec3, rotX,rotY,rotZ : Float32) : GLM::Mat4
  trans  = GLM.translate(position)
  rotate = GLM.rotation(GLM.vec3(rotX,rotY,rotZ))
  scale  = GLM.scale(scale)

  r = trans * rotate * scale
  return r
end

data = ModelData.terrain(0,0,2,800)

x = 0.0
y = -15.0
z = 3.0

camera = GLM::Vec3.new(x,y,z)
width  = 1920.0f32
height = 1080.0f32
fov    = 90.0f32
near   = 0.1f32
far    = 100.0f32
aspect_ratio = (width/height).to_f32

projection = GLM.perspective(fov,aspect_ratio,near, far)
puts "projection"
puts projection.to_s

view  = GLM.translate(camera)
puts "view"
puts view.to_s

model = model_matrix(GLM::Vec3.new(0,0,0),GLM::Vec3.new(0,0,0),0,0,0)
puts "model"
puts model.to_s

pvm = projection * view * model #* GLM::Vec4.new(0,0,0,1)
puts "pvm = projection * view * model"
puts pvm.to_s
