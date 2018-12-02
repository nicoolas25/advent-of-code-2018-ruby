puts ARGF.each_line.map(&:to_i).reduce(&:+)
