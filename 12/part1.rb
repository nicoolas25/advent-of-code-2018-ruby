inputs = ARGF.each_line.to_a
target = 20

EMPTY = ".".freeze
PLANT = "#".freeze

Pot = Struct.new(:state, :index) do

  def empty?
    state == EMPTY
  end

  def plant?
    state == PLANT
  end

end

class State

  def initialize(pots)
    @pots = Hash[pots.map { |pot| [pot.index, pot] }]
    @pots.default_proc = ->(hash, index) { Pot.new(EMPTY, index) }
  end

  def each_chunk
    Enumerator.new do |result|
      range.each do |index|
        chunk = (-2..2).each.map { |diff| @pots[index + diff].state }.join
        result << [index, chunk]
      end
    end
  end

  def sum(translation: 0)
    @pots.select { |index, pot| pot.plant? }.sum { |index, _pot| translation + index }
  end

  def to_s
    range.each.map { |index| @pots[index].state }.join
  end

  def first_index
    @pots[range.begin].index
  end

  private

  def range
    @_range ||= begin
      min, max = @pots.values.map(&:index).minmax
      (min - 5)..(max + 5)
    end
  end

end

class Rule

  attr_reader :pattern, :outcome

  def initialize(str)
    @pattern, @outcome = str.split(" => ")
  end

  def match?(chunk)
    @pattern == chunk
  end

  def outcome_plant?
    @outcome == PLANT
  end

end

class Simulator

  def initialize(initial_state:, rules:)
    @state = initial_state
    @rules = rules.select(&:outcome_plant?)
  end

  def next_state
    next_pots = @state.each_chunk.map do |index, chunk|
      Pot.new(PLANT, index) if @rules.any? { |rule| rule.match?(chunk) }
    end.compact
    State.new(next_pots)
  end

end

rules = inputs[2..-1].map(&:chomp).map { |rule_str| Rule.new(rule_str) }
pots = inputs.first.chomp[15..-1].each_char.with_index.map { |state, index| Pot.new(state, index) }
state = State.new(pots)

(1..target).each do |t|
  next_state = Simulator.new(initial_state: state, rules: rules).next_state
  state = next_state
end

puts state.sum
