require 'time'
require 'optparse'

class WorkHoursCalculator
  def initialize(work_start, work_end, breaks)
    @work_start_time = parse_time(work_start)
    @work_end_time = parse_time(work_end)
    @breaks = breaks.map { |start, end_time| [parse_time(start), parse_time(end_time)] }
  end

  def calculate
    total_work_time = @work_end_time - @work_start_time
    total_break_time = @breaks.reduce(0) { |sum, (start, end_time)| sum + (end_time - start) }
    net_work_time = total_work_time - total_break_time

    {
      total_work_hours: to_hours(total_work_time),
      total_break_hours: to_hours(total_break_time),
      net_work_hours: to_hours(net_work_time)
    }
  end

  private

  def parse_time(time_str)
    Time.parse(time_str)
  end

  def to_hours(seconds)
    seconds / 3600.0
  end
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: work_calculator.rb [options]"

    opts.on("-s", "--start-time START", "Work start time (e.g., '9:30:00 AM')") { |v| options[:start_time] = v }
    opts.on("-e", "--end-time END", "Work end time (e.g., '6:00:00 PM')") { |v| options[:end_time] = v }
    opts.on("-b", "--breaks x,y", Array, "Break periods as comma-separated pairs (e.g., '12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM')") do |v|
      options[:breaks] = v.map { |pair| pair.split('-') }
    end
    opts.on("-h", "--help", "Show help") { puts opts; exit }
  end.parse!

  if options[:start_time].nil? || options[:end_time].nil? || options[:breaks].nil?
    puts "Please provide start time, end time, and break times."
    exit
  end

  options
end

options = parse_options
calculator = WorkHoursCalculator.new(options[:start_time], options[:end_time], options[:breaks])
results = calculator.calculate

puts "Total Work Hours: #{results[:total_work_hours].round(2)} hours"
puts "Total Break Hours: #{results[:total_break_hours].round(2)} hours"
puts "Net Work Hours: #{results[:net_work_hours].round(2)} hours"