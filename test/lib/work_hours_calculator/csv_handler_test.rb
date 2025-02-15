# frozen_string_literal: true

require "minitest/autorun"
require "csv"
require_relative "../../../lib/work_hours_calculator/csv_handler"

class WorkHoursCalculator::CSVHandlerTest < Minitest::Test
  def setup
    @input_file = "test_input.csv"
    @output_file = "test_output.csv"
    CSV.open(@input_file, "w") do |csv|
      csv << ["work_start", "work_end", "breaks"]
      csv << ["9:00 AM", "5:00 PM", "12:00 PM-12:30 PM,3:00 PM-3:15 PM"]
    end
  end

  def teardown
    File.delete(@input_file) if File.exist?(@input_file)
    File.delete(@output_file) if File.exist?(@output_file)
  end

  def test_import
    data = WorkHoursCalculator::CSVHandler.import(@input_file)
    assert_equal "9:00 AM", data[:work_start]
    assert_equal "5:00 PM", data[:work_end]
    assert_equal [["12:00 PM", "12:30 PM"], ["3:00 PM", "3:15 PM"]], data[:breaks]
  end

  def test_export
    results = {
      total_work_decimal_hours: 8.0,
      total_break_decimal_hours: 0.75,
      total_break_hours: "0:45",
      net_work_decimal_hours: 7.25
    }
    WorkHoursCalculator::CSVHandler.export(@output_file, results)
    exported_data = CSV.read(@output_file, headers: true)
    assert_equal "8.0", exported_data["total_work_decimal_hours"].first
    assert_equal "0.75", exported_data["total_break_decimal_hours"].first
    assert_equal "0:45", exported_data["total_break_hours"].first
    assert_equal "7.25", exported_data["net_work_decimal_hours"].first
  end
end
