# frozen_string_literal: true
require 'minitest/autorun'
require_relative '../lib/work_hours_calculator'
require 'optparse'

class WorkHoursCalculatorTest < Minitest::Test
  def setup
    @calculator = WorkHoursCalculator.new(
      '9:00 AM', '5:00 PM',
      [['12:00 PM', '12:30 PM'], ['3:00 PM', '3:15 PM']]
    )
  end

  def test_total_work_hours
    results = @calculator.calculate
    assert_in_delta 8.0, results[:total_work_hours], 0.01
  end

  def test_total_break_hours
    results = @calculator.calculate
    assert_in_delta 0.75, results[:total_break_hours], 0.01
  end

  def test_net_work_hours
    results = @calculator.calculate
    assert_in_delta 7.25, results[:net_work_hours], 0.01
  end

  def test_no_breaks
    calculator = WorkHoursCalculator.new('9:00 AM', '5:00 PM', [])
    results = calculator.calculate
    assert_in_delta 8.0, results[:net_work_hours], 0.01
  end

  def test_single_long_break
    calculator = WorkHoursCalculator.new('9:00 AM', '5:00 PM', [['12:00 PM', '2:00 PM']])
    results = calculator.calculate
    assert_in_delta 6.0, results[:net_work_hours], 0.01
  end

end
