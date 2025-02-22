# frozen_string_literal: true

require "optparse"

# Parses command-line options for the work calculator.
module WorkHoursCalculator
  class ParserError < StandardError; end

  class MissingOptionError < ParserError; end

  class InvalidOptionError < ParserError; end

  class Parser
    def self.parse_options(args = ARGV)
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: work_calculator [options] arg"

        opts.separator ""
        opts.separator "General Options:"
        opts.on("-s", "--start-time START", "Work start time (e.g., '9:30:00 AM')") { |v| options[:start_time] = v }
        opts.on("-e", "--end-time END", "Work end time (e.g., '6:00:00 PM')") { |v| options[:end_time] = v }
        opts.on("-b", "--breaks x,y", Array, "Break periods as comma-separated pairs (e.g., '12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM')") { |v| options[:breaks] = v.map { |pair| pair.split("-") } }

        opts.separator ""
        opts.separator "CSV File Options:"
        opts.on("-i", "--csv-input FILE", "CSV input file") { |v| options[:csv_input] = v }
        opts.on("-o", "--csv-output FILE", "CSV output file") { |v| options[:csv_output] = v }

        opts.separator ""
        opts.separator "Work hour logging Options:"
        opts.on("-l", "--log DESCRIPTION", "Log work with description") { |v|
          options[:log] = true
          options[:description] = v
        }
        opts.on("--dir DIRECTORY", "Directory to store log files") { |v| options[:log_dir] = v }
        opts.on("-t", "--calculate-log DATE", "Calculate hours from the log file for the specified date (e.g., '2023-10-01')") { |v|
          options[:calculate_log] = true
          options[:log_date] = v
        }

        opts.separator ""
        opts.separator "Setup your log directory via environment variable:"
        opts.separator ""
        opts.separator "export WORK_HOURS_LOG_DIR='/some/path'"

        opts.separator ""
        opts.separator ""
        opts.separator "For more information:"
        opts.on("-h", "--help", "Show help") {
          puts opts
          exit
        }

        opts.separator ""
        opts.separator "=============================================="
        opts.separator ""
        opts.separator "Thank you for supporting open source projects."
        opts.separator "For bugs or feature requests, visit https://github.com/gerdadecio/work-hours-calculator-ruby"
        opts.separator "Author: Gerda Decio, https://github.com/gerdadecio"
      end.parse!(args, into: options)

      if (options[:csv_input].nil? && options[:log].nil? && options[:calculate_log].nil?) && (options[:start_time].nil? || options[:end_time].nil? || options[:breaks].nil?)
        raise MissingOptionError, "Please provide start time, end time, and break times, or a CSV input file."
      end

      if options[:log] && options[:description].nil?
        raise MissingOptionError, "Description is required when logging work hours."
      end

      options
    rescue OptionParser::MissingArgument, WorkHoursCalculator::MissingOptionError => e
      puts e.message
      puts "\nfor more information: work_calculator --help"
      exit
    end
  end
end
