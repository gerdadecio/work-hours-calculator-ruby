# frozen_string_literal: true

require_relative "work_hours_calculator/version"
require_relative "work_hours_calculator/calculate"

module WorkHoursCalculator
  class Error < StandardError; end

  def self.calculate(work_start, work_end, breaks)
    WorkHoursCalculator::Calculate.new(work_start, work_end, breaks).execute
  end
end
