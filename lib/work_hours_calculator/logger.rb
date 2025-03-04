# frozen_string_literal: true

require "csv"
require "date"
require "time"
module WorkHoursCalculator
  class InvalidFile < StandardError; end

  class InvalidDir < StandardError; end

  class InvalidRecord < StandardError; end

  class MissingRecord < StandardError; end

  class Logger
    DEFAULT_LOG_DIR = File.join(Dir.home, "work_hours_logs")
    LOG_DIR = ENV["WORK_HOURS_LOG_DIR"] || DEFAULT_LOG_DIR

    def self.log_work(description, log_dir = LOG_DIR)
      raise InvalidRecord, "Description cannot be empty" if description.nil? || description.strip.empty?

      begin
        Dir.mkdir(log_dir) unless Dir.exist?(log_dir)
      rescue SystemCallError => e
        raise InvalidDir, "Failed to create log directory: #{e.message}"
      end

      log_file = File.join(log_dir, "#{Date.today}.csv")

      begin
        CSV.open(log_file, "a") do |csv|
          time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          csv << [time, description]
        end
      rescue SystemCallError => e
        raise InvalidFile, "Failed to write to log file: #{e.message}"
      end

      puts "Logged work: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} - #{description}"
    end

    def self.get_hours_from_log(date = Date.today, log_dir = DEFAULT_LOG_DIR)
      date ||= Date.today

      log_file = File.join(log_dir, "#{date}.csv")
      unless File.exist?(log_file)
        puts "Log file for #{date} not found."
        exit 1
      end

      entries = CSV.read(log_file, headers: false).map do |row|
        {time: Time.parse(row[0]), description: row[1].strip}
      end

      work_start = entries.find { |entry| entry[:description].downcase != "break" && entry[:description].downcase != "end" }
      work_end = entries.reverse.find { |entry| entry[:description].downcase == "end" }

      raise MissingRecord, "Work start record not found" if work_start.nil?
      raise MissingRecord, "Work end record not found" if work_end.nil?

      work_start_time = work_start[:time]
      work_end_time = work_end[:time]

      breaks = []
      break_start = nil

      entries.each do |entry|
        if entry[:description].downcase == "break" || entry[:description].downcase == "end"
          break_start ||= entry[:time]
        elsif break_start
          breaks << [break_start, entry[:time]]
          break_start = nil
        end
      end

      {
        work_start: work_start_time.strftime("%I:%M:%S %p"),
        work_end: work_end_time.strftime("%I:%M:%S %p"),
        breaks: breaks.map { |start, end_time| [start.strftime("%I:%M:%S %p"), end_time.strftime("%I:%M:%S %p")] }
      }
    end
  end
end
