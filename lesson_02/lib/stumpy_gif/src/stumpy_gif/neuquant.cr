module StumpyGIF
  class NeuQuant
    property table : Slice(NeuQuantEntry)

    def initialize(frames)
      # assume all frames have the same size
      n = frames.first.pixels.size

      # find a prime number close to 500 that is not a factor of n
      prime = [487, 491, 499, 503].find { |p| n % p != 0 }

      # this can only happen if n is a multiple of 60017649649
      # which is pretty unlikely
      raise "Error, could not find a fitting prime" if prime.nil?

      @table = Slice.new(256) { |i| NeuQuantEntry.new(i.to_f, i.to_f, i.to_f) }
      @iteration = 0
      current = 0
      offset = 0

      100.times do
        frames.each do |frame|
          offset = 0
          5.times do
            current = offset
            while current < n
              pixel = frame.pixels[current]
              current += prime
              train(pixel)
            end
            offset += 1
          end
        end
        @iteration += 1
      end
    end

    def train(pixel)
      i = @table.each_with_index.min_by { |e, i| e.distance(pixel) }[1]
      @table.each_with_index { |e, j| e.update_bias(j == i) }

      r = radius
      from = {0, i - r}.max
      to = {255, i + r}.min

      (from..to).each do |j|
        @table[j].update_values(pixel, alpha * rho(i, j, r))
      end
    end

    def alpha
      Math::E ** (-0.03 * @iteration)
    end

    def radius
      (32.0 * Math::E ** (-0.0325 * @iteration)).to_i
    end

    def rho(i, j, r)
      return 1.0 if i == j
      1.0 - ((i - j).abs.to_f / r.floor) ** 2
    end

    def colors
      @table.map do |entry|
        RGBA.new(
          (entry.r * 256).to_u16,
          (entry.g * 256).to_u16,
          (entry.b * 256).to_u16,
          UInt16::MAX
        )
      end
    end
  end

  class NeuQuantEntry
    property r : Float64
    property g : Float64
    property b : Float64

    property bias : Float64
    property frequency : Float64

    BETA = 1.0 / 1024
    GAMMA = 1024.0

    def initialize(@r, @g, @b)
      @frequency = 1.0 / 256
      @bias = 0.0
    end

    def distance(pixel)
      r, g, b = pixel.to_rgb8
      (@r - r).abs + (@g - g).abs + (@b - b).abs - bias
    end

    def update_values(pixel, factor)
      r, g, b = pixel.to_rgb8

      @r = factor * r + (1 - factor) * @r
      @g = factor * g + (1 - factor) * @g
      @b = factor * b + (1 - factor) * @b
    end

    def update_bias(closest)
      if closest
        @bias = @bias + @frequency - 1
        @frequency = @frequency - BETA * @frequency + BETA
      else
        @bias = @bias + @frequency
        @frequency = @frequency - BETA * @frequency
      end
    end
  end
end
