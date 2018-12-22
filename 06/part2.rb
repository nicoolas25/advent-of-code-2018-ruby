require 'scanf'

Point = Struct.new(:id, :x, :y) do

  def self.parse(id, str)
    new(id, *str.scanf('%d, %d\n'))
  end

  def distance_from(other_x, other_y)
    (x - other_x).abs + (y - other_y).abs
  end

end

points = ARGF.each_line.to_a.map.with_index do |str, index|
  Point.parse(index, str)
end

min_x, max_x = points.map(&:x).minmax
min_y, max_y = points.map(&:y).minmax

region_size = 0

((min_x - 100)..(max_x + 100)).each do |x|
  ((min_y - 100)..(max_y + 100)).each do |y|
    region_size += 1 if points.map { |p| p.distance_from(x, y) }.sum < 10_000
  end
end

puts region_size
