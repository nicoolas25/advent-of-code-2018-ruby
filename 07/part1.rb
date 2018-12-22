require 'scanf'

nodes = {}

ARGF.each_line do |str|
  from, to = str.scanf('Step %s must be finished before step %s can begin.\n')
  nodes[from] ||= []
  (nodes[to] ||= []) << from
end

nodes = Hash[nodes.sort_by(&:first)]

result = ''

loop do
  name, = nodes.find { |_, prerequisites| prerequisites.empty? }
  result << name
  nodes.delete(name)
  nodes.values.each { |prerequisites| prerequisites.delete(name) }
  break if nodes.empty?
end

puts result
