#
# face_element.cr
#
module WaveFront

  class FaceElement
    property vi     : Int32 = NOINDEX
    property vti    : Int32 = NOINDEX
    property vni    : Int32 = NOINDEX
    property is_set : Bool = false

    def initialize
    end

    def initialize(vi : Int32,vti : Int32,vni : Int32)
      @vi  = vi
      @vti = vti
      @vni = vni

      @is_set = false
      if vti != NOINDEX && vni != NOINDEX
        @is_set = true
      end
    end

    def is_set?
      @is_set
    end

  end
end
