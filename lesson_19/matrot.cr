require "./core/camera.cr"
def mat1(camera : Camera)

  matrix = GLM::Mat4.identity()
  x_axis = GLM::Vec3.new(1,0,0)
  y_axis = GLM::Vec3.new(0,1,0)
  pitch  = camera.pitch
  yaw    = camera.yaw

  pitch_radians = GLM.radians(pitch)
  yaw_radians   = GLM.radians(yaw)

  matrix = GLM.rotate(matrix, pitch_radians, x_axis)

  matrix = GLM.rotate(matrix, yaw_radians, y_axis)

end

camera = Camera.new(
