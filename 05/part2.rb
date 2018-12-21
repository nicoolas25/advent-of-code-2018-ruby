original_polymer = ARGF.each_line.first.chomp
pattern = Regexp.new(
  ('a'..'z').zip('A'..'Z').flat_map do |downcased, upcased|
    [downcased + upcased, upcased + downcased]
  end.join('|')
)

min_reduced_size = ('a'..'z').map do |letter|
  polymer = original_polymer.gsub(/#{letter}/i, '')

  loop do
    previous_polymer = polymer
    polymer = polymer.gsub(pattern, '')
    break if previous_polymer == polymer
  end

  polymer.size
end.min

puts min_reduced_size
