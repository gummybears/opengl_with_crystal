#
# transformation.cr
#
#
require "./errors.cr"
require "./transform3.cr"

module ASY
  class Transformation
    property infinity : Bool

    #
    # For orientation and positioning
    #
    # modelview is computed via either the lookup or distort method
    #
    property modelview  : Transform3

    # For 3D to 2D projection
    property projection : Transform3

    def initialize
      @projection = Transform3.new
      @modelview  = Transform3.new
      @infinity   = false
    end

    def initialize(modelview : ASY::Transform3)
      @modelview  = modelview
      @projection = Transform3.new
      @infinity   = true
    end

    def initialize(modelview, projection : ASY::Transform3)
      @modelview  = modelview
      @projection = projection
      @infinity   = false
    end

    def get_modelview() : Transform3
      @modelview
    end

    def get_projection() : Transform3
      @projection
    end

    def compute() : Transform3
      r = @modelview
      if @infinity
        return r
      end

      r = @projection * @modelview
      return r
    end
  end
end
