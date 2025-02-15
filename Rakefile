# frozen_string_literal: true

require "rake"
require "rake/clean"
require "bundler/gem_tasks"
require "standard/rake"

# Load the version from the version file
VERSION = File.read("lib/work_hours_calculator/version.rb")[/VERSION = "(.+)"/, 1]

desc "Release the gem"
task :release do
  # Ensure the version is specified
  if VERSION.nil? || VERSION.empty?
    puts "Version number not found in lib/work_hours_calculator/version.rb"
    exit 1
  end

  # Tag the latest commit if the tag doesn't already exist
  if `git tag -l v#{VERSION}`.strip == "v#{VERSION}"
    puts "Tag v#{VERSION} already exists. Skipping tagging."
  else
    sh "git tag -a v#{VERSION} -m 'Release version #{VERSION}'"
    sh "git push origin v#{VERSION}"
  end

  # Build the gem
  gem_file = "work_hours_calculator-#{VERSION}.gem"
  if File.exist?(gem_file)
    puts "Gem file #{gem_file} already exists. Skipping build."
  else
    sh "gem build work_hours_calculator.gemspec"
  end

  # Publish the gem to RubyGems
  sh "gem push #{gem_file}"
end

desc "Run the tests"
task :test do
  sh "bundle exec ruby -Ilib -e 'Dir.glob(\"./test/**/*_test.rb\") { |file| require file }'"
end

task :audit do
  sh "bundle exec bundle-audit check --update"
end

task default: %i[test standard]
