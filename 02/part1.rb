twos, threes = ARGF.each_line.reduce([0, 0]) do |(twos, threes), box_id|
  counts = box_id.chars.group_by(&:itself).values.map(&:count)
  [
    counts.include?(2) ? twos + 1   : twos,
    counts.include?(3) ? threes + 1 : threes,
  ]
end

puts twos * threes
