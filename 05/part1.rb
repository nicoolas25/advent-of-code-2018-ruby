polymer = ARGF.each_line.first.chomp
pattern = Regexp.new(
  ('a'..'z').zip('A'..'Z').flat_map do |downcased, upcased|
    [downcased + upcased, upcased + downcased]
  end.join('|')
)

loop do
  previous_polymer = polymer
  polymer = polymer.gsub(pattern, '')
  break if previous_polymer == polymer
end

puts polymer.size

