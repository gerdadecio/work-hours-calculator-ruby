require "csv"
require "date"
require "time"

module WorkHoursCalculator
  class Logger
    DEFAULT_LOG_DIR = File.join(Dir.home, "work_hours_logs")

    def self.log_work(description, log_dir = DEFAULT_LOG_DIR)
      Dir.mkdir(log_dir) unless Dir.exist?(log_dir)
      log_file = File.join(log_dir, "#{Date.today}.csv")

      CSV.open(log_file, "a") do |csv|
        time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        csv << [time, description]
      end

      puts "Logged work: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} - #{description}"
    end

    def self.get_hours_from_log(date, log_dir = DEFAULT_LOG_DIR)
      log_file = File.join(log_dir, "#{date}.csv")
      unless File.exist?(log_file)
        puts "Log file for #{date} not found."
        exit 1
      end

      entries = CSV.read(log_file, headers: false).map do |row|
        {time: Time.parse(row[0]), description: row[1].strip}
      end

      work_start = entries.find { |entry| entry[:description].downcase != "break" }[:time]
      work_end = entries.reverse.find { |entry| entry[:description].downcase == "end" }[:time]

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
        work_start: work_start.strftime("%I:%M:%S %p"),
        work_end: work_end.strftime("%I:%M:%S %p"),
        breaks: breaks.map { |start, end_time| [start.strftime("%I:%M:%S %p"), end_time.strftime("%I:%M:%S %p")] }
      }
    end
  end
end
