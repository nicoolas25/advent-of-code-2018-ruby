require 'scanf'

ListElement = Struct.new(:value) do
  attr_accessor :next, :prev
end

class CircularList

  def initialize(first_value)
    @cursor = ListElement.new(first_value)
    @cursor.next = @cursor
    @cursor.prev = @cursor
  end

  def current_value
    @cursor.value
  end

  def rotate_clockwise(times: 1)
    times.times { @cursor = @cursor.next }
  end

  def rotate_counter_clockwise(times: 1)
    times.times { @cursor = @cursor.prev }
  end

  def add(value)
    new_element = ListElement.new(value)
    new_element.next = @cursor.next
    new_element.prev = @cursor
    @cursor.next.prev = new_element
    @cursor.next = new_element
    @cursor = new_element
    value
  end

  def delete_current
    current_value.tap do
      next_element = @cursor.next
      prev_element = @cursor.prev
      prev_element.next = next_element
      next_element.prev = prev_element
      @cursor = next_element
    end
  end

end

class Game

  def initialize(players_count)
    @circle = CircularList.new(0)
    @players_count = players_count
    @player_index = 0
    @scores = Array.new(players_count) { 0 }
  end

  def add_marble(marble)
    if (marble % 23).zero?
      @circle.rotate_counter_clockwise(times: 7)
      deleted_marble = @circle.delete_current
      @scores[@player_index] += deleted_marble + marble
    else
      @circle.rotate_clockwise
      @circle.add(marble)
    end

    @player_index = (@player_index + 1) % @players_count
  end

  def winner
    score, id = @scores.each.with_index.max_by(&:first)
    [id + 1, score]
  end

end


number_of_players, number_of_marbles =
  ARGF.each_line.first.scanf('%d players; last marble is worth %d points')

game = Game.new(number_of_players)
(1..number_of_marbles).each { |m| game.add_marble(m) }
puts game.winner
