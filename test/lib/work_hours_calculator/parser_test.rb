# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../test_helper"
require_relative "../../../lib/work_hours_calculator/parser"

class WorkHoursCalculator::ParserTest < Minitest::Test
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
  end

  def test_parse_options_with_csv_output
    args = ["-s", "9:00 AM", "-e", "5:00 PM", "-b", "12:00 PM-12:30 PM,3:00 PM-3:15 PM", "--csv-output", "output.csv"]
    options = WorkHoursCalculator::Parser.parse_options(args)
    assert_equal "output.csv", options[:csv_output]
  end

  def test_parse_options_with_help
    args = ["-h"]
    assert_output(/Usage: work_calculator.rb \[options\]/) do
      assert_raises(SystemExit) { WorkHoursCalculator::Parser.parse_options(args) }
    end
  end

  def test_parse_options_missing_required_arguments
    args = []
    assert_output(/Please provide start time, end time, and break times, or a CSV input file./) do
      assert_raises(SystemExit) { WorkHoursCalculator::Parser.parse_options(args) }
    end
  end
end
