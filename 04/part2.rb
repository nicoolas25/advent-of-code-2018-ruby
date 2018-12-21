require 'scanf'
require 'time'

LOG_PATTERN = /\A\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2})\] (.+)\n\z/.freeze
WAKES_UP_MSG = 'wakes up'.freeze
FALLS_ASLEEP_MSG = 'falls asleep'.freeze

Event = Struct.new(:datetime, :details) do

  def self.parse(str)
    datetime, details = str.scan(LOG_PATTERN).first
    new(Time.strptime(datetime, '%F %R'), details)
  end

  def to_s
    "[#{datetime.strftime('%F %R')}] #{details}"
  end

  def guard_id
    details.scanf('Guard #%d begins shift').map(&:to_i).first
  end

  def falls_asleep?
    details == FALLS_ASLEEP_MSG
  end

  def wakes_up?
    details == WAKES_UP_MSG
  end

end

class GuardLog

  attr_reader :guard_id, :minutes_asleep

  def initialize(guard_id)
    @guard_id = guard_id
    @minutes_asleep = Hash.new(0)
    @latest_event = nil
  end

  def <<(event)
    event1 = @latest_event
    event2 = @latest_event = event
    add_minutes_asleep_between(event1, event2)
  end

  def total_minutes_asleep
    @minutes_asleep.values.sum
  end

  def most_slept_minute_and_times
    @minutes_asleep.max_by(&:last)
  end

  private

  def add_minutes_asleep_between(event1, event2)
    return unless event1&.falls_asleep? && event2.wakes_up?

    first_minute = event1.datetime.min
    number_of_minutes = (event2.datetime.to_i - event1.datetime.to_i) / 60
    (first_minute...(first_minute + number_of_minutes)).each do |minute|
      @minutes_asleep[minute % 60] += 1
    end
  end

end

guard_logs = Hash.new { |hash, id| hash[id] = GuardLog.new(id) }

# Fill the events in the guards logs
sorted_events = ARGF.each_line.to_a.sort.map { |str| Event.parse(str) }
sorted_events.reduce(nil) do |guard_id, event|
  (event.guard_id || guard_id).tap { |id| guard_logs[id] << event }
end

sleeping_stats = guard_logs.transform_values(&:most_slept_minute_and_times).compact
guard_id, (minute, _times) = sleeping_stats.max_by { |_id, (_minute, times)| times }

puts "Most regular guard: #{guard_id}"
puts "Most slept minute: #{minute}"
puts "Answer is: #{guard_id * minute}"
