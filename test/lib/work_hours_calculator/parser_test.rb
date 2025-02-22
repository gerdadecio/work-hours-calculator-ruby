# frozen_string_literal: true

require_relative "../../test_helper"
require "minitest/autorun"
require_relative "../../../lib/work_hours_calculator/parser"

class WorkHoursCalculator::ParserTest < Minitest::Test
  def test_parse_options_with_all_arguments
    args = ["-s", "9:30:00 AM", "-e", "6:00:00 PM", "-b", "12:00 PM-12:30 PM,3:00 PM-3:15 PM"]
    options = WorkHoursCalculator::Parser.parse_options(args)

    assert_equal "9:30:00 AM", options[:start_time]
    assert_equal "6:00:00 PM", options[:end_time]
    assert_equal [["12:00 PM", "12:30 PM"], ["3:00 PM", "3:15 PM"]], options[:breaks]
  end

  def test_parse_options_with_start_end_breaks
    args = ["-s", "9:00 AM", "-e", "5:00 PM", "-b", "12:00 PM-12:30 PM,3:00 PM-3:15 PM"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "9:00 AM", options[:start_time]
    assert_equal "5:00 PM", options[:end_time]
    assert_equal [["12:00 PM", "12:30 PM"], ["3:00 PM", "3:15 PM"]], options[:breaks]
  end

  def test_parse_options_with_csv_input
    args = ["--csv-input", "input.csv"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "input.csv", options[:csv_input]

    args = ["-i", "input.csv"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "input.csv", options[:csv_input]
  end

  def test_parse_options_with_csv_output
    args = ["-s", "9:00 AM", "-e", "5:00 PM", "-b", "12:00 PM-12:30 PM,3:00 PM-3:15 PM", "--csv-output", "output.csv"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "output.csv", options[:csv_output]

    args = ["-s", "9:00 AM", "-e", "5:00 PM", "-b", "12:00 PM-12:30 PM,3:00 PM-3:15 PM", "-o", "output.csv"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "output.csv", options[:csv_output]
  end

  def test_parse_options_with_help
    args = ["-h"]
    assert_output(/Usage: work_calculator \[options\] arg/) do
      assert_raises(SystemExit) { WorkHoursCalculator::Parser.parse_options(args) }
    end
  end

  def test_parse_options_missing_required_arguments
    args = []
    assert_output(/Please provide start time, end time, and break times, or a CSV input file./) do
      assert_raises(SystemExit) { WorkHoursCalculator::Parser.parse_options(args) }
    end
  end

  def test_parse_options_with_log_description
    args = ["--log", "Started work on feature X"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "Started work on feature X", options[:description]
    assert options[:log]
  end

  def test_parse_options_with_calculate_log
    args = ["--calculate-log", "2025-02-01"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "2025-02-01", options[:log_date]
    assert options[:calculate_log]

    args = ["-t", "2025-02-01"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "2025-02-01", options[:log_date]
    assert options[:calculate_log]
  end

  def test_parse_options_help_display
    args = ["-h"]
    expected_output = <<~HELP
      Usage: work_calculator [options] arg

      General Options:
          -s, --start-time START           Work start time (e.g., '9:30:00 AM')
          -e, --end-time END               Work end time (e.g., '6:00:00 PM')
          -b, --breaks x,y                 Break periods as comma-separated pairs (e.g., '12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM')
      
      CSV File Options:
          -i, --csv-input FILE             CSV input file
          -o, --csv-output FILE            CSV output file

      Work hour logging Options:
          -l, --log DESCRIPTION            Log work with description
              --dir DIRECTORY              Directory to store log files
          -t, --calculate-log DATE         Calculate hours from the log file for the specified date (e.g., '2023-10-01')

      Setup your log directory via environment variable:

      export WORK_HOURS_LOG_DIR='/some/path'


      For more information:
          -h, --help                       Show help

      ==============================================

      Thank you for supporting open source projects.
      For bugs or feature requests, visit https://github.com/gerdadecio/work-hours-calculator-ruby
      Author: Gerda Decio, https://github.com/gerdadecio
    HELP

    assert_output(expected_output) do
      assert_raises(SystemExit) { WorkHoursCalculator::Parser.parse_options(args) }
    end
  end
end
