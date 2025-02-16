# frozen_string_literal: true

require_relative "work_hours_calculator/version"
require_relative "work_hours_calculator/calculate"

module WorkHoursCalculator
  class Error < StandardError; end

  def self.calculate(work_start, work_end, breaks)
    WorkHoursCalculator::Calculate.new(work_start, work_end, breaks).execute
  end

  def self.calculate_hours_from_log(date)
    results = WorkHoursCalculator::Logger.get_hours_from_log(date)
    WorkHoursCalculator::Calculate.new(results[:work_start], results[:work_end], results[:breaks]).execute
  end
end
