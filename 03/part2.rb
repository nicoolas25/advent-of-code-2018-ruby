require 'scanf'

class Range

  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

end

Claim = Struct.new(:id, :x, :y, :w, :h) do

  def self.parse(str)
    new(*str.scanf('#%d @ %d,%d: %dx%d\n').map(&:to_i))
  end

  def overlaps?(other)
    return false if id == other.id

    x_range.overlaps?(other.x_range) &&
      y_range.overlaps?(other.y_range)
  end

  protected

  def x_range
    (x...(x + w))
  end

  def y_range
    (y...(y + h))
  end

end

claims = ARGF.each_line.to_a.map { |claim_str| Claim.parse(claim_str) }
puts claims.find { |claim| claims.none? { |other| other.overlaps?(claim) } }.id
