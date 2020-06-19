#
# api_transform3.cr
#
#
require "./errors.cr"
require "./transform3.cr"

def _XY() : ASY::Transform3
  t = ASY::Transform3.new
  return t
end

def _YX() : ASY::Transform3
  return rotate3(-90.0,ASY::Triple.new(0,0,0),ASY::Triple.new(0,0,1))
end

def _YZ() : ASY::Transform3
  return rotate3(90.0,ASY::Triple.new(0,0,0),ASY::Z) * rotate3(90,ASY::Triple.new(0,0,0),ASY::X)
end

def _ZY() : ASY::Transform3
  return rotate3(-90.0,ASY::Triple.new(0,0,0),ASY::X) * _YZ()
end

def _ZX() : ASY::Transform3
  return rotate3(-90.0,ASY::Triple.new(0,0,0),ASY::Z) * rotate3(-90.0,ASY::Triple.new(0,0,0),ASY::Y)
end

def _XZ() : ASY::Transform3
  return rotate3(-90.0,ASY::Triple.new(0,0,0),ASY::Y) * _ZX()
end

def shift3(x : Real,y : Real,z : Real) : ASY::Transform3
  t = ASY::Transform3.new

  t.t[0][3] = 1.0 * x
  t.t[1][3] = 1.0 * y
  t.t[2][3] = 1.0 * z

  return t
end

def shift3(p : ASY::Triple) : ASY::Transform3
  t = ASY::Transform3.new
  t.t[0][3] = 1.0 * p.x
  t.t[1][3] = 1.0 * p.y
  t.t[2][3] = 1.0 * p.z
  return t
end

def xscale3(s : Real) : ASY::Transform3
  t = ASY::Transform3.new
  t.t[0][0] = 1.0 * s
  return t
end

def yscale3(s : Real) : ASY::Transform3
  t = ASY::Transform3.new
  t.t[1][1] = 1.0 * s
  return t
end

def zscale3(s : Real) : ASY::Transform3
  t = ASY::Transform3.new
  t.t[2][2] = 1.0 * s
  return t
end

# scaling of a 3d triple
def scale3(s : Real) : ASY::Transform3
  t = ASY::Transform3.new

  t.t[0][0] = 1.0 * s
  t.t[1][1] = 1.0 * s
  t.t[2][2] = 1.0 * s

  return t
end

def scale3(x,y,z : Real) : ASY::Transform3
  t = ASY::Transform3.new

  t.t[0][0] = 1.0 * x
  t.t[1][1] = 1.0 * y
  t.t[2][2] = 1.0 * z

  return t
end

def scale3(point : ASY::Triple) : ASY::Transform3
  t = ASY::Transform3.new

  t.t[0][0] = 1.0 * point.x
  t.t[1][1] = 1.0 * point.y
  t.t[2][2] = 1.0 * point.z

  return t
end

# A transformation representing rotation by an angle in degrees about
# an axis v through the origin (in the right-handed direction).
#
#  {t*x^2+c,   t*x*y-s*z, t*x*z+s*y, 0},
#  {t*x*y+s*z, t*y^2+c,   t*y*z-s*x, 0},
#  {t*x*z-s*y, t*y*z+s*x, t*z^2+c,   0},
#  {0,         0,         0,         1}}

def rotate3(angle : Float32, v : ASY::Triple) : ASY::Transform3

  t = ASY::Transform3.new

  if v == ASY::Triple.new(0,0,0)
    report_error("cannot rotate about the zero vector")
  end

  v    = unit(v)
  lv_x = v.x
  lv_y = v.y
  lv_z = v.z

  lv_s = Math.sin(radians(1.0f32 * angle))
  lv_c = Math.cos(radians(1.0f32 * angle))
  lv_t = 1.0 - lv_c

  # {t*x^2+c,   t*x*y-s*z, t*x*z+s*y, 0},
  t.t[0][0] = lv_t * (lv_x * lv_x) + lv_c
  t.t[0][1] = lv_t * (lv_x * lv_y) - lv_s * lv_z
  t.t[0][2] = lv_t * (lv_x * lv_z) + lv_s * lv_y
  t.t[0][3] = 0.0

  # {t*x*y+s*z, t*y^2+c,   t*y*z-s*x, 0},
  t.t[1][0] = lv_t * (lv_x * lv_y) + lv_s * lv_z
  t.t[1][1] = lv_t * (lv_y * lv_y) + lv_c
  t.t[1][2] = lv_t * (lv_y * lv_z) - lv_s * lv_x
  t.t[1][3] = 0.0

  # {t*x*z-s*y, t*y*z+s*x, t*z^2+c,   0},
  t.t[2][0] = lv_t * (lv_x * lv_z) - lv_s * lv_y
  t.t[2][1] = lv_t * (lv_y * lv_z) + lv_s * lv_x
  t.t[2][2] = lv_t * (lv_z * lv_z) + lv_c
  t.t[2][3] = 0.0

  #  {0,         0,         0,         1}}
  t.t[3][0] = 0.0
  t.t[3][1] = 0.0
  t.t[3][2] = 0.0
  t.t[3][3] = 1.0

  return t
end

def rotate3(angle : Real, u,v : ASY::Triple) : ASY::Transform3
  w = scale3(-1.0) * u
  return shift3(u)*rotate3(angle, v-u)*shift3(w)
end

def reflect3(u,v,w : ASY::Triple) : ASY::Transform3

  n = unit(cross(v-u, w-u))
  if n == ASY::Triple.new(0,0,0)
    report_error("points determining reflection plane cannot be colinear")
  end

  t = ASY::Transform3.new
  t.t[0][0] = 1.0 - 2.0 * n.x * n.x
  t.t[0][1] =     - 2.0 * n.x * n.y
  t.t[0][2] =     - 2.0 * n.x * n.z
  t.t[0][3] = 1.0 * u.x

  t.t[1][0] =     - 2.0 * n.x * n.y
  t.t[1][1] = 1.0 - 2.0 * n.y * n.y
  t.t[1][2] =     - 2.0 * n.y * n.z
  t.t[1][3] = 1.0 * u.y

  t.t[2][0] =     - 2.0 * n.x * n.z
  t.t[2][1] =     - 2.0 * n.y * n.z
  t.t[2][2] = 1.0 - 2.0 * n.z * n.z
  t.t[2][3] = 1.0 * u.z

  t.t[3][0] = 0.0
  t.t[3][1] = 0.0
  t.t[3][2] = 0.0
  t.t[3][3] = 1.0

  s = scale3(-1.0) * u
  r = t * shift3(s)
  return r
end

def shiftless3(t : ASY::Transform3) : ASY::Transform3

  r = ASY::Transform3.new
  r.t[0][0] = t.t[0][0]
  r.t[0][1] = t.t[0][1]
  r.t[0][2] = t.t[0][2]
  r.t[0][3] = t.t[0][3]

  r.t[1][0] = t.t[1][0]
  r.t[1][1] = t.t[1][1]
  r.t[1][2] = t.t[1][2]
  r.t[1][3] = t.t[1][3]

  r.t[2][0] = t.t[2][0]
  r.t[2][1] = t.t[2][1]
  r.t[2][2] = t.t[2][2]
  r.t[2][3] = t.t[2][3]

  r.t[3][0] = t.t[3][0]
  r.t[3][1] = t.t[3][1]
  r.t[3][2] = t.t[3][2]
  r.t[3][3] = t.t[3][3]

  #
  # t[0][3] = t[1][3] = t[2][3] = 0
  #
  r.t[0][3] = 0.0
  r.t[1][3] = 0.0
  r.t[2][3] = 0.0
  return r

end

def transpose(t : ASY::Transform3) : ASY::Transform3

  r = ASY::Transform3.new
  r.t[0][0] = t.t[0][0]
  r.t[0][1] = t.t[1][0]
  r.t[0][2] = t.t[2][0]
  r.t[0][3] = t.t[3][0]

  r.t[1][0] = t.t[0][1]
  r.t[1][1] = t.t[1][1]
  r.t[1][2] = t.t[2][1]
  r.t[1][3] = t.t[3][1]

  r.t[2][0] = t.t[0][2]
  r.t[2][1] = t.t[1][2]
  r.t[2][2] = t.t[2][2]
  r.t[2][3] = t.t[3][2]

  r.t[3][0] = t.t[0][3]
  r.t[3][1] = t.t[1][3]
  r.t[3][2] = t.t[2][3]
  r.t[3][3] = t.t[3][3]

  return r
end

# computes the modelview transformation corresponding to moving the camera from the target
# (looking in the negative z direction) to the point 'eye' (looking at target),
# orienting the camera so that direction 'up' points upwards.
# Since, in actuality, we are transforming the points instead of the camera,
# we calculate the inverse matrix.

# the method look computes the modelview matrix
# needed for orthographic projections

def look(eye : ASY::Triple, up : ASY::Triple = Z, target : ASY::Triple = O3) : ASY::Transform3

  # construct camera coordinates
  # f is the vector from the camera to the target
  #
  f = unit(target - eye)

  # if f is O, the camera is at the origin
  # The eye is already at the origin: look down
  #

  if f == ASY::Triple.new(0,0,0)
    #
    # make the camera look down
    #
    f = scale3(-1.0) * ASY::Z
  end

  s = cross(f, ASY::Z)

  #
  # If the eye is pointing either directly up or down, there is no
  # preferred "up" direction.  Pick one arbitrarily
  #
  if s != ASY::Triple.new(0,0,0)
    s = unit(s)
  else
    s = perp(f)
  end

  u = cross(s, f)

  transform3 = ASY::Transform3.new
  transform3.t[0][0] = 1.0 * s.x
  transform3.t[0][1] = 1.0 * s.y
  transform3.t[0][2] = 1.0 * s.z
  transform3.t[0][3] = 0.0

  transform3.t[1][0] = 1.0 * u.x
  transform3.t[1][1] = 1.0 * u.y
  transform3.t[1][2] = 1.0 * u.z
  transform3.t[1][3] = 0.0

  transform3.t[2][0] = -1.0 * f.x
  transform3.t[2][1] = -1.0 * f.y
  transform3.t[2][2] = -1.0 * f.z
  transform3.t[2][3] = 0.0

  transform3.t[3][0] = 0.0
  transform3.t[3][1] = 0.0
  transform3.t[3][2] = 0.0
  transform3.t[3][3] = 1.0

  r = transform3 * shift3(scale3(-1.0) * eye)
  return r
end

#
# used by perspective projections
# returns a matrix to do perspective distortion based on a triple v
#
def distort(v : ASY::Triple) : ASY::Transform3

  transform3 = ASY::Transform3.new
  d = length(v)
  if d == 0.0
    return transform3
  end

  transform3.t[3][2] = -1.0/d
  transform3.t[3][3] = 0.0
  return transform3

end

def inverse_transform3(arr : Array(Array(Float64)) ) : ASY::Transform3
  if arr.size != 4
    report_error("given array not a 4x4 matrix")
  end

  r = ASY::Transform3.new
  m = inverse(arr)

  (0..rows(m)-1).each do |i|
    (0..cols(m)-1).each do |j|
      r.t[i][j] = m[i][j]
    end
  end

  return r
end

def inverse_transform3(transform : ASY::Transform3) : ASY::Transform3

  arr = transform.t
  if arr.size != 4
    report_error("given array not a 4x4 matrix")
  end

  r = ASY::Transform3.new
  m = inverse(arr)

  (0..rows(m)-1).each do |i|
    (0..cols(m)-1).each do |j|
      r.t[i][j] = m[i][j]
    end
  end

  return r
end

def inverse_array(arr : Array(Array(Float64)) ) : Array(Array(Float64))
  if arr.size != 4
    report_error("given array not a 4x4 matrix")
  end

  dim = 4
  r   = Array.new(dim) { Array.new(dim) {0.0}}
  m   = inverse(arr)

  (0..rows(m)-1).each do |i|
    (0..cols(m)-1).each do |j|
      r[i][j] = m[i][j]
    end
  end

  return r
end

# return the rotation that maps Z to a unit vector u about cross(u,Z)
def align(u : ASY::Triple) : ASY::Transform3

  a = 1.0 * u.x
  b = 1.0 * u.y
  c = 1.0 * u.z
  d = a * a + b * b

  t = ASY::Transform3.new

  if d != 0
    d = sqrt(d)
    e = 1.0/d

    t.t[0][0] = -b * e
    t.t[0][1] = -a * c * e
    t.t[0][2] = a
    t.t[0][3] = 0.0

    t.t[1][0] = a * e
    t.t[1][1] = -b * c * e
    t.t[1][2] = b
    t.t[1][3] = 0.0

    t.t[2][0] = 0.0
    t.t[2][1] = d
    t.t[2][2] = c
    t.t[2][3] = 0.0

    t.t[3][0] = 0.0
    t.t[3][1] = 0.0
    t.t[3][2] = 0.0
    t.t[3][3] = 1.0

    return t
  end

  # return the identity matrix
  if c >= 0
    return ASY::Transform3.new
  end

  # return the diagonal (1,-1,-1,1)

  t.t[0][0] =  1.0
  t.t[0][1] =  0.0
  t.t[0][2] =  0.0
  t.t[0][3] =  0.0

  t.t[1][0] =  0.0
  t.t[1][1] = -1.0
  t.t[1][2] =  0.0
  t.t[1][3] =  0.0

  t.t[2][0] =  0.0
  t.t[2][1] =  0.0
  t.t[2][2] = -1.0
  t.t[2][3] =  0.0

  t.t[3][0] =  0.0
  t.t[3][1] =  0.0
  t.t[3][2] =  0.0
  t.t[3][3] =  1.0

  return t
end

#
# returns a transform3 that projects in the direction 'dir' onto the plane
# with normal 'n' through point 'o'
#
def planeproject(n : ASY::Triple, o : ASY::Triple, dir : ASY::Triple) : ASY::Transform3

  t     = ASY::Transform3.new

  a     = n.x
  b     = n.y
  c     = n.z
  u     = dir.x
  v     = dir.y
  w     = dir.z
  delta = (1.0/(((a*u)+(b*v))+(c*w)))
  d     = ((-1.0*(((a*o.x)+(b*o.y))+(c*o.z)))*delta)

  t.t[0][0] = (( b * v ) +( c * w )) * delta
  t.t[0][1] = ((-1.0 * b) * u) * delta
  t.t[0][2] = ((-1.0 * c) * u) * delta
  t.t[0][3] = (-1.0 * d) * u
  t.t[1][0] = ((-1.0 * a) * v) * delta
  t.t[1][1] = (a * u + c * w) * delta
  t.t[1][2] = ((-1.0 * c) * v) * delta
  t.t[1][3] = -1.0 * d * v
  t.t[2][0] = ((-1.0 * a) * w) * delta
  t.t[2][1] = ((-1.0 * b) * w) * delta
  t.t[2][2] = (a * u + b * v) * delta
  t.t[2][3] = -1.0 * d * w
  t.t[3][0] = 0.0
  t.t[3][1] = 0.0
  t.t[3][2] = 0.0
  t.t[3][3] = 1.0

  return t
end

#
# a transform3 that projects in the direction 'dir' onto the plane
# defined by a planar path 'p' is returned by the next method
#
def planeproject(p : ASY::Path3, dir : ASY::Triple = ASY::Triple.new(0,0,0)) : ASY::Transform3

  t = ASY::Transform3.new
  n = normal(p)
  if dir == ASY::Triple.new(0,0,0)
    t = planeproject(n,point(p,0.0),n)
    return t
  else
    t = planeproject(n,point(p,0.0),dir)
    return t
  end

  return t
end
