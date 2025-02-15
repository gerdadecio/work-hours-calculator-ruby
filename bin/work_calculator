#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/work_hours_calculator'
require_relative '../lib/work_hours_calculator/parser'
require_relative '../lib/work_hours_calculator/csv_handler'

options = WorkHoursCalculator::Parser.parse_options

if options[:csv_input]
  data = WorkHoursCalculator::CSVHandler.import(options[:csv_input])
  results = WorkHoursCalculator.calculate(data[:work_start], data[:work_end], data[:breaks])
else
  results = WorkHoursCalculator.calculate(options[:start_time], options[:end_time], options[:breaks])
end

if options[:csv_output]
  WorkHoursCalculator::CSVHandler.export(options[:csv_output], results)
else
  puts "Total Work Decimal Hours: #{results[:total_work_decimal_hours].round(2)} hours"
  puts "Total Break Decimal Hours: #{results[:total_break_decimal_hours].round(2)} hours"
  puts "Total Break Hours: #{results[:total_break_hours]} minutes"
  puts "Net Work Decimal Hours: #{results[:net_work_decimal_hours].round(2)} hours"
end
