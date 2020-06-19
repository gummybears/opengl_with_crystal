#
# angle.cr
#
#
require "./aliastype.cr"

def radians(theta : Float32) : Float32
  r = theta * Math::PI/180.0
  return r.to_f32
end

def degrees(theta : Float32) : Float32
  r = theta * 180.0/Math::PI
  return r.to_f32
end

