require_relative "../../test_helper"
require "minitest/autorun"
require "fileutils"
require_relative "../../../lib/work_hours_calculator/logger"

class WorkHoursCalculator::LoggerTest < Minitest::Test
  def setup
    @log_dir = File.join(Dir.pwd, "test/test_logs")
    FileUtils.rm_rf(@log_dir) if Dir.exist?(@log_dir)
  end

  def teardown
    FileUtils.rm_rf(@log_dir) if Dir.exist?(@log_dir)
  end

  def test_log_work_creates_log_file
    description = "Started working on project X"
    WorkHoursCalculator::Logger.log_work(description, @log_dir)

    log_file = File.join(@log_dir, "#{Date.today}.csv")
    assert File.exist?(log_file), "Log file should be created"

    log_content = CSV.read(log_file)
    assert_equal 1, log_content.size, "Log file should have one entry"
    assert_equal description, log_content[0][1], "Log entry should match the description"
  end

  def test_log_work_with_empty_description
    assert_raises(WorkHoursCalculator::InvalidRecord) do
      WorkHoursCalculator::Logger.log_work("", @log_dir)
    end
  end

  def test_log_work_creates_log_directory
    description = "Started working on project Y"
    WorkHoursCalculator::Logger.log_work(description, @log_dir)

    assert Dir.exist?(@log_dir), "Log directory should be created"
  end

  def test_log_work_handles_system_call_error
    log_dir = "/root/test_logs"
    description = "Started working on project Z"

    assert_raises(WorkHoursCalculator::InvalidDir) do
      WorkHoursCalculator::Logger.log_work(description, log_dir)
    end
  end

  def test_get_hours_from_log
    FileUtils.mkdir_p(@log_dir)
    log_file = File.join(@log_dir, "#{Date.today}.csv")
    CSV.open(log_file, "w") do |csv|
      csv << ["2025-02-01 09:00:00", "Started working"]
      csv << ["2025-02-01 12:00:00", "Break"]
      csv << ["2025-02-01 13:00:00", "Back to work"]
      csv << ["2025-02-01 17:00:00", "End"]
    end
    result = WorkHoursCalculator::Logger.get_hours_from_log(Date.today, @log_dir)
    assert_equal "09:00:00 AM", result[:work_start]
    assert_equal "05:00:00 PM", result[:work_end]
    assert_equal 1, result[:breaks].size
    assert_equal "12:00:00 PM", result[:breaks][0][0]
    assert_equal "01:00:00 PM", result[:breaks][0][1]
  end

  def test_get_hours_from_log_file_not_found
    assert_raises(SystemExit) do
      WorkHoursCalculator::Logger.get_hours_from_log(Date.today, @log_dir)
    end
  end

  def test_get_hours_from_log_missing_work_start
    FileUtils.mkdir_p(@log_dir)
    log_file = File.join(@log_dir, "#{Date.today}.csv")
    CSV.open(log_file, "w") do |csv|
      csv << [Time.now.strftime("%Y-%m-%d %H:%M:%S"), "break"]
      csv << [(Time.now + 3600).strftime("%Y-%m-%d %H:%M:%S"), "End"]
    end

    assert_raises(WorkHoursCalculator::MissingRecord) do
      WorkHoursCalculator::Logger.get_hours_from_log(Date.today, @log_dir)
    end
  end

  def test_get_hours_from_log_missing_work_end
    FileUtils.mkdir_p(@log_dir)
    log_file = File.join(@log_dir, "#{Date.today}.csv")
    CSV.open(log_file, "w") do |csv|
      csv << [Time.now.strftime("%Y-%m-%d %H:%M:%S"), "Started working"]
      csv << [(Time.now + 3600).strftime("%Y-%m-%d %H:%M:%S"), "Break"]
    end

    assert_raises(WorkHoursCalculator::MissingRecord) do
      WorkHoursCalculator::Logger.get_hours_from_log(Date.today, @log_dir)
    end
  end

  def test_get_hours_from_log_missing_break
    FileUtils.mkdir_p(@log_dir)
    log_file = File.join(@log_dir, "#{Date.today}.csv")
    CSV.open(log_file, "w") do |csv|
      csv << ["2025-02-01 09:00:00", "Started working"]
      csv << ["2025-02-01 17:00:00", "End"]
    end

    result = WorkHoursCalculator::Logger.get_hours_from_log(Date.today, @log_dir)
    assert_equal "09:00:00 AM", result[:work_start]
    assert_equal "05:00:00 PM", result[:work_end]
    assert_equal 0, result[:breaks].size
  end
end
