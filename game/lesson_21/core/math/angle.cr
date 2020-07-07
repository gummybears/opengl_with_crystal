#
# angle.cr
#
require "./alias.cr"
require "../misc/errors.cr"

module GLM

  def self.radians(theta : Real) : Float32
    r = theta * Math::PI/180.0
    r.to_f32
  end

  def self.degrees(theta : Real) : Float32
    r = theta * 180.0/Math::PI
    r.to_f32
  end

  # Wrapper for atan2 with sensible (lexical) argument order and (0,0) check
  def self.angle(x : Real, y : Real) : Float32
    if (x == 0.0 && y == 0.0)
      report_error("taking angle of (0,0)")
      return 0f32
    end

    return atan2(y, x)
  end

  # Return an angle in the interval [0,360).
  def self.principal_branch(theta : Real ) : Float32
    if theta < 0.0
      theta = theta + 360.0
    end

    return theta
  end

  def self.nice_angle(z : Vector2) : Float32
    if z.y == 0.0
      if z.x >= 0.0
        return 0.0
      else
        return PI
      end
    end

    return atan2(z.y,z.x)
  end

  # Ensures an angle is in the range between -PI and PI
  def self.reduce_angle(angle : Float32) : Float32
    if angle > PI
      return angle - 2.0 * PI
    end

    if angle < -PI
      return angle + 2.0 * PI
    end

    return angle
  end

end
