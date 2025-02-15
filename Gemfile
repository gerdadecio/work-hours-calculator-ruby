# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake", "~> 13.0"
gem "standard", "~> 1.3"
gem "rexml", "~> 3.2"

group :development do
  gem "overcommit", "~> 0.58.0"
  gem "bundle-audit", "~> 0.1.0"
end

group :development, :test do
  gem "simplecov", "~> 0.21.2", require: false
  gem "simplecov-cobertura", "~> 1.4", require: false
  gem "codecov", require: false
end
