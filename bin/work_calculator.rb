# frozen_string_literal: true

require_relative '../lib/work_hours_calculator'
require_relative '../lib/parser'

options = Parser.parse_options
calculator = WorkHoursCalculator.new(options[:start_time], options[:end_time], options[:breaks])
results = calculator.calculate

puts "Total Work Decimal Hours: #{results[:total_work_decimal_hours].round(2)} hours"
puts "Total Break Decimal Hours: #{results[:total_break_decimal_hours].round(2)} hours"
puts "Total Break Hours: #{results[:total_break_hours]} minutes"
puts "Net Work Decimal Hours: #{results[:net_work_decimal_hours].round(2)} hours"
