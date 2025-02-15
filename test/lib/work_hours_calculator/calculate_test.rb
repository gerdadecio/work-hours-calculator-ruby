# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../test_helper"
require_relative "../../../lib/work_hours_calculator/calculate"
require_relative "../../../lib/work_hours_calculator/parser"

class WorkHoursCalculator::CalculateTest < Minitest::Test
  def setup
    @calculator = WorkHoursCalculator::Calculate.new(
      "9:00 AM", "5:00 PM",
      [["12:00 PM", "12:30 PM"], ["3:00 PM", "3:15 PM"]]
    )
  end

  def test_initialize
    assert_equal Time.parse("9:00 AM"), @calculator.instance_variable_get(:@work_start_time)
    assert_equal Time.parse("5:00 PM"), @calculator.instance_variable_get(:@work_end_time)
    expected_breaks = [["12:00 PM", "12:30 PM"], ["3:00 PM", "3:15 PM"]].map { |start, end_time| [Time.parse(start), Time.parse(end_time)] }
    assert_equal expected_breaks, @calculator.instance_variable_get(:@breaks)
  end

  def test_execute
    result = @calculator.execute

    assert_in_delta 8.0, result[:total_work_decimal_hours], 0.01
    assert_in_delta 0.75, result[:total_break_decimal_hours], 0.01
    assert_equal "0:45", result[:total_break_hours]
    assert_in_delta 7.25, result[:net_work_decimal_hours], 0.01
  end

  def test_total_work_hours
    results = @calculator.execute
    assert_in_delta 8.0, results[:total_work_decimal_hours], 0.01
  end

  def test_total_break_hours
    results = @calculator.execute
    assert_in_delta 0.75, results[:total_break_decimal_hours], 0.01
  end

  def test_net_work_hours
    results = @calculator.execute
    assert_in_delta 7.25, results[:net_work_decimal_hours], 0.01
  end

  def test_formatted_break_hours
    results = @calculator.execute
    assert_equal "0:45", results[:total_break_hours]
  end

  def test_no_breaks
    calculator = WorkHoursCalculator::Calculate.new("9:00 AM", "5:00 PM", [])
    results = calculator.execute
    assert_in_delta 8.0, results[:net_work_decimal_hours], 0.01
  end

  def test_single_long_break
    calculator = WorkHoursCalculator::Calculate.new("9:00 AM", "5:00 PM", [["12:00 PM", "2:00 PM"]])
    results = calculator.execute
    assert_in_delta 6.0, results[:net_work_decimal_hours], 0.01
    assert_equal "2:00", results[:total_break_hours]
  end

  def test_parse_options
    options = WorkHoursCalculator::Parser.parse_options(["-s", "9:00 AM", "-e", "5:00 PM", "-b", "12:00 PM-1:00 PM"])
    assert_equal "9:00 AM", options[:start_time]
    assert_equal "5:00 PM", options[:end_time]
    assert_equal [["12:00 PM", "1:00 PM"]], options[:breaks]
  end
end
