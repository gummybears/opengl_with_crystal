#
# projection.cr
#
#
require "./errors.cr"
require "./pair.cr"
require "./transform3.cr"
require "./transformation.cr"
require "./triple.cr"

module ASY

  class Projection

    property absolute      : Bool = false
    property infinity      : Bool = false

    # Adjust camera to lie outside bounding volume ?
    property autoadjust    : Bool = true

    # Center target within bounding volume ?
    property center        : Bool = false

    # Typeset label bounding box only
    property bboxonly      : Bool = true

    # Expand bounding volume to include target ?
    property showtarget    : Bool = true

    # Zoom factor
    property zoom          : Float64 = 1.0

    # Lens angle (for perspective projection)
    property angle         : Float64 = 0.0

    # Fractional viewport shift
    property viewportshift : ASY::Pair = ASY::Pair.new

    # A vector that should be projected to direction (0,1)
    property up            : Triple = ASY::Triple.new

    # Position of camera
    property camera        : Triple = ASY::Triple.new

    # Normal vector from target to projection plane
    property normal        : Triple = ASY::Triple.new

    # Point where camera is looking at
    property target        : Triple = ASY::Triple.new

    # projection * modelview transform matrices
    property transform3     : Transform3     = ASY::Transform3.new
    property transformation : Transformation = ASY::Transformation.new

    # Used for projecting nurbs to 2D Bezier curves
    property n_interpolate  : Int32 = 1

    def initialize
      @transformation = ASY::Transformation.new
    end

    def initialize(
                  transformation : ASY::Transformation,
                  camera         : ASY::Triple,
                  up             : ASY::Triple = ASY::Z,
                  target         : ASY::Triple = ASY::O3,
                  zoom           : Float64     = 1.0,
                  angle          : Float64     = 0.0,
                  viewportshift  : ASY::Pair   = ASY::Pair.new(0,0),
                  showtarget     : Bool        = true,
                  autoadjust     : Bool        = true,
                  center         : Bool        = false
                  )

      @camera        = camera
      @up            = up
      @target        = target
      @normal        = camera - target

      @zoom          = zoom
      @angle         = angle

      @viewportshift = viewportshift

      @showtarget    = showtarget
      @autoadjust    = autoadjust
      @center        = center

      #
      # need to fill in the transformation object
      # this object holds the modelview and projection matrix
      #
      @transformation = transformation
      @transform3     = @transformation.compute()
      @infinity       = @transformation.infinity

      @n_interpolate = 1
      if @infinity == false
        @n_interpolate = 16
      end

    end

    def calculate()
      @transform3   = @transformation.compute()
      @infinity     = @transformation.infinity

      @n_interpolate = 1
      if @infinity == false
        @n_interpolate = 16
      end

    end

    #
    # returns the transformation
    #
    def get_transformation() : ASY::Transformation
      @transformation
    end

    #
    # returns the modelview matrix of the projection
    #
    def get_modelview() : ASY::Transform3
      @transformation.get_modelview()
    end

    #
    # returns the 3D transform
    #
    def get_transform3() : ASY::Transform3
      @transform3
    end

    #
    # returns the vector pointing from the camera to the target
    #
    def vector() : ASY::Triple
      r = @camera - @target
      return r
    end

  end
end
