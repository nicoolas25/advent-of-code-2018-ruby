require 'scanf'

Claim = Struct.new(:id, :x, :y, :w, :h) do

  def self.parse(str)
    new(*str.scanf('#%d @ %d,%d: %dx%d\n').map(&:to_i))
  end

  def positions
    x_range.to_a.product(y_range.to_a).map { |i, j| "#{i},#{j}" }
  end

  protected

  def x_range
    (x...(x + w))
  end

  def y_range
    (y...(y + h))
  end

end

squares = Hash.new { |hash, position| hash[position] = 0 }

ARGF.each_line.
  map { |claim_str| Claim.parse(claim_str) }.
  each { |claim| claim.positions.each { |p| squares[p] += 1 } }

puts squares.values.select { |v| v > 1 }.size
