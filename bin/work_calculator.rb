# frozen_string_literal: true

require_relative '../lib/work_hours_calculator'

options = parse_options
calculator = WorkHoursCalculator.new(options[:start_time], options[:end_time], options[:breaks])
results = calculator.calculate

puts "Total Work Hours: #{results[:total_work_hours].round(2)} hours"
puts "Total Break Hours: #{results[:total_break_hours].round(2)} hours"
puts "Net Work Hours: #{results[:net_work_hours].round(2)} hours"
