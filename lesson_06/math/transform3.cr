#
# transform3.cr
#
#
require "./aliastype.cr"
require "./for_macro.cr"
require "./vector.cr"
require "./projection.cr"

module ASY
  class Transform3

    property t : Array(Array(Float64))

    def allocate() : Array(Array(Float64))
      dim = 4
      @t = Array.new(dim) do |i|
        Array.new(dim) do |j|
          0.0
        end
      end
    end

    def initialize
      @t = allocate()

      @t[0][0] = 1.0
      @t[0][1] = 0.0
      @t[0][2] = 0.0
      @t[0][3] = 0.0

      @t[1][0] = 0.0
      @t[1][1] = 1.0
      @t[1][2] = 0.0
      @t[1][3] = 0.0

      @t[2][0] = 0.0
      @t[2][1] = 0.0
      @t[2][2] = 1.0
      @t[2][3] = 0.0

      @t[3][0] = 0.0
      @t[3][1] = 0.0
      @t[3][2] = 0.0
      @t[3][3] = 1.0
    end

    #
    # added 21-03-2020
    #
    def initialize(t : Array(Array(Float64)) )
      @t = t.dup
    end

    def identity4() : Transform3
      trans = Transform3.new
      return trans
    end

    def get_transform3()
      return @t
    end

    # Transform3 = Transform3 * Transform3
    def *(other : Transform3) : Transform3
      localt = Transform3.new
      localt = Transform3.new
      for i = 0, i < 4, i = i + 1 do
        for j = 0, j < 4, j = j + 1 do
          localt.t[i][j] = 0.0
        end
      end

      for i = 0, i < 4, i = i + 1 do
        for j = 0, j < 4, j = j + 1 do
          for k = 0, k < 4, k = k + 1 do
            localt.t[i][j] = localt.t[i][j] + @t[i][k] * other.t[k][j]
          end
        end
      end

      return localt
    end

    # Array(Array(Float64)) = Transform3 * Array(Array(Float64))
    def *(other : Array(Array(Float32)) ) : Array(Array(Float32))
      localt = Transform3.new
      for i = 0, i < 4, i = i + 1 do
        for j = 0, j < 4, j = j + 1 do
          localt.t[i][j] = 0.0
        end
      end

      for i = 0, i < 4, i = i + 1 do
        for j = 0, j < 4, j = j + 1 do
          for k = 0, k < 4, k = k + 1 do
            # note : other is an array
            localt.t[i][j] = localt.t[i][j] + @t[i][k] * other[k][j]
          end
        end
      end

      # return array
      return localt.t
    end

    # Array(Array(Float64)) = Transform3 * Array(Array(Float64))
    def *(other : ASY::Matrix ) : ASY::Matrix
      localt = Transform3.new
      for i = 0, i < 4, i = i + 1 do
        for j = 0, j < 4, j = j + 1 do
          localt.t[i][j] = 0.0
        end
      end

      for i = 0, i < 4, i = i + 1 do
        for j = 0, j < 4, j = j + 1 do
          for k = 0, k < 4, k = k + 1 do
            # note : other is a matrix
            localt.t[i][j] = localt.t[i][j] + @t[i][k] * other[k,j]
          end
        end
      end

      # return matrix
      r = ASY::Matrix.new(localt.t)
      return r
    end

    #
    # applies the operation Transform3 * Triple => Triple
    #
    def * (z : Triple) : Triple
      x = @t[0][0] * z.x + @t[0][1] * z.y + @t[0][2] * z.z + @t[0][3] * 1.0
      y = @t[1][0] * z.x + @t[1][1] * z.y + @t[1][2] * z.z + @t[1][3] * 1.0
      z = @t[2][0] * z.x + @t[2][1] * z.y + @t[2][2] * z.z + @t[2][3] * 1.0
      return Triple.new(x,y,z)
    end


    #def * (f : Four) : Four
    #  x = @t[0][0] * f.x + @t[0][1] * f.y + @t[0][2] * f.z + @t[0][3] * f.w
    #  y = @t[1][0] * f.x + @t[1][1] * f.y + @t[1][2] * f.z + @t[1][3] * f.w
    #  z = @t[2][0] * f.x + @t[2][1] * f.y + @t[2][2] * f.z + @t[2][3] * f.w
    #  w = @t[3][0] * f.x + @t[3][1] * f.y + @t[3][2] * f.z + @t[3][3] * f.w
    #  return Four.new(x,y,z,w)
    #end

    #
    # applies the operation Transform3 * Projection => Transform3
    #
    def *(other : ASY::Projection) : ASY::Projection

      transform3 = self
      proj       = other

      if proj.absolute == false
        proj.camera = transform3 * proj.camera
        target      = proj.target
        proj.target = transform3 * proj.target

        if proj.infinity
          proj.normal = transform3 * ( target + proj.normal) - proj.target
        else
          proj.normal = other.vector()
        end

        proj.calculate()
      end

      return proj
    end

    ## rotate, shift, slant, scale Label's in 3D
    #def * (other : Label) : Label
    #
    #  transformed_label = other
    #  transformed_label.align.dir3 = other.align.dir3
    #  transformed_label.transform3(self * other.transform3)
    #
    #  return transformed_label
    #end

    ## rotate, shift, slant, scale patches
    #def * (other : Patch) : Patch
    #  patch = other.clone()
    #  for i = 0, i < rows(other.points), i = i + 1 do
    #    for j = 0, j < cols(other.points), j = j + 1 do
    #      patch.points[i][j] = self * other.points[i][j]
    #    end
    #  end
    #
    #  new_patch = ASY::Patch.new(patch.points)
    #  new_patch.planar     = other.planar
    #  new_patch.straight   = other.straight
    #  new_patch.triangular = other.triangular
    #
    #  return new_patch
    #end

    ## rotate, shift, slant, scale surfaces
    #def * (other : Surface) : Surface
    #
    #  new_patches = [] of Patch
    #
    #  for i = 0, i < other.patches.size(), i = i + 1 do
    #    other_patch = other.patches[i].clone()
    #
    #    new_patch = self * other_patch
    #    new_patch.planar     = other_patch.planar
    #    new_patch.straight   = other_patch.straight
    #    new_patch.triangular = other_patch.triangular
    #    new_patches << new_patch
    #  end
    #
    #  s = Surface.new(new_patches)
    #  return s
    #end

    ## rotate, shift, slant, scale lights
    #def * (other : Light) : Light
    #
    #  l = Light.new(other)
    #  if l.viewport == false
    #    for i = 0, i < cols(l.position), i = i + 1 do
    #      l.position[i] = shiftless3(self) * l.position[i]
    #    end
    #  end
    #
    #  return l
    #end

    ## Applies a transformation to the path3
    #def transformed(t : Transform3, p : Path3) : Path3
    #
    #  knots = [] of Knot3
    #  n = p.size()
    #
    #  (0..n-1).each do |i|
    #    pre      = t * p.precontrol(i)
    #    point    = t * p.point(i)
    #    post     = t * p.postcontrol(i)
    #    straight = p.straight(i)
    #    knot     = Knot3.new(point,pre,post,straight)
    #    knots << knot
    #  end
    #
    #  p = Path3.new(knots,n,p.cyclic)
    #  return p
    #end

    ## operator *
    ## Path3 = (transform * Path3)
    ##
    ## where transform :
    ##
    ## shift
    ## scale
    ## xscale
    ## yscale
    ## rotate
    ## shiftless
    ## etc.
    ##
    #def * (other : Path3) : Path3
    #  t = self
    #  q = transformed(t,other)
    #  return q
    #end

    ##
    ## transform3 of revolution
    ##
    #def * (other : ASY::Revolution) : ASY::Revolution
    #  t = self
    #
    #  newcenter = t * other.center
    #  newpath3  = t * other.path
    #  newaxis   = t * ( other.center + other.axis ) - newcenter
    #
    #  r = ASY::Revolution.new(newcenter, newpath3, newaxis, other.angle1,other.angle2)
    #  return r
    #end

    def print(text : String = "", precision : Int32 = 2,with_row : Bool = false)
      if text != ""
        puts
        puts text
      end
      print(@t,precision,with_row)
    end
  end
end
