# frozen_string_literal: true

require "optparse"

# Parses command-line options for the work calculator.
module WorkHoursCalculator
  class Parser
    def self.parse_options(args = ARGV)
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: work_calculator.rb [options]"

        opts.on("-s", "--start-time START", "Work start time (e.g., '9:30:00 AM')") { |v| options[:start_time] = v }
        opts.on("-e", "--end-time END", "Work end time (e.g., '6:00:00 PM')") { |v| options[:end_time] = v }
        opts.on("-b", "--breaks x,y", Array, "Break periods as comma-separated pairs (e.g., '12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM')") { |v| options[:breaks] = v.map { |pair| pair.split("-") } }
        opts.on("--csv-input FILE", "CSV input file") { |v| options[:csv_input] = v }
        opts.on("--csv-output FILE", "CSV output file") { |v| options[:csv_output] = v }
        opts.on("--log DESCRIPTION", "Log work with description") { |v|
          options[:log] = true
          options[:description] = v
        }
        opts.on("--log-dir DIRECTORY", "Directory to store log files") { |v| options[:log_dir] = v }
        opts.on("--calculate-log DATE", "Calculate hours from the log file for the specified date (e.g., '2023-10-01')") { |v|
          options[:calculate_log] = true
          options[:log_date] = v
        }
        opts.on("-h", "--help", "Show help") {
          puts opts
          exit
        }
      end.parse!(args, into: options)

      if (options[:csv_input].nil? && options[:log].nil? && options[:calculate_log].nil?) && (options[:start_time].nil? || options[:end_time].nil? || options[:breaks].nil?)
        puts "Please provide start time, end time, and break times, or a CSV input file."
        exit
      end

      if options[:log] && options[:description].nil?
        puts "Error: Description is required when logging work hours."
        exit 1
      end

      options
    end
  end
end
