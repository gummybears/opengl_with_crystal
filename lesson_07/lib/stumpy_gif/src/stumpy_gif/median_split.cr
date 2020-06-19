require "set"

module StumpyGIF::MedianSplit
  def self.colors(frames : Array(Canvas))
    unique_colors = Set(RGBA).new

    frames.each do |frame|
      frame.pixels.each do |color|
        unique_colors.add(color)
      end
    end

    split(unique_colors.to_a).map do |split_colors|
      min, max = MedianSplit.min_max(split_colors)
      color = RGBA.new(
        min.r + (max.r - min.r) // 2,
        min.g + (max.g - min.g) // 2,
        min.b + (max.b - min.b) // 2,
        UInt16::MAX
      )
    end
  end

  def self.split(list : Array(RGBA), depth = 7)
    raise "Error, trying to use MedianSplit.split on an empty list" if list.empty?

    result = [] of Array(RGBA)

    min, max = min_max(list)

    delta_x = max.r - min.r
    delta_y = max.g - min.g
    delta_z = max.b - min.b

    if delta_x >= delta_y && delta_x >= delta_z
      sorted = list.sort_by { |c| c.r }
    elsif delta_y >= delta_x && delta_y >= delta_z
      sorted = list.sort_by { |c| c.g }
    else
      sorted = list.sort_by { |c| c.b }
    end

    n = list.size
    half = n // 2

    if depth == 0 || n == 2
      result << sorted[0...half]
      result << sorted[half..-1]
    elsif half == 1
      result << sorted[0...half]
      result += split(sorted[half..-1], depth - 1)
    else
      result += split(sorted[0...half], depth - 1)
      result += split(sorted[half..-1], depth - 1)
    end

    result
  end

  def self.min(v1, v2)
    v1 < v2 ? v1 : v2
  end

  def self.max(v1, v2)
    v1 > v2 ? v1 : v2
  end

  def self.min_max(list : Array(RGBA))
    initial = {
      RGBA.new(UInt16::MAX, UInt16::MAX, UInt16::MAX, UInt16::MAX),
      RGBA.new(0_u16, 0_u16, 0_u16, UInt16::MAX)
    }

    list.reduce(initial) { |current, color| min_max(color, current) }
  end

  def self.min_max(color, current)
    {
      RGBA.new(
        min(color.r, current[0].r),
        min(color.g, current[0].g),
        min(color.b, current[0].b),
        UInt16::MAX
      ),
      RGBA.new(
        max(color.r, current[1].r),
        max(color.g, current[1].g),
        max(color.b, current[1].b),
        UInt16::MAX
      )
    }
  end
end
