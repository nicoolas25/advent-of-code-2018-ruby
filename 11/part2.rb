SIZE = 300
SERIAL_NUMBER = 8979

FuelCell = Struct.new(:x, :y) do

  def rack_id
    @_rack_id ||= x + 10
  end

  def power_level
    @_power_level ||= ((((rack_id * y) + SERIAL_NUMBER) * rack_id) / 100 % 10) - 5
  end

end

class SummedAreaTable

  def initialize(square_matrix)
    @sat = Array.new(square_matrix.size) { Array.new(square_matrix.size) { 0 } }

    square_matrix.each.with_index do |row, y|
      row.each.with_index do |value, x|
        @sat[y][x] = value + get(x, y - 1) + get(x - 1, y) - get(x - 1, y - 1)
      end
    end
  end

  def sum(x1, y1, x2, y2)
    get(x1, y1) + get(x2, y2) - get(x2, y1) - get(x1, y2)
  end

  def get(x, y)
    return 0 unless x >= 0 && x < @sat.size && y >= 0 && y < @sat.size

    @sat[y][x]
  end

end

cells =
  Array.new(SIZE) do |y|
    Array.new(SIZE) do |x|
      FuelCell.new(x + 1, y + 1).power_level
    end
  end

summed_area_table = SummedAreaTable.new(cells)

x, y, area = Enumerator.new do |result|
  1.upto(SIZE - 3).each do |y|
    1.upto(SIZE - 3).each do |x|
      result << [
        x,
        y,
        summed_area_table.sum(x - 2, y - 2, x + 1, y + 1),
      ]
    end
  end
end.max_by { |_x, _y, area| area }

puts "#{x},#{y} (#{area})"
