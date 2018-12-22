# frozen_string_literal: true

integer_stream = ARGF
  .each_char
  .lazy
  .chunk_while { |_, after| after != ' ' }
  .map { |numbers| numbers.join.to_i }
  .to_enum

Node = Struct.new(:children, :metadata) do

  def self.read_from(stream)
    child_node_count = stream.next
    metadata_count = stream.next
    children = Array.new(child_node_count) { Node.read_from(stream) }
    metadata = Array.new(metadata_count) { stream.next }

    new(children, metadata)
  end

  def value
    if children.empty?
      metadata.sum
    else
      metadata.sum do |index|
        index >= 1 && index <= children.size ? children[index - 1].value : 0
      end
    end
  end

end

puts Node.read_from(integer_stream).value
