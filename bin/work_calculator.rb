# frozen_string_literal: true

require_relative '../lib/work_hours_calculator'
require_relative '../lib/parser'
require_relative '../lib/csv_handler'

options = Parser.parse_options

if options[:csv_input]
  data = CSVHandler.import(options[:csv_input])
  calculator = WorkHoursCalculator.new(data[:work_start], data[:work_end], data[:breaks])
else
  calculator = WorkHoursCalculator.new(options[:start_time], options[:end_time], options[:breaks])
end

results = calculator.calculate

if options[:csv_output]
  CSVHandler.export(options[:csv_output], results)
else
  puts "Total Work Decimal Hours: #{results[:total_work_decimal_hours].round(2)} hours"
  puts "Total Break Decimal Hours: #{results[:total_break_decimal_hours].round(2)} hours"
  puts "Total Break Hours: #{results[:total_break_hours]} minutes"
  puts "Net Work Decimal Hours: #{results[:net_work_decimal_hours].round(2)} hours"
end
