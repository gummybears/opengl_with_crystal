#
# face.cr
#
require "./face_element.cr"

module WaveFront
  class Face
    property elements : Array(WaveFront::FaceElement)

    def initialize
      @elements = [] of WaveFront::FaceElement
    end

    def initialize(elements : Array(WaveFront::FaceElement))
      @elements = elements
    end
  end
end
