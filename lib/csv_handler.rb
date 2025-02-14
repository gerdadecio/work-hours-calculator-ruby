# frozen_string_literal: true

require 'csv'
require_relative 'work_hours_calculator'

# Class to handle CSV import and export
class CSVHandler
  def self.import(file_path)
    data = CSV.read(file_path, headers: true)
    work_start = data['work_start'].first
    work_end = data['work_end'].first
    breaks = data['breaks'].first.split(',').map { |b| b.split('-') }
    { work_start: work_start, work_end: work_end, breaks: breaks }
  end

  def self.export(file_path, results)
    CSV.open(file_path, 'w') do |csv|
      csv << ['total_work_decimal_hours', 'total_break_decimal_hours', 'total_break_hours', 'net_work_decimal_hours']
      csv << [results[:total_work_decimal_hours], results[:total_break_decimal_hours], results[:total_break_hours], results[:net_work_decimal_hours]]
    end
  end
end
