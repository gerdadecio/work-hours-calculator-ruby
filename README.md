[![Gem Version](https://badge.fury.io/rb/work_hours_calculator.svg)](https://badge.fury.io/rb/work_hours_calculator)[![Maintainability](https://api.codeclimate.com/v1/badges/f8dae8435980691b04fb/maintainability)](https://codeclimate.com/github/gerdadecio/work-hours-calculator-ruby/maintainability) [![codecov](https://codecov.io/gh/gerdadecio/work-hours-calculator-ruby/graph/badge.svg?token=N87XQ9ELXC)](https://codecov.io/gh/gerdadecio/work-hours-calculator-ruby)
# Work Hours Calculator CLI

Manually calculating work hours, breaks, and net hours in a spreadsheet can be tedious and prone to errors. To streamline the process and ensure accuracy, I created this CLI tool to handle the calculations quickly and easily.

## Description
This is a Ruby command-line tool for calculating the total work hours, break hours, and net work hours (after subtracting breaks) based on provided work start time, end time, and break periods.

## Features
- Calculate total work hours between start and end times.
- Account for multiple break periods.
- Return net work hours after subtracting break times.
- Return net break hours.
- Support for csv import or export.
- Log your work hours for the day.

## Installation

```bash
gem install work_hours_calculator
```

# Example
To calculate your work hours, run the following command:
```bash
work_calculator -s "9:30:00 AM" -e "7:00:00 PM" -b "12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM"
```

### Expected Output
```bash
Total Work Decimal Hours: 9.5 hours
Total Break Decimal Hours: 1.5 hours
Total Break Hours: 1:30 minutes
Net Work Decimal Hours: 8.0 hours
```

## Using CSV Input
You can also use a CSV file to provide the input data. The CSV file should have the following format:
```text
work_start,work_end,breaks
9:00 AM,5:00 PM,"12:00 PM-12:30 PM,3:00 PM-3:15 PM"
```
To calculate your work hours using a CSV file, run the following command:
```bash
work_calculator --csv-input path/to/your/input.csv
```
## Exporting Results to CSV
You can export the results to a CSV file by specifying the --csv-output option:
```bash
work_calculator -s "9:30:00 AM" -e "7:00:00 PM" -b "12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM" --csv-output path/to/your/output.csv
```
## Logging Work Hours for the Day
You can log your work hours throughout the day, much like a diary of your work. To log your work, run the following command:
```bash
work_calculator --log some-description-goes-here
```
Example:
```bash
work_calculator --log "working on an interesting project"
# > Logged work: 2025-02-22 19:47:24 - working on an interesting project

work_calculator --log "break"
# > Logged work: 2025-02-22 19:48:11 - break

work_calculator --log "end"
# > Logged work: 2025-02-22 19:50:01 - end
```
Please note of the system keywords for the description: 
- "break" : considered the record log as a break
- "end" : considered the record log as finished or has ended work for the day.

### Calculate the hours from your work log
```bash
work_calculator --calculate-log "2025-02-22"
# > Total Work Decimal Hours: 3.2 hours
# > Total Break Decimal Hours: 2.15 hours
# > Total Break Hours: 2:09 minutes
# > Net Work Decimal Hours: 1.05 hours
```

## Usage
Run the script from the command line with the required options for start time, end time, and break periods.

### Command Line Options
| Option | Description | Example |
| -------- | ------- | ------- |
| -s or --start-time | Specifies the work start time | `-s "9:30:00 AM"` |
| -e or --end-time | Specifies the work end time | `-e "6:00:00 PM"` |
| -b or --breaks | Specifies break periods in comma-separated start_time-end_time format | `-b "12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM"` |
| -i, --csv-input | Specifies the CSV input file | `--csv-input path/to/your/input.csv`s |
| -o, --csv-output | Specifies the CSV output file | `--csv-output path/to/your/output.csv` |
| -l, --log DESCRIPTION | Log work with description | `--log "working on a project"` |
| -dir, --log-dir DIRECTORY | Specify a directory to store log files | `--lod-dir` <br><br>or export it as an ENV variable so you don't have to specify the directory arg everytime. <br> `export WORK_HOURS_LOG_DIR="/some/path"`|
| -t, --calculate-log DATE | Calculate hours from the log file for the specified date (e.g., '2023-10-01') | `--calculate-log 2025-02-01` |
| -h or --help | Displays help instructions | `-h` |



## TODOS
- Add support for overtimes
- Add support for daily or weekly or monthly summary for csv inputs

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/gerdadecio/work-hours-calculator-ruby](https://github.com/gerdadecio/work-hours-calculator-ruby). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/gerdadecio/work-hours-calculator-ruby/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the WorkHoursCalculator project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/work_hours_calculator/blob/main/CODE_OF_CONDUCT.md).
