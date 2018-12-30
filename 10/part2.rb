Point = Struct.new(:x, :y) do

  attr_accessor :dx, :dy

  def next
    Point.new(x + dx, y + dy).tap do |point|
      point.dx = dx
      point.dy = dy
    end
  end

end

PATTERN = /position=<([\- ]\d+), ([\- ]\d+)> velocity=<([\- ]\d+), ([\- ]\d+)>\n/

points = ARGF.each_line.map do |line|
  x, y, dx, dy = line.scan(PATTERN).first.map(&:to_i)

  Point.new(x, y).tap do |point|
    point.dx = dx
    point.dy = dy
  end
end

def ranges_and_area(points)
  min_x, max_x = points.map(&:x).minmax
  min_y, max_y = points.map(&:y).minmax
  x_range = (min_x - 5)..(max_x + 5)
  y_range = (min_y - 5)..(max_y + 5)
  area = (max_x - min_x) * (max_y - min_y)
  [x_range, y_range, area]
end

_, _, min_area = ranges_and_area(points)
seconds = 0

loop do
  points.map!(&:next)

  x_range, y_range, area = ranges_and_area(points)

  if min_area > area
    min_area = area
    seconds += 1
  elsif min_area < area
    puts seconds
    exit 0
  end
end
