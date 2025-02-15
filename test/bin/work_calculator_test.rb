# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "csv"
require_relative "../test_helper"

class WorkCalculatorTest < Minitest::Test
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

  def test_calculate_with_arguments
    command = "ruby ./bin/work_calculator -s '9:00 AM' -e '5:00 PM' -b '12:00 PM-12:30 PM,3:00 PM-3:15 PM'"
    stdout, _stderr, status = Open3.capture3(command)
    assert status.success?
    assert_includes stdout, "Total Work Decimal Hours: 8.0 hours"
    assert_includes stdout, "Total Break Decimal Hours: 0.75 hours"
    assert_includes stdout, "Total Break Hours: 0:45 minutes"
    assert_includes stdout, "Net Work Decimal Hours: 7.25 hours"
  end

  def test_calculate_with_csv_input
    command = "ruby ./bin/work_calculator --csv-input #{@input_file}"
    stdout, _stderr, status = Open3.capture3(command)
    assert status.success?
    assert_includes stdout, "Total Work Decimal Hours: 8.0 hours"
    assert_includes stdout, "Total Break Decimal Hours: 0.75 hours"
    assert_includes stdout, "Total Break Hours: 0:45 minutes"
    assert_includes stdout, "Net Work Decimal Hours: 7.25 hours"
  end

  def test_calculate_with_csv_output
    command = "ruby ./bin/work_calculator -s '9:00 AM' -e '5:00 PM' -b '12:00 PM-12:30 PM,3:00 PM-3:15 PM' --csv-output #{@output_file}"
    _stdout, _stderr, status = Open3.capture3(command)
    assert status.success?
    assert File.exist?(@output_file)
    exported_data = CSV.read(@output_file, headers: true)
    assert_equal "8.0", exported_data["total_work_decimal_hours"].first
    assert_equal "0.75", exported_data["total_break_decimal_hours"].first
    assert_equal "0:45", exported_data["total_break_hours"].first
    assert_equal "7.25", exported_data["net_work_decimal_hours"].first
  end
end
