# frozen_string_literal: true

require "time"
require "optparse"

module WorkHoursCalculator
  class Error < StandardError; end

  class InvalidTimeError < StandardError; end

  # This class takes a work_start, work_end, and breaks as input,
  # and calculates the total work hours, total break hours, and net work hours.
  class Calculate
    def initialize(work_start, work_end, breaks)
      @work_start_time = parse_time(work_start)
      @work_end_time = parse_time(work_end)
      @breaks = breaks.map { |start, end_time| [parse_time(start), parse_time(end_time)] }

      raise InvalidTimeError, "Work start time is invalid" if @work_start_time.nil?
      raise InvalidTimeError, "Work end time is invalid" if @work_end_time.nil?
    end

    def execute
      total_work_time = @work_end_time - @work_start_time
      total_break_time = @breaks.reduce(0) do |sum, (start, end_time)|
        if start && end_time
          sum + (end_time - start)
        else
          sum
        end
      end
      net_work_time = total_work_time - total_break_time

      {
        total_work_decimal_hours: to_hours(total_work_time),
        total_break_decimal_hours: to_hours(total_break_time),
        total_break_hours: to_hour_and_minutes(to_hours(total_break_time)),
        net_work_decimal_hours: to_hours(net_work_time)
      }
    end

    private

    def parse_time(time_str)
      Time.parse(time_str)
    rescue ArgumentError, TypeError
      nil
    end

    def to_hours(seconds)
      seconds / 3600.0
    end

    def to_hour_and_minutes(hours)
      total_minutes = (hours * 60).round
      hours = total_minutes / 60
      minutes = total_minutes % 60
      format("%d:%02d", hours, minutes)
    end
  end
end
