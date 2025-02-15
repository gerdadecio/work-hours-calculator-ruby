require_relative "lib/work_hours_calculator/version"

Gem::Specification.new do |spec|
  spec.name = "work_hours_calculator"
  spec.version = WorkHoursCalculator::VERSION
  spec.authors = ["Gerda Decio"]
  spec.email = ["contact@gerdadecio.com"]

  spec.summary = "A command line tool that calculates work hours, break hours, and net work hours."
  spec.description = "This gem provides a command-line tool to calculate total work hours, total break hours, and net work hours based on input times. It supports CSV input and output."
  spec.homepage = "https://github.com/gerdadecio/work-hours-calculator-ruby"
  spec.required_ruby_version = ">= 3.1.0"
  spec.license = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = [
    "bin/work_calculator",
    "lib/work_hours_calculator.rb",
    "lib/work_hours_calculator/version.rb",
    "lib/work_hours_calculator/calculate.rb",
    "lib/work_hours_calculator/parser.rb",
    "lib/work_hours_calculator/csv_handler.rb",
    "LICENCE",
    "README.md"
  ]

  spec.bindir = "bin"
  spec.executables = ["work_calculator"]
  spec.require_paths = ["lib"]

  spec.add_dependency "csv", "~> 3.1"
  spec.add_dependency "mutex_m", "~> 0.1.0"
  spec.add_development_dependency "minitest", "~> 5.14"
end
