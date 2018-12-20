ARGF.each_line.map(&:chomp).to_a.combination(2).each do |box_id1, box_id2|
  common_letters = box_id1.chars.zip(box_id2.chars).select { |a, b| a == b }
  if common_letters.size == box_id1.size - 1
    puts common_letters.map(&:first).join
    break
  end
end
