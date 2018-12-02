require 'set'

current_frequency = 0
seen = Set.new([0])

ARGF.each_line.map(&:to_i).cycle.each do |change|
  current_frequency = current_frequency + change

  if seen.member?(current_frequency)
    puts current_frequency
    exit 0
  end

  seen << current_frequency
end
