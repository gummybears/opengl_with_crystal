#
# misc.cr
#

module GLM

  #
  # Calculates the barry centric weight for a point between 3 vertices
  #
  def self.barry_centric_weight(p1 : Vector3, p2 : Vector3, p3 : Vector3, pos : Vector2) : Float32
    det = (p2.z - p3.z) * (p1.x - p3.x) + (p3.x - p2.x) * (p1.z - p3.z)
    l1  = ((p2.z - p3.z) * (pos.x - p3.x) + (p3.x - p2.x) * (pos.y - p3.z)) / det
    l2  = ((p3.z - p1.z) * (pos.x - p3.x) + (p1.x - p3.x) * (pos.y - p3.z)) / det
    l3  = 1.0f32 - l1 - l2

    r   = l1 * p1.y + l2 * p2.y + l3 * p3.y
    return r
  end
end
