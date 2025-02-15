require "simplecov"

# Set up LCov formatter for Codecov in CI
if ENV["CI"]
  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

SimpleCov.command_name "Unit Tests"
SimpleCov.start do
  add_filter "/test/"
end

require "minitest/autorun"
