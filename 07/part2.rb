require 'scanf'

class Task < String

  attr_reader :duration

  def initialize(str)
    super
    @duration = 60 + (bytes.first - 64)
    @unavailable = false
    @dependencies = []
    @done = false
  end

  #
  # Availability to be worked on
  #

  def available?
    !@unavailable && @dependencies.all?(&:done?)
  end

  def unavailable!
    @unavailable = true
  end

  #
  # Dependencies
  #

  def add_dependency(other)
    @dependencies << other
  end

  #
  # Completion
  #

  def done?
    @done
  end

  def done!
    @done = true
  end

end

class Worker

  def initialize
    @busy_for = 0
    @current_task = nil
  end

  def available?
    @busy_for.zero? || @current_task.nil?
  end

  def works_on!(task)
    @current_task = task
    @current_task.unavailable!
    @busy_for = @current_task.duration
  end

  def tick!
    @busy_for -= 1 unless @busy_for.zero?

    if @busy_for.zero? && @current_task
      @current_task.done!
      @current_task = nil
    end
  end

end

tasks = Hash.new { |hash, name| hash[name] = Task.new(name) }

ARGF.each_line do |str|
  name1, name2 = str.scanf('Step %s must be finished before step %s can begin.\n')
  task1 = tasks[name1]
  task2 = tasks[name2]
  task2.add_dependency(task1)
end

sorted_tasks = tasks.values.sort

workers = Array.new(5) { Worker.new }
clock = 0

loop do
  available_tasks = sorted_tasks.select(&:available?)
  available_workers = workers.select(&:available?)

  available_workers.each do |available_worker|
    if (available_task = available_tasks.shift)
      available_worker.works_on!(available_task)
    end
  end

  workers.each(&:tick!)
  clock += 1

  break if sorted_tasks.all?(&:done?) && workers.all?(&:available?)
end

puts clock
