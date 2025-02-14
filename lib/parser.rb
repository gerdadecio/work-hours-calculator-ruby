# frozen_string_literal: true

require 'optparse'

# Parses command-line options for the work calculator.
class Parser
  def self.parse_options(args = ARGV)
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: work_calculator.rb [options]"

      opts.on("-s", "--start-time START", "Work start time (e.g., '9:30:00 AM')") { |v| options[:start_time] = v }
      opts.on("-e", "--end-time END", "Work end time (e.g., '6:00:00 PM')") { |v| options[:end_time] = v }
      opts.on("-b", "--breaks x,y", Array, "Break periods as comma-separated pairs (e.g., '12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM')") do |v|
        options[:breaks] = v.map { |pair| pair.split('-') }
      end
      opts.on("-h", "--help", "Show help") { puts opts; exit }
    end.parse!(args, into: options)

    if options[:start_time].nil? || options[:end_time].nil? || options[:breaks].nil?
      puts "Please provide start time, end time, and break times."
      exit
    end

    options
  end
end