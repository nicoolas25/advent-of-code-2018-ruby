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

grid =
  ((min_x - 100)..(max_x + 100)).map do |x|
    ((min_y - 100)..(max_y + 100)).map do |y|
      (p1, d1), (_, d2) =
        points.map { |p| [p, p.distance_from(x, y)] }.sort_by(&:last)
      d1 == d2 ? nil : p1
    end
  end

infinite_area_points =
  (grid[0] + grid[-1] + grid.transpose[0] + grid.transpose[-1]).uniq

finite_areas_points = points - infinite_area_points

max_area = grid.flatten.
  select { |point| finite_areas_points.include?(point) }.
  group_by(&:itself).
  transform_values(&:size).
  values.
  max

puts max_area
