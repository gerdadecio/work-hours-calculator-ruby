# Work Hours Calculator CLI

Manually calculating work hours, breaks, and net hours in a spreadsheet can be tedious and prone to errors. To streamline the process and ensure accuracy, I created this CLI tool to handle the calculations quickly and easily.

## Description
This is a Ruby command-line tool for calculating the total work hours, break hours, and net work hours (after subtracting breaks) based on provided work start time, end time, and break periods.

## Features
- Calculate total work hours between start and end times.
- Account for multiple break periods.
- Return net work hours after subtracting break times.

## Prerequisites
- Ruby (>= 2.5)
- OptionParser (this is part of the Ruby Standard Library)

## Installation
Clone the repository or copy the script to your local machine.

Make the script executable by running:

```bash
chmod +x bin/work_calculator.rb
```

# Example
To calculate your work hours, run the following command:
```bash
ruby ./bin/work_calculator.rb -s "9:30:00 AM" -e "7:00:00 PM" -b "12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM"
```

## Using CSV Input
You can also use a CSV file to provide the input data. The CSV file should have the following format:
```text
work_start,work_end,breaks
9:00 AM,5:00 PM,"12:00 PM-12:30 PM,3:00 PM-3:15 PM"
```
To calculate your work hours using a CSV file, run the following command:
```bash
ruby ./bin/work_calculator.rb --csv-input path/to/your/input.csv
```
## Exporting Results to CSV
You can export the results to a CSV file by specifying the --csv-output option:
```bash
ruby ./bin/work_calculator.rb -s "9:30:00 AM" -e "7:00:00 PM" -b "12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM" --csv-output path/to/your/output.csv
```

# Expected Output
```bash
Total Work Decimal Hours: 9.5 hours
Total Break Decimal Hours: 1.5 hours
Total Break Hours: 1:30 minutes
Net Work Decimal Hours: 8.0 hours
```

## Usage
Run the script from the command line with the required options for start time, end time, and break periods.

### Command Line Options
| Option | Description | Example |
| -------- | ------- | ------- |
| -s or --start-time | Specifies the work start time | `-s "9:30:00 AM"` |
| -e or --end-time | Specifies the work end time | `-e "6:00:00 PM"` |
| -b or --breaks | Specifies break periods in comma-separated start_time-end_time format | `-b "12:49:00 PM-1:26:00 PM,3:42:00 PM-4:35:00 PM"` |
| --csv-input | Specifies the CSV input file | `--csv-input path/to/your/input.csv`s |
| --csv-output | Specifies the CSV output file | `--csv-output path/to/your/output.csv` |
| -h or --help | Displays help instructions | `-h` |

