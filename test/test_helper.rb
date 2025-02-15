require "simplecov"
require "codeclimate-test-reporter"

SimpleCov.start do
  add_filter "/test/"
end

if ENV["CI"]  # Enable Code Climate coverage reporting in CI environments
  require "simplecov-lcov"
  SimpleCov::Formatter = SimpleCov::Formatter::LcovFormatter
end

CodeClimate::TestReporter.start
