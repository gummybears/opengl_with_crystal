module StumpyGIF::Websafe
  def self.colors
    (0...216).map do |i|
      r = (255.0 / 5 * (i % 6)).to_i
      g = (255.0 / 5 * (i // 6 % 6)).to_i
      b = (255.0 / 5 * (i // 36 % 6)).to_i

      RGBA.from_rgb_n({r, g, b}, 8)
    end
  end
end
