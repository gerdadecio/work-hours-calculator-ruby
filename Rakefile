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
  gem_file = File.join(Dir.pwd, "work_hours_calculator-#{VERSION}.gem")
  begin
    if File.exist?(gem_file)
      puts "Removing existing gem file #{gem_file}"
      File.delete(gem_file)
    end
    sh "gem build work_hours_calculator.gemspec"
    unless File.exist?(gem_file)
      raise "Failed to build gem file"
    end
  rescue => e
    puts "Error building gem: #{e.message}"
    exit 1
  end

  # Publish the gem to RubyGems
  begin
    unless File.exist?(gem_file)
      raise "Gem file not found: #{gem_file}"
    end
    sh "gem push #{gem_file}"
  rescue => e
    puts "Error pushing gem: #{e.message}"
    exit 1
  end
end

desc "Update CHANGELOG.md based on commits from the last tag to the latest tag"
task :update_changelog do
  begin
    tags = `git tag --sort=-v:refname`.lines.map(&:strip)
    raise "No tags found" if tags.empty?
    latest_tag = tags[0]
    previous_tag = tags[1] || "HEAD"
  rescue => e
    puts "Error retrieving tags: #{e.message}"
    return
  end

  date = Time.now.strftime("%Y-%m-%d")

  changelog_entry = "## [#{latest_tag}] - #{date}\n\n"
  changelog_entry += `git log #{previous_tag}..#{latest_tag} --pretty=format:"- %s"`.strip
  changelog_entry += "\n\n"

  changelog_file = "CHANGELOG.md"
  begin
    # Create file if it doesn't exist
    File.write(changelog_file, "") unless File.exist?(changelog_file)

    File.open(changelog_file, "r+") do |file|
      content = file.read
      file.rewind
      file.write(changelog_entry + content)
      file.flush
    end
  rescue => e
    puts "Error updating changelog: #{e.message}"
    return
  end
end

desc "Run the tests"
task :test do
  sh "bundle exec ruby -Ilib -e 'Dir.glob(\"./test/**/*_test.rb\") { |file| require file }'"
end

task :audit do
  sh "bundle exec bundle-audit check --update"
end

task default: %i[test standard]
