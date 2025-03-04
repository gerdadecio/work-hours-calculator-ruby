require_relative "../test_helper"
require "minitest/autorun"
require_relative "../../lib/work_hours_calculator"

class WorkHoursCalculatorCalculateTest < Minitest::Test
  def setup
    @work_start = "9:00 AM"
    @work_end = "5:00 PM"
    @breaks = [["12:00 PM", "12:30 PM"], ["3:00 PM", "3:15 PM"]]
  end

  def test_calculate_total_work_hours
    result = WorkHoursCalculator.calculate(@work_start, @work_end, @breaks)
    assert_in_delta 8.0, result[:total_work_decimal_hours], 0.01
  end

  def test_calculate_total_break_hours
    result = WorkHoursCalculator.calculate(@work_start, @work_end, @breaks)
    assert_in_delta 0.75, result[:total_break_decimal_hours], 0.01
  end

  def test_calculate_net_work_hours
    result = WorkHoursCalculator.calculate(@work_start, @work_end, @breaks)
    assert_in_delta 7.25, result[:net_work_decimal_hours], 0.01
  end

  def test_calculate_formatted_break_hours
    result = WorkHoursCalculator.calculate(@work_start, @work_end, @breaks)
    assert_equal "0:45", result[:total_break_hours]
  end

  def test_calculate_no_breaks
    result = WorkHoursCalculator.calculate(@work_start, @work_end, [])
    assert_in_delta 8.0, result[:net_work_decimal_hours], 0.01
  end

  def test_calculate_single_long_break
    result = WorkHoursCalculator.calculate(@work_start, @work_end, [["12:00 PM", "2:00 PM"]])
    assert_in_delta 6.0, result[:net_work_decimal_hours], 0.01
    assert_equal "2:00", result[:total_break_hours]
  end

  def test_calculate_hours_from_log
    result = {
      work_start: "9:00:00 AM",
      work_end: "5:00:00 PM",
      breaks: [["12:00:00 PM", "1:00:00 PM"]]
    }
    WorkHoursCalculator::Logger.stub(:get_hours_from_log, result) do
      hours = WorkHoursCalculator.calculate_hours_from_log(Date.today)
      assert_in_delta 8.0, hours[:total_work_decimal_hours], 0.01
      assert_in_delta 1.0, hours[:total_break_decimal_hours], 0.01
      assert_in_delta 7.0, hours[:net_work_decimal_hours], 0.01
      assert_equal "1:00", hours[:total_break_hours]
    end
  end
end
