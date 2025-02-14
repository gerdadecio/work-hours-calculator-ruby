# frozen_string_literal: true
require 'minitest/autorun'
require_relative '../lib/work_hours_calculator'
require_relative '../lib/parser'


class WorkHoursCalculatorTest < Minitest::Test
  def setup
    @calculator = WorkHoursCalculator.new(
      '9:00 AM', '5:00 PM',
      [['12:00 PM', '12:30 PM'], ['3:00 PM', '3:15 PM']]
    )
  end

  def test_total_work_hours
    results = @calculator.calculate
    assert_in_delta 8.0, results[:total_work_decimal_hours], 0.01
  end

  def test_total_break_hours
    results = @calculator.calculate
    assert_in_delta 0.75, results[:total_break_decimal_hours], 0.01
  end

  def test_net_work_hours
    results = @calculator.calculate
    assert_in_delta 7.25, results[:net_work_decimal_hours], 0.01
  end

  def test_formatted_break_hours
    results = @calculator.calculate
    assert_equal "0:45", results[:total_break_hours]
  end

  def test_no_breaks
    calculator = WorkHoursCalculator.new('9:00 AM', '5:00 PM', [])
    results = calculator.calculate
    assert_in_delta 8.0, results[:net_work_decimal_hours], 0.01
  end

  def test_single_long_break
    calculator = WorkHoursCalculator.new('9:00 AM', '5:00 PM', [['12:00 PM', '2:00 PM']])
    results = calculator.calculate
    assert_in_delta 6.0, results[:net_work_decimal_hours], 0.01
    assert_equal "2:00", results[:total_break_hours]
  end

  def test_parse_options
    options = Parser.parse_options(['-s', '9:00 AM', '-e', '5:00 PM', '-b', '12:00 PM-1:00 PM'])
    assert_equal '9:00 AM', options[:start_time]
    assert_equal '5:00 PM', options[:end_time]
    assert_equal [['12:00 PM', '1:00 PM']], options[:breaks]
  end
end
