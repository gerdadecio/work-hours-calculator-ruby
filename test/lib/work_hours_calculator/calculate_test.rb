# frozen_string_literal: true

require_relative "../../test_helper"
require "minitest/autorun"
require_relative "../../../lib/work_hours_calculator/calculate"

class WorkHoursCalculator::CalculateTest < Minitest::Test
  def setup
    @work_start = "9:00 AM"
    @work_end = "5:00 PM"
    @calculator = WorkHoursCalculator::Calculate.new(
      @work_start, @work_end,
      [["12:00 PM", "12:30 PM"], ["3:00 PM", "3:15 PM"]]
    )
  end

  def test_initialize
    assert_equal Time.parse(@work_start), @calculator.instance_variable_get(:@work_start_time)
    assert_equal Time.parse(@work_end), @calculator.instance_variable_get(:@work_end_time)
    expected_breaks = [["12:00 PM", "12:30 PM"], ["3:00 PM", "3:15 PM"]].map { |start, end_time| [Time.parse(start), Time.parse(end_time)] }
    assert_equal expected_breaks, @calculator.instance_variable_get(:@breaks)
  end

  def test_initialize_with_nil_work_start
    assert_raises(WorkHoursCalculator::InvalidTimeError) do
      WorkHoursCalculator::Calculate.new(nil, "5:00 PM", [["12:00 PM", "2:00 PM"]])
    end
  end

  def test_initialize_with_nil_work_end
    assert_raises(WorkHoursCalculator::InvalidTimeError) do
      WorkHoursCalculator::Calculate.new("9:00 AM", nil, [["12:00 PM", "2:00 PM"]])
    end
  end

  def test_initialize_with_invalid_work_start
    assert_raises(WorkHoursCalculator::InvalidTimeError) do
      WorkHoursCalculator::Calculate.new("invalid_time", "5:00 PM", [["12:00 PM", "2:00 PM"]])
    end
  end

  def test_initialize_with_invalid_work_end
    assert_raises(WorkHoursCalculator::InvalidTimeError) do
      WorkHoursCalculator::Calculate.new("9:00 AM", "invalid_time", [["12:00 PM", "2:00 PM"]])
    end
  end

  def test_execute
    result = @calculator.execute

    assert_in_delta 8.0, result[:total_work_decimal_hours], 0.01
    assert_in_delta 0.75, result[:total_break_decimal_hours], 0.01
    assert_equal "0:45", result[:total_break_hours]
    assert_in_delta 7.25, result[:net_work_decimal_hours], 0.01
  end

  def test_execute_with_missing_end_break
    breaks = [["12:00 PM", "12:30 PM"], ["3:00 PM"]]
    calculator = WorkHoursCalculator::Calculate.new(@work_start, @work_end, breaks)
    result = calculator.execute

    assert_in_delta 8.0, result[:total_work_decimal_hours], 0.01
    assert_in_delta 0.5, result[:total_break_decimal_hours], 0.01
    assert_equal "0:30", result[:total_break_hours]
    assert_in_delta 7.5, result[:net_work_decimal_hours], 0.01
  end

  def test_execute_with_no_breaks
    breaks = []
    calculator = WorkHoursCalculator::Calculate.new(@work_start, @work_end, breaks)
    result = calculator.execute

    assert_in_delta 8.0, result[:total_work_decimal_hours], 0.01
    assert_in_delta 0.0, result[:total_break_decimal_hours], 0.01
    assert_equal "0:00", result[:total_break_hours]
    assert_in_delta 8.0, result[:net_work_decimal_hours], 0.01
  end

  def test_execute_with_invalid_break_times
    breaks = [["12:00 PM", "invalid_time"], ["invalid_time", "3:15 PM"]]
    calculator = WorkHoursCalculator::Calculate.new("9:00 AM", "5:00 PM", breaks)
    result = calculator.execute

    assert_in_delta 8.0, result[:total_work_decimal_hours], 0.01
    assert_in_delta 0.0, result[:total_break_decimal_hours], 0.01
    assert_equal "0:00", result[:total_break_hours]
    assert_in_delta 8.0, result[:net_work_decimal_hours], 0.01
  end

  def test_execute_total_work_hours
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
end
